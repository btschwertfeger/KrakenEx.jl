module ExceptionsModule
using Base

#====== E X P O R T S ======#
export KrakenException
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
export KrakenInsufficientAvailableFundsError
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
export KrakenUnknownOrderError
export KrakenUnknownPositionError
export KrakenUnknownAssetPairError
export KrakenUnknownAssetError
export KrakenInvalidUnitError
export KrakenUnavailableError
export KrakenInvalidReferenceIdError
export KrakenUnknownReferenceIdError
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

"""
    KrakenException{T}

Base type for all custom exceptions of this package.
"""
abstract type KrakenException{T} end

#====== E X C E P T I O N S ======#
"""
    KrakenInvalidArgumentsError <: KrakenException{Exception}

The request payload is malformed, incorrect or ambiguous.
"""
Base.@kwdef struct KrakenInvalidArgumentsError <: KrakenException{Exception}
    name::String = "KrakenInvalidArgumentsError"
    description::String = "The request payload is malformed, incorrect or ambiguous"
    msg::String = ""
    message::String = ""
end

"""
    KrakenInvalidArgumentsIndexUnavailableError <: KrakenException{Exception}

Index pricing is unavailable for stop/profit orders on this pair.
"""
Base.@kwdef struct KrakenInvalidArgumentsIndexUnavailableError <: KrakenException{Exception}
    name::String = "KrakenInvalidArgumentsIndexUnavailableError"
    description::String = "Index pricing is unavailable for stop/profit orders on this pair"
    message::String = ""
end

"""
    KrakenPermissionDeniedError <: KrakenException{Exception}

API key doesn't have permission to make this request.
"""
Base.@kwdef struct KrakenPermissionDeniedError <: KrakenException{Exception}
    name::String = "KrakenPermissionDeniedError"
    description::String = "API key doesn't have permission to make this request"
    message::String = ""
end

"""
    KrakenServiceUnavailableError <: KrakenException{Exception}

The matching engine or API is offline.
"""
Base.@kwdef struct KrakenServiceUnavailableError <: KrakenException{Exception}
    name::String = "KrakenServiceUnavailableError"
    description::String = "The matching engine or API is offline"
    message::String = ""
end

"""
    KrakenMarketInOnlyCancelModeError <: KrakenException{Exception}

Request can't be made at this time. Please check system status.
"""
Base.@kwdef struct KrakenMarketInOnlyCancelModeError <: KrakenException{Exception}
    name::String = "KrakenMarketInOnlyCancelModeError"
    description::String = "Request can't be made at this time. Please check system status"
    message::String = ""
end

"""
    KrakenMarketInOnlyPostModeError <: KrakenException{Exception}

Request can't be made at this time. Please check system status.
"""
Base.@kwdef struct KrakenMarketInOnlyPostModeError <: KrakenException{Exception}
    name::String = "KrakenMarketInOnlyPostModeError"
    description::String = "Request can't be made at this time. Please check system status"
    message::String = ""
end

"""
    KrakenDeadlineElapsedError <: KrakenException{Exception}

The request timed out according to the default or specified deadline.
"""
Base.@kwdef struct KrakenDeadlineElapsedError <: KrakenException{Exception}
    name::String = "KrakenDeadlineElapsedError"
    description::String = "The request timed out according to the default or specified deadline"
    message::String = ""
end

"""
    KrakenInvalidAPIKeyError <: KrakenException{Exception}

An invalid API-Key header was supplied.
"""
Base.@kwdef struct KrakenInvalidAPIKeyError <: KrakenException{Exception}
    name::String = "KrakenInvalidAPIKeyError"
    description::String = "An invalid API-Key header was supplied"
    message::String = ""
end

"""
    KrakenInvalidSignatureError <: KrakenException{Exception}

An invalid API-Sign header was supplied.
"""
Base.@kwdef struct KrakenInvalidSignatureError <: KrakenException{Exception}
    name::String = "KrakenInvalidSignatureError"
    description::String = "An invalid API-Sign header was supplied"
    message::String = ""
end

"""
    KrakenInvalidNonceError <: KrakenException{Exception}

An invalid nonce was supplied.
"""
Base.@kwdef struct KrakenInvalidNonceError <: KrakenException{Exception}
    name::String = "KrakenInvalidNonceError"
    description::String = "An invalid nonce was supplied"
    message::String = ""
end

