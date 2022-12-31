module KrakenSpotBaseAPIModule
using JSON: parse, json
using HTTP: get, post, escapeuri, Messages.Response
using Base64: base64decode, base64encode
using Nettle: digest

export SpotBaseRESTAPI
export request

struct SpotBaseRESTAPI
    API_KEY::Union{String,Nothing}
    SECRET_KEY::Union{String,Nothing}

    BASE_URL::String
    API_V::Int64
    TIMEOUT::Int64
    HEADERS::Vector{Pair{String,String}}

    SpotBaseRESTAPI() = new(
        nothing,                    # key
        nothing,                    # secret
        "https://api.kraken.com",   # url 
        0,                          # api version
        10,                         # timeout
        Vector{Pair{String,String}}(["User-Agent" => "KrakenEx.jl"])
    )

    SpotBaseRESTAPI(
        key::String,
        secret::String,
        url::String="https://api.kraken.com",
        apiv::Int64=0,
        timeout::Int64=0
    ) = new(
        key,
        secret,
        url,
        apiv,
        timeout,
        Vector{Pair{String,String}}([
            "User-Agent" => "KrakenEx.jl",
            "API-Key" => key
        ])
    )
end

function handle_error(error_string::String)
    # todo: check which error and than throw specific kraken exception
    error(error_string)
end

function handle_response(response::Response, return_raw::Bool=false)
    response_json = []
    try
        if return_raw
            return response.body
        else
            response_json = parse(String(response.body))
        end
    catch error
        handle_error(string(error))
    end

    if response_json["error"] ≠ []
        handle_error(string(response_json["error"][begin]))
    else
        return response_json["result"]
    end
end

function request(
    client::SpotBaseRESTAPI,
    type::String,
    endpoint::String;
    data::Dict=Dict{String,Any}(),
    auth::Bool=false,
    return_raw::Bool=false,
    do_json::Bool=false
)
    url = client.BASE_URL * "/" * string(client.API_V) * endpoint
    headers = deepcopy(client.HEADERS)

    try
        if type == "GET"
            return handle_response(get(url, headers=headers, query=data, readtimeout=client.TIMEOUT), return_raw)
        elseif type == "POST"
            if auth
                if isnothing(client.API_KEY) || isnothing(client.SECRET_KEY)
                    error("Valid API Keys are required for accessing private endpoints.")
                end

                nonce = get_nonce()
                data["nonce"] = nonce

                if do_json
                    data = json(data)
                    push!(headers, "Content-Type" => "application/json")
                else
                    push!(headers, "Content-Type" => "application/x-www-form-urlencoded; charset=utf-8")
                end

                signature = get_kraken_signature(client, endpoint=endpoint, data=data, nonce=nonce)
                push!(headers, "API-Sign" => signature)
            end

            return handle_response(post(url, headers=headers, body=data, readtimeout=client.TIMEOUT), return_raw)
        end

    catch error
        error(string(error))
    end
end

function get_nonce()
    return string(Int64(floor(time() * 1000)))
end

function get_kraken_signature(client::SpotBaseRESTAPI; endpoint::String, data::Union{String,Dict{String,Any}}, nonce::String)
    typeof(data) == String ? post_data = data : post_data = escapeuri(data)

    endpoint = "/" * string(client.API_V) * endpoint
    message = endpoint * transcode(String, digest("sha256", nonce * post_data))
    decoded = base64decode(client.SECRET_KEY)

    return base64encode(transcode(String, digest("sha512", decoded, message)))
end

end