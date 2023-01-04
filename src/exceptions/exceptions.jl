module KrakenExceptionsModule
using Base

#====== E X P O R T S ======#
export KrakenInvalidArgumentsError
export KrakenInvalidArgumentsIndexUnavailableError
export KrakenPermissionDeniedError
export KrakenServiceUnavailableError
export KrakenMarketInOnlyCancelModeError
export KrakenMarketInOnlyPostModeError
export KrakenDeadlineElapsedError
export KrakenInvalidAPIKeyError
export KrakenInvalidSignatureError
export KrakenInvalidNonceError
export KrakenInvalidOrderError
export KrakenInvalidPriceError
export KrakenAuthenticationError
export KrakenCannotOpenPositionError
export KrakenMarginAllowedExceededError
export KrakenMarginLevelToLowError
export KrakenMarginPositionSizeExceededError
export KrakenInsufficientMarginError
export KrakenInsufficientFundsError
export KrakenOrderMinimumNotMetError
export KrakenCostMinimumNotMetError
export KrakenTickSizeInvalidCheckError
export KrakenOrderLimitsExceededError
export KrakenRateLimitExceededError
export KrakenApiLimitExceededError
export KrakenPositionLimitExceeded
export KrakenUnknownPositionError
export KrakenUnknownAssetPairError
export KrakenUnknownAssetError
export KrakenInvalidUnitError
export KrakenUnavailableError
export KrakenInvalidReferenceIdError
export KrakenUnknownWithdrawKeyError
export KrakenInvalidAmountError
export KrakenInvalidStakingMethodError
export KrakenInvalidAccountError
export KrakenNotFoundError
export KrakenOrderForEditNotFoundError
export KrakenToManyAdressesError
export MaxReconnectError

export showerror
export get_exception


abstract type KrakenException{T} end

#====== E X C E P T I O N S ======#
Base.@kwdef struct KrakenInvalidArgumentsError <: KrakenException{Exception}
    name::String = "KrakenInvalidArgumentsError"
    description::String = "The request payload is malformed, incorrect or ambiguous"
    msg::String = ""
    message::String = ""
end

Base.@kwdef struct KrakenInvalidArgumentsIndexUnavailableError <: KrakenException{Exception}
    name::String = "KrakenInvalidArgumentsIndexUnavailableError"
    description::String = "Index pricing is unavailable for stop/profit orders on this pair"
    message::String = ""
end

Base.@kwdef struct KrakenPermissionDeniedError <: KrakenException{Exception}
    name::String = "KrakenPermissionDeniedError"
    description::String = "API key doesn't have permission to make this request"
    message::String = ""
end

Base.@kwdef struct KrakenServiceUnavailableError <: KrakenException{Exception}
    name::String = "KrakenServiceUnavailableError"
    description::String = "The matching engine or API is offline"
    message::String = ""
end

Base.@kwdef struct KrakenMarketInOnlyCancelModeError <: KrakenException{Exception}
    name::String = "KrakenMarketInOnlyCancelModeError"
    description::String = "Request can't be made at this time. Please check system status"
    message::String = ""
end
Base.@kwdef struct KrakenMarketInOnlyPostModeError <: KrakenException{Exception}
    name::String = "KrakenMarketInOnlyPostModeError"
    description::String = "Request can't be made at this time. Please check system status"
    message::String = ""
end

Base.@kwdef struct KrakenDeadlineElapsedError <: KrakenException{Exception}
    name::String = "KrakenDeadlineElapsedError"
    description::String = "The request timed out according to the default or specified deadline"
    message::String = ""
end

Base.@kwdef struct KrakenInvalidAPIKeyError <: KrakenException{Exception}
    name::String = "KrakenInvalidAPIKeyError"
    description::String = "An invalid API-Key header was supplied"
    message::String = ""
end

Base.@kwdef struct KrakenInvalidSignatureError <: KrakenException{Exception}
    name::String = "KrakenInvalidSignatureError"
    description::String = "An invalid API-Sign header was supplied"
    message::String = ""
end

Base.@kwdef struct KrakenInvalidNonceError <: KrakenException{Exception}
    name::String = "KrakenInvalidNonceError"
    description::String = "An invalid nonce was supplied"
    message::String = ""
end

Base.@kwdef struct KrakenInvalidOrderError <: KrakenException{Exception}
    name::String = "KrakenInvalidOrderError"
    description::String = "Order is invalid"
    message::String = ""
end

Base.@kwdef struct KrakenInvalidPriceError <: KrakenException{Exception}
    name::String = "KrakenInvalidPriceError"
    description::String = "Price is invalid"
    message::String = ""
end

Base.@kwdef struct KrakenAuthenticationError <: KrakenException{Exception}
    name::String = "KrakenAuthenticationError"
    description::String = "Credentials are invalid"
    message::String = ""
end

Base.@kwdef struct KrakenCannotOpenPositionError <: KrakenException{Exception}
    name::String = "KrakenCannotOpenPositionError"
    description::String = "User/tier is ineligible for margin trading"
    message::String = ""
