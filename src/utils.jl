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

end