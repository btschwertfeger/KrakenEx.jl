module FuturesBaseAPIModule
using ..Utils: get_nonce
using ..KrakenExceptionsModule: get_exception
using JSON: parse, json
using HTTP: get, delete, post, put, escapeuri, Messages.Response
using Base64: base64decode, base64encode
using Nettle: digest

#======= E X P O R T S ========#
export FuturesBaseRESTAPI
export request

struct FuturesBaseRESTAPI
    API_KEY::Union{String,Nothing}
    SECRET_KEY::Union{String,Nothing}

    BASE_URL::String
    TIMEOUT::Int64
    HEADERS::Vector{Pair{String,String}}

    FuturesBaseRESTAPI(beta::Bool=false) = new(
        nothing,                        # key
        nothing,                        # secret
        beta ? "demo-futures.kraken.com" : "https://futures.kraken.com",   # url 
        10,                             # timeout
        Vector{Pair{String,String}}(["User-Agent" => "KrakenEx.jl"])
    )

    FuturesBaseRESTAPI(
        key::String,
        secret::String,
        url::String="https://futures.kraken.com",
        timeout::Int64=0,
        beta::Bool=false
    ) = new(
        key,
        secret,
        beta ? "demo-futures.kraken.com" : url,
        timeout,
        Vector{Pair{String,String}}([
            "User-Agent" => "KrakenEx.jl",
            "APIKey" => key
        ])
    )
end

"""
    handle_error(kind::String,message::Dict{String,Any})

TBW
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
            throw(exception(message=json(data)))
        end

        return data

    elseif kind == "check_send_status"
        """Used for futures REST responses"""
        if haskey(data, "sendStatus") && haskey(data, "sendStatus")
            exception = get_exception(data["sendStatus"]["status"])
            if !isnothing(exception)
                throw(exception(message=json(data)))
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
                        throw(exception(message=json(data)))
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
    handle_response(response::Response, return_raw::Bool=false)

Handles incoming responses.
"""
function handle_response(response::Response, return_raw::Bool=false)
    if response.status ∈ ["200", 200]
        if return_raw
            return response.body
        end

        data = []
        try
            data = parse(String(response.body))
            if haskey(data, "error")
                return handle_error("check", data)
            elseif haskey(data, "sendStatus")
                return handle_error("check_send_status", data)
            elseif haskey(data, "batchStatus")
                return handle_error("check_batch_status", data)
            end

            return data
        catch err
            error(err)
        end

        return data
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

TBW
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
        query_string = escapeuri(query_params)
    end

    post_string::String = ""
    if !isnothing(post_params)
        if !do_json
            post_string = escapeuri(post_params)
        else
            post_params = json(post_params)
            post_string = "json=" * escapeuri(post_params)
        end
    end

    if auth
        if isnothing(client.API_KEY) || isnothing(client.SECRET_KEY)
            error("Valid API Keys are required for accessing private endpoints.")
        end

        nonce = get_nonce()
        for value ∈ [
            "Nonce" => nonce,
            "Content-Type" => "application/x-www-form-urlencoded; charset=utf-8",#do_json ? "application/json" : "application/x-www-form-urlencoded; charset=utf-8",
            "Authent" => get_kraken_signature(client, uri, query_string * (!do_json ? post_string : "json=" * (post_params)), nonce)
        ]
            push!(headers, value)
        end
    end

    if method ∈ ["GET", "DELETE"]
        url = client.BASE_URL * uri
        if query_string != ""
            url *= "?" * query_string
        end

        method == "GET" ? method = get : method == delete
        return handle_response(
            method(url, headers=headers, readtimeout=client.TIMEOUT),
            return_raw
        )

    elseif method == "PUT"
        return handle_response(
            put(
                client.BASE_URL * uri * "?" * query_string,
                headers=headers,
                readtimeout=client.TIMEOUT
            ),
            return_raw
        )

    elseif method == "POST"
        return handle_response(post(
                client.BASE_URL * uri * "?" * post_string,
                headers=headers,
                body=post_params,
                readtimeout=client.TIMEOUT
            ),
            return_raw
        )
    else
        error("Unknown method `$method``.")
    end
end

function get_kraken_signature(client::FuturesBaseRESTAPI, endpoint::String, data::String, nonce::String)
    if startswith(endpoint, "/derivatives")
        endpoint = endpoint[begin+length("/derivatives"):end]
    end

    return base64encode(
        transcode(
            String, digest(
                "sha512",
                base64decode(client.SECRET_KEY), # decoded 
                transcode(String, digest("sha256", data * nonce * endpoint)) # message
            )
        )
    )

end

end