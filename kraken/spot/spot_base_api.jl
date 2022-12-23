module KrakenSpotBaseAPIModule
using HTTP
using JSON

#======= Exports ========#

export SpotBaseRESTAPI

export array_to_string
export request

#======= F U N C T I O N S ========#

mutable struct SpotBaseRESTAPI
    API_KEY::String
    SECRET_KEY::String
    
    BASE_URL::String
    API_V::Int64
    TIMEOUT::Int64
    
    SpotBaseRESTAPI() = new("", "", "https://api.kraken.com", 0, 10)
    SpotBaseRESTAPI(key::String="", secret::String="", url::String="https://api.kraken.com", apiv::Int64=0, timeout::Int64=0) = new(key, secret, url, apiv, timeout)
end


function handle_response(response::HTTP.Messages.Response)
    
    response_json = []
 
    try
        response_json = JSON.parse(String(response.body))
    catch error
        error(String(error))
    end
    if response_json["error"] != []
        error("JSON error: "*string(response_json["error"][1]))
    else
        return response_json["result"]
    end

end

function request(client::SpotBaseRESTAPI, type::String, endpoint::String; data=nothing, headers=[], auth::Bool=false)
    url = client.BASE_URL * "/" * string(client.API_V) * endpoint

    # todo:  set default headers
    try
        if type == "GET"
            resp = HTTP.get(url, query=data, readtimeout=client.TIMEOUT)
            return handle_response(resp)
            
        elseif type == "POST"
            if !auth
                return handle_response(HTTP.post(url, body=data, headers=header, readtimeout=client.TIMEOUT))
            end
        end

    catch error
        error(String(error))
    end
end

function get_nonce()
    return string(Int64(floor(time()*1000)))
end

function dict_to_query(data::Dict)
    s = ""
    for i in keys(data)
        s *= i * "=" * data[i] * "&"
    end
    return s[1:end-1]
end

function get_kraken_signature(func::String, postdata::Dict, nonce::String)
    endpoint = "/" * string(api_version) * func
    message = endpoint * transcode(String, digest("sha256", nonce*dict_to_query(postdata)))
    decoded = base64decode(api_secret)
    return base64encode(transcode(String, digest("sha512", decoded, message)))
end

function get_server_time()
    return request("GET", "/public/Time")["unixtime"]
end

function array_to_string(value)
    """Converts a list to a comme separated str"""
    if typeof(value) === String return value
    end
    if typeof(value) === Array
        result::String = ""
        for val in eachindex(value)
            result *= "," * val
        end
        return result
    end
end

end