"""
    KrakenInvalidOrderError <: KrakenException{Exception}

Order is invalid.
"""
Base.@kwdef struct KrakenInvalidOrderError <: KrakenException{Exception}
    name::String = "KrakenInvalidOrderError"
    description::String = "Order is invalid"
    message::String = ""
end

"""
    KrakenInvalidPriceError <: KrakenException{Exception}

Price is invalid.
"""
Base.@kwdef struct KrakenInvalidPriceError <: KrakenException{Exception}
    name::String = "KrakenInvalidPriceError"
    description::String = "Price is invalid"
    message::String = ""
end

"""
    KrakenAuthenticationError <: KrakenException{Exception}

Credentials are invalid. 

This can caused by invalid API keys or invalid request payload so that the 
encryption creates invalid payloads.
"""
Base.@kwdef struct KrakenAuthenticationError <: KrakenException{Exception}
    name::String = "KrakenAuthenticationError"
    description::String = "Credentials are invalid"
    message::String = ""
end

"""
    KrakenCannotOpenPositionError <: KrakenException{Exception}

User/tier is ineligible for margin trading.
"""
Base.@kwdef struct KrakenCannotOpenPositionError <: KrakenException{Exception}
    name::String = "KrakenCannotOpenPositionError"
    description::String = "User/tier is ineligible for margin trading"
    message::String = ""
end

"""
    KrakenMarginAllowedExceededError <: KrakenException{Exception}

User has exceeded their margin allowance.
"""
Base.@kwdef struct KrakenMarginAllowedExceededError <: KrakenException{Exception}
    name::String = "KrakenMarginAllowedExceededError"
    description::String = "User has exceeded their margin allowance"
    message::String = ""
end

"""
    KrakenMarginLevelToLowError <: KrakenException{Exception}

Client has insufficient equity or collateral.
"""
Base.@kwdef struct KrakenMarginLevelToLowError <: KrakenException{Exception}
    name::String = "KrakenMarginLevelToLowError"
    description::String = "Client has insufficient equity or collateral"
    message::String = ""
end

"""
    KrakenMarginPositionSizeExceededError <: KrakenException{Exception}

Client would exceed the maximum position size for this pair.
"""
Base.@kwdef struct KrakenMarginPositionSizeExceededError <: KrakenException{Exception}
    name::String = "KrakenMarginPositionSizeExceededError"
    description::String = "Client would exceed the maximum position size for this pair"
    message::String = ""
end

"""
    KrakenInsufficientMarginError <: KrakenException{Exception}

Exchange does not have available funds for this margin trade.
"""
Base.@kwdef struct KrakenInsufficientMarginError <: KrakenException{Exception}
    name::String = "KrakenInsufficientMarginError"
    description::String = "Exchange does not have available funds for this margin trade"
    message::String = ""
end

"""
    KrakenInsufficientFundsError <: KrakenException{Exception}

Client does not have the necessary funds.
"""
Base.@kwdef struct KrakenInsufficientFundsError <: KrakenException{Exception}
    name::String = "KrakenInsufficientFundsError"
    description::String = "Client does not have the necessary funds"
    message::String = ""
end

"""
    KrakenOrderMinimumNotMetError <: KrakenException{Exception}

Order size does not meet ordermin.
"""
Base.@kwdef struct KrakenOrderMinimumNotMetError <: KrakenException{Exception}
    name::String = "KrakenOrderMinimumNotMetError"
    description::String = "Order size does not meet ordermin"
    message::String = ""
end

"""
    KrakenCostMinimumNotMetError <: KrakenException{Exception}

Cost (price * volume) does not meet costmin.
"""
Base.@kwdef struct KrakenCostMinimumNotMetError <: KrakenException{Exception}
    name::String = "KrakenCostMinimumNotMetError"
    description::String = "Cost (price * volume) does not meet costmin"
    message::String = ""
end

"""
    KrakenTickSizeInvalidCheckError <: KrakenException{Exception}

Price submitted is not a valid multiple of the pair's tick_size.
"""
Base.@kwdef struct KrakenTickSizeInvalidCheckError <: KrakenException{Exception}
    name::String = "KrakenTickSizeInvalidCheckError"
    description::String = "Price submitted is not a valid multiple of the pair's tick_size"
    message::String = ""
end

