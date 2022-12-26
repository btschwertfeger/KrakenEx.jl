module KrakenSpotBaseAPIModule
using HTTP
using JSON
using SHA
using Base64: base64decode, base64encode
using Nettle: digest
#======= Exports ========#

export SpotBaseRESTAPI

export vector_to_string
export request

#======= F U N C T I O N S ========#

# Base.@kwdef 
struct SpotBaseRESTAPI
    API_KEY::Union{String,Nothing}
    SECRET_KEY::Union{String,Nothing}

    BASE_URL::String
    API_V::Int64
    TIMEOUT::Int64
    HEADERS::Vector{Pair{String,String}}

    SpotBaseRESTAPI() = new(
        nothing, # key
        nothing, # secret
        "https://api.kraken.com", # url 
        0, # api version
        10, # max timeout
        Vector{Pair{String,String}}(["User-Agent" => "krakenex-julia-pkg"])
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
        Vector{Pair{String,String}}(["User-Agent" => "krakenex-julia-pkg"])
    )
end

function handle_response(response::HTTP.Messages.Response)

    response_json = []

    try
        response_json = JSON.parse(String(response.body))
    catch error
        error(string(error))
    end
    if response_json["error"] != []
        error("JSON error: " * string(response_json["error"][begin]))
    else
        return response_json["result"]
    end

end

function request(client::SpotBaseRESTAPI, type::String, endpoint::String; data::Union{Dict,Nothing}=nothing, auth::Bool=false)
    url = client.BASE_URL * "/" * string(client.API_V) * endpoint
    isnothing(data) ? data = Dict() : nothing
    headers = deepcopy(client.HEADERS)

    try
        if type == "GET"
            return handle_response(HTTP.get(url, query=data, headers=headers, readtimeout=client.TIMEOUT))
        elseif type == "POST"
            if auth
                if isnothing(client.API_KEY) || isnothing(client.SECRET_KEY)
                    error("Valid API Keys are required for accessing private endpoints.")
                end
                nonce = get_nonce()
                data["nonce"] = nonce
                signature = get_kraken_signature(client, endpoint=endpoint, data=data, nonce=nonce)
                push!(headers, "Content-Type" => "application/x-www-form-urlencoded; charset=utf-8")
                push!(headers, "API-Key" => client.API_KEY)
                push!(headers, "API-Sign" => signature)
            end

            return handle_response(HTTP.post(url, body=data, headers=headers, readtimeout=client.TIMEOUT))
        end

    catch error
        error(String(error))
    end
end

function get_nonce()
    return string(Int64(floor(time() * 1000)))
end

function dict_to_query(data::Dict)
    s = ""
    for i in keys(data)
        s *= i * "=" * data[i] * "&"
    end
    return s[begin:end-1]
end

function get_kraken_signature(client::SpotBaseRESTAPI; endpoint::String, data::Dict, nonce::String)

    endpoint = "/" * string(client.API_V) * endpoint
    message = endpoint * transcode(String, digest("sha256", nonce * dict_to_query(data)))
    decoded = base64decode(client.SECRET_KEY)
    return base64encode(transcode(String, digest("sha512", decoded, message)))
end

function vector_to_string(value)
    """Converts a list to a comme separated str"""
    if typeof(value) === String
        return value
    elseif typeof(value) === Array{String} || typeof(value) === Vector{String}
        if length(value) === 0
            error("Length of List must be greater than 0.")
        end

        result::String = value[begin]
        if length(value) > 1
            for val in value[begin+1:end]
                result *= "," * val
            end
        end
        return result
    else
        error("Input must be Vector{String} or Array{String}.")
    end
end

end