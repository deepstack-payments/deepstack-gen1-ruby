require './DeepStackSDK/DeepStackClient'
require './DeepStackSDK/lib/requests/IRequest'

class AuthorizationRequest < IRequest

    attr_accessor :amount

    def initialize(amount, paymentInstrument)
        @action = "auth"
        @amount = amount
        @paymentInstrument = paymentInstrument
        @options = {
            :avs => "y",
            :isocountrycode => "USA",
            :isocurrencycode => "USD"
        }
    end

    # If the paymentInstrument is a token we still need: ccexp, ccbillingaddress, ccbillingzipcode
    def send(client)
        params = {}
        params = addPaymentInstrument(@paymentInstrument, params)
        params = addAmount(@amount, params)
        client.Send(@action, params, @options)
    end

end