"""
    KrakenOrderLimitsExceededError <: KrakenException{Exception}

Order limits exceeded. Please check your open orders limit.
"""
Base.@kwdef struct KrakenOrderLimitsExceededError <: KrakenException{Exception}
    name::String = "KrakenOrderLimitsExceededError"
    description::String = "Order limits exceeded. Please check your open orders limit"
    message::String = ""
end

"""
    KrakenRateLimitExceededError <: KrakenException{Exception}

API rate limit exceeded. Please check your rate limits.
"""
Base.@kwdef struct KrakenRateLimitExceededError <: KrakenException{Exception}
    name::String = "KrakenRateLimitExceededError"
    description::String = "API rate limit exceeded. Please check your rate limits"
    message::String = ""
end

"""
    KrakenApiLimitExceededError <: KrakenException{Exception}

API rate limit exceeded. Please check your rate limits.
"""
Base.@kwdef struct KrakenApiLimitExceededError <: KrakenException{Exception}
    name::String = "KrakenApiLimitExceededError"
    description::String = "API rate limit exceeded. Please check your rate limits"
    message::String = ""
end

"""
    KrakenPositionLimitExceeded <: KrakenException{Exception}

Position limit exceeded. Please check your limits.
"""
Base.@kwdef struct KrakenPositionLimitExceeded <: KrakenException{Exception}
    name::String = "KrakenPositionLimitExceeded"
    description::String = "Position limit exceeded. Please check your limits"
    message::String = ""
end

"""
    KrakenUnknownOrderError <: KrakenException{Exception}

Order is unknown.
"""
Base.@kwdef struct KrakenUnknownOrderError <: KrakenException{Exception}
    name::String = "KrakenUnknownOrderError"
    description::String = "Order is unknown"
    message::String = ""
end

"""
    KrakenUnknownPositionError <: KrakenException{Exception}

Position is unknown.
"""
Base.@kwdef struct KrakenUnknownPositionError <: KrakenException{Exception}
    name::String = "KrakenUnknownPositionError"
    description::String = "Position is unknown"
    message::String = ""
end

"""
    KrakenUnknownAssetPairError <: KrakenException{Exception}

The asset pair is unknown.
"""
Base.@kwdef struct KrakenUnknownAssetPairError <: KrakenException{Exception}
    name::String = "KrakenUnknownAssetPairError"
    description::String = "The asset pair is unknown"
    message::String = ""
end

"""
    KrakenUnknownAssetError <: KrakenException{Exception}

The asset is unknown.
"""
Base.@kwdef struct KrakenUnknownAssetError <: KrakenException{Exception}
    name::String = "KrakenUnknownAssetError"
    description::String = "The asset is unknown"
    message::String = ""
end

"""
    KrakenInvalidUnitError <: KrakenException{Exception}

The specified unit is invalid.
"""
Base.@kwdef struct KrakenInvalidUnitError <: KrakenException{Exception}
    name::String = "KrakenInvalidUnitError"
    description::String = "The specified unit is invalid"
    message::String = ""
end

"""
    KrakenUnavailableError <: KrakenException{Exception}

The requested resource is unavailable.
"""
Base.@kwdef struct KrakenUnavailableError <: KrakenException{Exception}
    name::String = "KrakenUnavailableError"
    description::String = "The requested resource is unavailable"
    message::String = ""
end

"""
    KrakenInvalidReferenceIdError <: KrakenException{Exception}

The requested referece id is invalid.
"""
Base.@kwdef struct KrakenInvalidReferenceIdError <: KrakenException{Exception}
    name::String = "KrakenInvalidReferenceIdError"
    description::String = "The requested referece id is invalid"
    message::String = ""
end

"""
    KrakenUnknownReferenceIdError <: KrakenException{Exception}

The requested referece id is unknown.
"""
Base.@kwdef struct KrakenUnknownReferenceIdError <: KrakenException{Exception}
    name::String = "KrakenUnknownReferenceIdError"
    description::String = "The requested referece id is unknown"
    message::String = ""
end

"""
    KrakenUnknownWithdrawKeyError <: KrakenException{Exception}

The requested withdrawal key is unknown.
"""
Base.@kwdef struct KrakenUnknownWithdrawKeyError <: KrakenException{Exception}
    name::String = "KrakenUnknownWithdrawKeyError"
    description::String = "The requested withdrawal key is unknown"
    message::String = ""
end