end

Base.@kwdef struct KrakenMarginAllowedExceededError <: KrakenException{Exception}
    name::String = "KrakenMarginAllowedExceededError"
    description::String = "User has exceeded their margin allowance"
    message::String = ""
end

Base.@kwdef struct KrakenMarginLevelToLowError <: KrakenException{Exception}
    name::String = "KrakenMarginLevelToLowError"
    description::String = "Client has insufficient equity or collateral"
    message::String = ""
end

Base.@kwdef struct KrakenMarginPositionSizeExceededError <: KrakenException{Exception}
    name::String = "KrakenMarginPositionSizeExceededError"
    description::String = "Client would exceed the maximum position size for this pair"
    message::String = ""
end

Base.@kwdef struct KrakenInsufficientMarginError <: KrakenException{Exception}
    name::String = "KrakenInsufficientMarginError"
    description::String = "Exchange does not have available funds for this margin trade"
    message::String = ""
end

Base.@kwdef struct KrakenInsufficientFundsError <: KrakenException{Exception}
    name::String = "KrakenInsufficientFundsError"
    description::String = "Client does not have the necessary funds"
    message::String = ""
end

Base.@kwdef struct KrakenOrderMinimumNotMetError <: KrakenException{Exception}
    name::String = "KrakenOrderMinimumNotMetError"
    description::String = "Order size does not meet ordermin"
    message::String = ""
end

Base.@kwdef struct KrakenCostMinimumNotMetError <: KrakenException{Exception}
    name::String = "KrakenCostMinimumNotMetError"
    description::String = "Cost (price * volume) does not meet costmin"
    message::String = ""
end

Base.@kwdef struct KrakenTickSizeInvalidCheckError <: KrakenException{Exception}
    name::String = "KrakenTickSizeInvalidCheckError"
    description::String = "Price submitted is not a valid multiple of the pair's tick_size"
    message::String = ""
end

Base.@kwdef struct KrakenOrderLimitsExceededError <: KrakenException{Exception}
    name::String = "KrakenOrderLimitsExceededError"
    description::String = "Order limits exceeded. Please check your open orders limit"
    message::String = ""
end

Base.@kwdef struct KrakenRateLimitExceededError <: KrakenException{Exception}
    name::String = "KrakenRateLimitExceededError"
    description::String = "API rate limit exceeded. Please check your rate limits"
    message::String = ""
end

Base.@kwdef struct KrakenApiLimitExceededError <: KrakenException{Exception}
    name::String = "KrakenApiLimitExceededError"
    description::String = "API rate limit exceeded. Please check your rate limits"
    message::String = ""
end

Base.@kwdef struct KrakenPositionLimitExceeded <: KrakenException{Exception}
    name::String = "KrakenPositionLimitExceeded"
    description::String = "Position limit exceeded. Please check your limits"
    message::String = ""
end

Base.@kwdef struct KrakenUnknownPositionError <: KrakenException{Exception}
    name::String = "KrakenUnknownPositionError"
    description::String = "Position is unknown"
    message::String = ""
end

Base.@kwdef struct KrakenUnknownAssetPairError <: KrakenException{Exception}
    name::String = "KrakenUnknownAssetPairError"
    description::String = "The asset pair is unknown"
    message::String = ""
end

Base.@kwdef struct KrakenUnknownAssetError <: KrakenException{Exception}
    name::String = "KrakenUnknownAssetError"
    description::String = "The asset is unknown"
    message::String = ""
end

Base.@kwdef struct KrakenInvalidUnitError <: KrakenException{Exception}
    name::String = "KrakenInvalidUnitError"
    description::String = "The specified unit is invalid."
    message::String = ""
end

Base.@kwdef struct KrakenUnavailableError <: KrakenException{Exception}
    name::String = "KrakenUnavailableError"
    description::String = "The requested resource is unavailable"
    message::String = ""
end

Base.@kwdef struct KrakenInvalidReferenceIdError <: KrakenException{Exception}
    name::String = "KrakenInvalidReferenceIdError"
    description::String = "The requested referece id is invalid"
    message::String = ""
end

Base.@kwdef struct KrakenUnknownWithdrawKeyError <: KrakenException{Exception}
    name::String = "KrakenUnknownWithdrawKeyError"
    description::String = "The requested withdrawal key is unknown"
    message::String = ""
end

Base.@kwdef struct KrakenInvalidAmountError <: KrakenException{Exception}
    name::String = "KrakenInvalidAmountError"
    description::String = "The specified amount is invalid"
    message::String = ""
end

Base.@kwdef struct KrakenInvalidStakingMethodError <: KrakenException{Exception}
    name::String = "KrakenInvalidStakingMethodError"
    description::String = "The staking method is invalid"
    message::String = ""
end

Base.@kwdef struct KrakenInvalidAccountError <: KrakenException{Exception}
    name::String = "KrakenInvalidAccountError"
    description::String = "The account is invalid"
    message::String = ""
