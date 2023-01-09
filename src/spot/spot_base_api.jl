module SpotBaseAPIModule
using ..Utils: get_nonce
using ..ExceptionsModule: get_exception
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

"""
    handle_error(data::Dict{String,Any})

Check if the error message is a known Kraken error response
than raise a custom exception or return the data containing the 'error'
"""
function handle_error(data::Dict{String,Any})
    if length(data["error"]) == 0 && haskey(data, "result")
        return data["result"]
    end

    exception = get_exception(data["error"][begin])
    if !isnothing(exception)
        throw(exception(message=json(data)))
    else
        return data
    end
end
"""
    handle_response(response::Response, return_raw::Bool=false)

Handles incoming responses.
"""
function handle_response(response::Response, return_raw::Bool=false)
    if response.status ∉ ["200", 200]
        error(response.status * ": " * String(response.body))
    elseif return_raw
        return response.body
    end

    response_json = []
    try
        response_json = parse(String(response.body))
    catch error
        error("Could not parse response.")
    end

    if haskey(response_json, "error") && response_json["error"] ≠ []
        handle_error(response_json)
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