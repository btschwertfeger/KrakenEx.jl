module FuturesBaseAPIModule
using ..ExceptionsModule: get_exception
using ..Utils: get_nonce
using Base64
using HTTP
using JSON
using Nettle
using StringEncodings

#======= E X P O R T S ========#
export FuturesBaseRESTAPI
export request

"""
    FuturesBaseRESTAPI

Type that stores information about the client and can be used
to access public and private endpoints of the Kraken API for 
Futures trading.

# Fields

- `key`  -- Kraken Futures API key
- `secret` -- Kraken Futures Secret key

Defualt:
- `BASE_URL`  -- Kraken Futures API base url (default: "https://futures.kraken.com")
- `DEMO_URL`  -- Kraken Futures API demo environment url (default: "https://demo-futures.kraken.com")
- `DEMO`  -- Switch to use demo environment (default: false)
- `TIMEOUT`  -- Request timeout (default: 10)
- `HEADERS`  -- Default headers (default: ["User-Agent" => "KrakenEx.jl"])

# Examples

- `FuturesBaseRESTAPI()` -- default, public client

- `FuturesBaseRESTAPI(key="the-api-key", secret="the-api-secret-key")` -- authenticated client for public and private requests
"""
Base.@kwdef struct FuturesBaseRESTAPI
    key::Union{String,Nothing} = nothing
    secret::Union{String,Nothing} = nothing
    BASE_URL::String = "https://futures.kraken.com"
    DEMO_URL::String = "https://demo-futures.kraken.com"
    DEMO::Bool = false
    TIMEOUT::Int64 = 10
    HEADERS::Vector{Pair{String,String}} = ["User-Agent" => "KrakenEx.jl"]
end


"""
    handle_error(kind::String,message::Dict{String,Any})

Handles the error of a request.
"""
function handle_error(kind::String, data::Dict{String,Any})
    if kind == "check"
        """
        Check if the error message is a known Kraken error response
        than raise a custom exception or return the data containing the `error`
        """

        if haskey(data, "error") && length(data["error"]) == 0 && haskey(data, "result")
            return data["result"]
        end

        exception = get_exception(data["error"])

        if !isnothing(exception)
            throw(exception(message=JSON.json(data)))
        else
            return data
        end

    elseif kind == "check_send_status"
        """Used for futures REST responses"""
        if haskey(data, "sendStatus") && haskey(data, "sendStatus")
            exception = get_exception(data["sendStatus"]["status"])
            if !isnothing(exception)
                throw(exception(message=JSON.json(data)))
            end
        end
        return data

    elseif kind == "check_batch_status"
        """Used for futures REST batch order responses"""
        if haskey(data, "batchStatus")
            batch_status = data["batchStatus"]
            for status ∈ batch_status
                if haskey(status, "status")
                    exception = get_exception(status["status"])
                    if !isnothing(exception)
                        throw(exception(message=JSON.json(data)))
                    end
                end
            end
            return data

        else
            error("Unknown `handle_error` call: $kind")
        end
    end
end


"""
    handle_response(response::HTTP.Response, return_raw::Bool=false)

Handles incoming responses, returns the response and/or handles the error.
"""
function handle_response(response::HTTP.Response, return_raw::Bool=false)
    if response.status ∈ ["200", 200]
        if return_raw
            return response.body
        end

        data = String(response.body)
        try
            data = JSON.parse(data)
        catch err
            return data
            # error(err)
        end

        if typeof(data) == Vector{Any}
            return data
        end

        if haskey(data, "error")
            return handle_error("check", data)
        elseif haskey(data, "sendStatus")
            return handle_error("check_send_status", data)
        elseif haskey(data, "batchStatus")
            return handle_error("check_batch_status", data)
        else
            return data
        end
    else
        error(response.status * ": " * response.body)
    end
end

"""
    request(
        client::FuturesBaseRESTAPI,
        method::String,
        uri::String;
        query_params::Union{Dict{String,Any},Nothing}=nothing,
        post_params::Union{Dict{String,Any},Nothing}=nothing,
        auth::Bool=false
    )

Manages sending requests to Kraken, handles errors and returns the responses. 
"""
function request(
    client::FuturesBaseRESTAPI,
    method::String,
    uri::String;
    query_params::Union{Dict{String,Any},Nothing}=nothing,
    post_params::Union{Dict{String,Any},Nothing}=nothing,
    auth::Bool=false,
    return_raw::Bool=false,
    do_json::Bool=false
)
    method = uppercase(method)
    headers = deepcopy(client.HEADERS)

    query_string::String = ""
    if !isnothing(query_params)
        query_string = HTTP.escapeuri(query_params)
    end

    post_string::String = ""
    if !isnothing(post_params)
        if !do_json
            post_string = HTTP.escapeuri(post_params)
        else
            post_params = JSON.json(post_params)
            post_string = "json=" * HTTP.escapeuri(post_params)
        end
    end

    if auth
        if isnothing(client.key) || isnothing(client.secret)
            throw(KrakenAuthenticationError(
                message="Valid API keys are required for accessing private endpoints."
            ))
        end

        nonce = get_nonce() * "0001"
        for value ∈ [
            "Nonce" => nonce,
            "Content-Type" => "application/x-www-form-urlencoded; charset=utf-8",
            "APIKey" => client.key,
            "Authent" => get_kraken_signature(client, uri, query_string * (!do_json ? post_string : "json=" * (post_params)), nonce)
        ]
            push!(headers, value)
        end
    end

    url = client.DEMO ? client.DEMO_URL : client.BASE_URL

    if method ∈ ["GET", "DELETE"]
        url *= uri
        if query_string != ""
            url *= "?" * query_string
        end

        method == "GET" ? method = HTTP.get : method == HTTP.delete
        return handle_response(
            method(url, headers=headers, readtimeout=client.TIMEOUT),
            return_raw
        )

    elseif method == "PUT"
        return handle_response(
            HTTP.put(
                url * uri * "?" * query_string,
                body=query_params,
                headers=headers,
                readtimeout=client.TIMEOUT
            ),
            return_raw
        )

    elseif method == "POST"
        post_string != "" ? post_string = "?$post_string" : ""
        return handle_response(HTTP.post(
                url * uri * post_string,
                headers=headers,
                body=post_params,
                readtimeout=client.TIMEOUT
            ),
            return_raw
        )
    else
        error("Unknown method `$method`.")
    end
end

"""
    get_kraken_signature(
        client::FuturesBaseRESTAPI,
        endpoint::String,
        data::String, 
        nonce::String
    )

Returns a signed message based on `endpoint`, `data` and `nonce` using the `secret` - key
of the `client::FuturesBaseRESTAPI`.
"""
function get_kraken_signature(
    client::FuturesBaseRESTAPI,
    endpoint::String,
    data::String,
    nonce::String
)
    if startswith(endpoint, "/derivatives")
        endpoint = endpoint[begin+length("/derivatives"):end]
    end

    return Base64.base64encode(
        transcode(
            String, Nettle.digest(
                "sha512",
                Base64.base64decode(client.secret), # decoded 
                transcode(
                    String,
                    Nettle.digest(
                        "sha256",
                        StringEncodings.encode(data * nonce * endpoint, "utf-8")
                    )
                ) # message
            )
        )
    )

end

end