end

Base.@kwdef struct KrakenNotFoundError <: KrakenException{Exception}
    name::String = "KrakenNotFoundError"
    description::String = "The resource is not found"
    message::String = ""
end

Base.@kwdef struct KrakenOrderForEditNotFoundError <: KrakenException{Exception}
    name::String = "KrakenOrderForEditNotFoundError"
    description::String = "The order for edit could not be found"
    message::String = ""
end

Base.@kwdef struct KrakenToManyAdressesError <: KrakenException{Exception}
    name::String = "KrakenToManyAdressesError"
    description::String = "To many adresses specified"
    message::String = ""
end
Base.@kwdef struct KrakenInsufficientAvailavleFundsError <: KrakenException{Exception}
    name::String = "KrakenInsufficientAvailavleFundsError"
    description::String = "Client does not have the necessary funds"
    message::String = ""
end

#===== CUSTOM =====#
Base.@kwdef struct MaxReconnectError <: KrakenException{Exception}
    name::String = "MaxReconnectError"
    description::String = "To many reconnect tries"
    message::String = ""
end

Base.@kwdef struct KrakenInternalServerError <: KrakenException{Exception}
    name::String = "KrakenInternalServerError"
    description::String = "INTERNAL_SERVER_ERROR"
    message::String = ""
end


#====== F U N C T I O N S ======#
Base.showerror(io::IO, e::KrakenException) = print(io, e.name, ": ", e.description, "!\n", e.message)


function get_exception(name::String)
    exception_assignment = Dict(
        # spot/margin_trading_rrors______________________
        "EGeneral:Invalid arguments" => KrakenInvalidArgumentsError,
        "EGeneral:Invalid arguments:Index unavailable" => KrakenInvalidArgumentsIndexUnavailableError,
        "EGeneral:Permission denied" => KrakenPermissionDeniedError,
        "EService:Unavailable" => KrakenServiceUnavailableError,
        "EService:Market in cancel_only mode" => KrakenMarketInOnlyCancelModeError,
        "EService:Market in post_only mode" => KrakenMarketInOnlyPostModeError,
        "EService:Deadline elapsed" => KrakenDeadlineElapsedError,
        "EAPI:Invalid key" => KrakenInvalidAPIKeyError,
        "EAPI:Invalid signature" => KrakenInvalidSignatureError,
        "EAPI:Invalid nonce" => KrakenInvalidNonceError,
        "EOrder:Invalid order" => KrakenInvalidOrderError,
        "EOrder:Invalid price" => KrakenInvalidPriceError,
        "EOrder:Cannot open position" => KrakenCannotOpenPositionError,
        "EOrder:Margin allowance exceeded" => KrakenMarginAllowedExceededError,
        "EOrder:Margin level too low" => KrakenMarginLevelToLowError,
        "EOrder:Margin position size exceeded" => KrakenMarginPositionSizeExceededError,
        "EOrder:Insufficient margin" => KrakenInsufficientMarginError,
        "EOrder:Insufficient funds" => KrakenInsufficientFundsError,
        "EOrder:Order minimum not met" => KrakenOrderMinimumNotMetError,
        "EOrder:Cost minimum not met" => KrakenCostMinimumNotMetError,
        "EOrder:Tick size check failed" => KrakenTickSizeInvalidCheckError,
        "EOrder:Orders limit exceeded" => KrakenOrderLimitsExceededError,
        "EOrder:Rate limit exceeded" => KrakenRateLimitExceededError,
        "EOrder:Positions limit exceeded" => KrakenPositionLimitExceeded,
        "EOrder:Unknown position" => KrakenUnknownPositionError,
        "EFunding:Invalid reference id" => KrakenInvalidReferenceIdError,
        "EFunding:Unknown withdraw key" => KrakenUnknownWithdrawKeyError,
        "EFunding:Invalid amount" => KrakenInvalidAmountError,
        "EFunding:Invalid staking method" => KrakenInvalidStakingMethodError,
        "EFunding:Too many addresses" => KrakenToManyAdressesError,
        "EFunding:Unknown asset" => KrakenUnknownAssetError,
        "EQuery:Unknown asset" => KrakenUnknownAssetError,
        "EQuery:Unknown asset pair" => KrakenUnknownAssetPairError,

        # futures_trading_errors__________________________
        "authenticationError" => KrakenAuthenticationError,
        "insufficientAvailableFunds" => KrakenInsufficientAvailavleFundsError,
        "apiLimitExceeded" => KrakenApiLimitExceededError,
        "invalidUnit" => KrakenInvalidUnitError,
        "Unavailable" => KrakenUnavailableError,
        "invalidAccount" => KrakenInvalidAccountError,
        "notFound" => KrakenNotFoundError,
        "orderForEditNotFound" => KrakenOrderForEditNotFoundError, "INTERNAL_SERVER_ERROR" => KrakenInternalServerError
    )

    if haskey(exception_assignment, name)
        return exception_assignment[name]
    else
        return nothing
    end
end

end