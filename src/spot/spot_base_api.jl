module SpotBaseAPIModule
using ..Utils: get_nonce
using ..ExceptionsModule: get_exception
using Base64
using HTTP
using JSON
using Nettle

#======= E X P O R T S ========#
export SpotBaseRESTAPI
export request

"""
    SpotBaseRESTAPI

Type that stores information about the client and can be used
to access public and private endpoints of the Kraken API for 
Spot trading.

# Fields

- `key`  -- Kraken Spot API key
- `secret` -- Kraken Spot Secret key

Defualt:
- `BASE_URL`  -- Kraken Spot API base url (default: "https://api.kraken.com")
- `API_V`  -- Kraken Spot API version (default: 0)
- `TIMEOUT`  -- Request timeout (default: 10)
- `HEADERS`  -- Default headers {default: ["User-Agent" => "KrakenEx.jl"]}

# Examples

- `SpotBaseRESTAPI()` -- default, public client

- `SpotBaseRESTAPI(key="the-api-key", secret="the-api-secret-key")` -- authenticated client for public and private requests
"""
Base.@kwdef struct SpotBaseRESTAPI
    key::Union{String,Nothing} = nothing
    secret::Union{String,Nothing} = nothing
    BASE_URL::String = "https://api.kraken.com"
    API_V::Int64 = 0
    TIMEOUT::Int64 = 10
    HEADERS::Vector{Pair{String,String}} = ["User-Agent" => "KrakenEx.jl"]
end

"""
    handle_error(data::Dict{String,Any})

Check if the error message is a known Kraken error response
than raise a custom exception or return the data containing the `error`.
"""
function handle_error(data::Dict{String,Any})
    if length(data["error"]) == 0 && haskey(data, "result")
        return data["result"]
    end

    exception = get_exception(data["error"][begin])
    if !isnothing(exception)
        throw(exception(message=JSON.json(data)))
    else
        return data
    end
end

"""
    handle_response(response::HTTP.Response, return_raw::Bool=false)

Parses and returns the `response` and calls `handle_error` if required.
"""
function handle_response(response::HTTP.Response, return_raw::Bool=false)
    if response.status ∉ ["200", 200]
        error(response.status * ": " * String(response.body))
    elseif return_raw
        return response.body
    end

    response_json = []
    try
        response_json = JSON.parse(String(response.body))
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

Manages sending requests to Kraken, handles errors and returns the responses. 
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
        return handle_response(HTTP.get(url, headers=headers, query=data, readtimeout=client.TIMEOUT), return_raw)
    elseif type == "POST"
        if auth
            if isnothing(client.key) || isnothing(client.secret)
                error("Valid API Keys are required for accessing private endpoints.")
            end

            nonce = get_nonce()
            data["nonce"] = nonce

            if do_json
                data = JSON.json(data)
                push!(headers, "Content-Type" => "application/json")
            else
                push!(headers, "Content-Type" => "application/x-www-form-urlencoded; charset=utf-8")
            end

            push!(headers, "API-Sign" => get_kraken_signature(client, endpoint=endpoint, data=data, nonce=nonce))
            push!(headers, "API-Key" => client.key)
        end

        return handle_response(HTTP.post(url, headers=headers, body=data, readtimeout=client.TIMEOUT), return_raw)
    end
end

"""
    get_kraken_signature(
        client::SpotBaseRESTAPI;
        endpoint::String,
        data::Union{String,Dict{String,Any}},
        nonce::String
    )

Returns a signed message based on `endpoint`, `data` and `nonce` using the `secret` - key
of the `client::FuturesBaseRESTAPI`.
"""
function get_kraken_signature(
    client::SpotBaseRESTAPI;
    endpoint::String,
    data::Union{String,Dict{String,Any}},
    nonce::String
)
    typeof(data) == String ? post_data = data : post_data = HTTP.escapeuri(data)
    endpoint = "/" * string(client.API_V) * endpoint
    return Base64.base64encode(
        transcode(
            String, Nettle.digest(
                "sha512",
                Base64.base64decode(client.secret), # decoded 
                endpoint * transcode(String, Nettle.digest("sha256", nonce * post_data)) # message
            )
        )
    )
end

end