"""
    KrakenInvalidAmountError <: KrakenException{Exception}

The specified amount is invalid.
"""
Base.@kwdef struct KrakenInvalidAmountError <: KrakenException{Exception}
    name::String = "KrakenInvalidAmountError"
    description::String = "The specified amount is invalid"
    message::String = ""
end

"""
    KrakenInvalidStakingMethodError <: KrakenException{Exception}

The staking method is invalid.
"""
Base.@kwdef struct KrakenInvalidStakingMethodError <: KrakenException{Exception}
    name::String = "KrakenInvalidStakingMethodError"
    description::String = "The staking method is invalid"
    message::String = ""
end

"""
    KrakenInvalidAccountError <: KrakenException{Exception}

The account is invalid.
"""
Base.@kwdef struct KrakenInvalidAccountError <: KrakenException{Exception}
    name::String = "KrakenInvalidAccountError"
    description::String = "The account is invalid"
    message::String = ""
end

"""
    KrakenNotFoundError <: KrakenException{Exception}

The resource is not found.
"""
Base.@kwdef struct KrakenNotFoundError <: KrakenException{Exception}
    name::String = "KrakenNotFoundError"
    description::String = "The resource is not found"
    message::String = ""
end

"""
    KrakenOrderForEditNotFoundError <: KrakenException{Exception}

The order for edit could not be found.
"""
Base.@kwdef struct KrakenOrderForEditNotFoundError <: KrakenException{Exception}
    name::String = "KrakenOrderForEditNotFoundError"
    description::String = "The order for edit could not be found"
    message::String = ""
end

"""
    KrakenToManyAdressesError <: KrakenException{Exception}

To many adresses specified.
"""
Base.@kwdef struct KrakenToManyAdressesError <: KrakenException{Exception}
    name::String = "KrakenToManyAdressesError"
    description::String = "To many adresses specified"
    message::String = ""
end

"""
    KrakenInsufficientAvailableFundsError <: KrakenException{Exception}

Client does not have the necessary funds.
"""
Base.@kwdef struct KrakenInsufficientAvailableFundsError <: KrakenException{Exception}
    name::String = "KrakenInsufficientAvailableFundsError"
    description::String = "Client does not have the necessary funds"
    message::String = ""
end

"""
    KrakenInternalServerError <: KrakenException{Exception}

Kraken API INTERNAL_SERVER_ERROR.
"""
Base.@kwdef struct KrakenInternalServerError <: KrakenException{Exception}
    name::String = "KrakenInternalServerError"
    description::String = "INTERNAL_SERVER_ERROR"
    message::String = ""
end

#===== CUSTOM =====#

"""
    MaxReconnectError <: KrakenException{Exception}

To many reconnect tries.
"""
Base.@kwdef struct MaxReconnectError <: KrakenException{Exception}
    name::String = "MaxReconnectError"
    description::String = "To many reconnect tries"
    message::String = ""
end


#====== F U N C T I O N S ======#
Base.showerror(io::IO, e::KrakenException) = print(io, e.name, ": ", e.description, "!\n", e.message)

"""
    get_exception(name::String)

Returns the exception type by name.
"""
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
        "EOrder:Unknown order" => KrakenUnknownOrderError,
        "EOrder:Unknown position" => KrakenUnknownPositionError,
        "EFunding:Invalid reference id" => KrakenInvalidReferenceIdError,
        "EFunding:Unknown reference id" => KrakenUnknownReferenceIdError,
        "EFunding:Unknown withdraw key" => KrakenUnknownWithdrawKeyError,
        "EFunding:Invalid amount" => KrakenInvalidAmountError,
        "EFunding:Invalid staking method" => KrakenInvalidStakingMethodError,
        "EFunding:Too many addresses" => KrakenToManyAdressesError,
        "EFunding:Unknown asset" => KrakenUnknownAssetError,
        "EQuery:Unknown asset" => KrakenUnknownAssetError,
        "EQuery:Unknown asset pair" => KrakenUnknownAssetPairError,

        # futures_trading_errors__________________________
        "authenticationError" => KrakenAuthenticationError,
        "insufficientAvailableFunds" => KrakenInsufficientAvailableFundsError,
        "apiLimitExceeded" => KrakenApiLimitExceededError,
        "Unavailable" => KrakenUnavailableError,
        "invalidUnit" => KrakenInvalidUnitError,
        "invalidArgument" => KrakenInvalidArgumentsError,
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