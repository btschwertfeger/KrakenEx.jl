module KrakenSpotUserModule
using ..KrakenSpotBaseAPIModule

#======= E X P O R T S ========#
export get_account_balance

#======= F U N C T I O N S ========#

function get_account_balance(client::SpotBaseRESTAPI)
    """https://docs.kraken.com/rest/#operation/getAccountBalance"""
    return request(client, "POST", "/private/Balance"; auth=true)
end
end