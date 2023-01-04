module Utils

export vector_to_string

function vector_to_string(value::Union{String,Vector{String},Array{String}})
    """Converts a list to a comma separated str"""
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
    end
end

"""
    get_nonce()

As of https://docs.kraken.com/rest/#section/General-Usage/Requests-Responses-and-Errors (January, 2023):
"Nonce must be an always increasing, unsigned 64-bit integer, for each request that is made with a particular API key.
While a simple counter would provide a valid nonce, a more usual method of generating a valid nonce is to use e.g. a 
UNIX timestamp in milliseconds."
"""
function get_nonce()
    return string(Int64(floor(time() * 1000)))
end

end