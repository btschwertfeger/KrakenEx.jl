module SpotBaseAPIModule
using ..Utils: get_nonce
using Base64: base64decode, base64encode
using HTTP: Messages.Response, escapeuri, get, post
using JSON: json, parse
using Nettle: digest

#======= E X P O R T S ========#
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

"""
    handle_response(response::Response, return_raw::Bool=false)

Handles incoming responses.
"""
function handle_response(response::Response, return_raw::Bool=false)
    if return_raw
        return response.body
    end

    response_json = []
    try
        response_json = parse(String(response.body))
    catch error
        return handle_error(string(error))
    end

    if response_json["error"] ≠ []
        handle_error(string(response_json["error"][begin]))
    else
        return response_json["result"]
    end
end

"""
    request(
        client::SpotBaseRESTAPI,
        type::String,
        endpoint::String;
        data::Dict=Dict{String,Any}(),
        auth::Bool=false,
        return_raw::Bool=false,
        do_json::Bool=false
    )

Executes requests using the client structure to perform unauthenticated and authenticated requests.
"""
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

                push!(headers, "API-Sign" => get_kraken_signature(client, endpoint=endpoint, data=data, nonce=nonce))
            end

            return handle_response(post(url, headers=headers, body=data, readtimeout=client.TIMEOUT), return_raw)
        end

    catch err
        error(string(err))
    end
end


"""
    get_kraken_signature(client::SpotBaseRESTAPI; endpoint::String, data::Union{String,Dict{String,Any}}, nonce::String)

Returns a signed String
"""
function get_kraken_signature(client::SpotBaseRESTAPI; endpoint::String, data::Union{String,Dict{String,Any}}, nonce::String)
    typeof(data) == String ? post_data = data : post_data = escapeuri(data)
    endpoint = "/" * string(client.API_V) * endpoint
    return base64encode(
        transcode(
            String, digest(
                "sha512",
                base64decode(client.SECRET_KEY), # decoded 
                endpoint * transcode(String, digest("sha256", nonce * post_data)) # message
            )
        )
    )
end

end