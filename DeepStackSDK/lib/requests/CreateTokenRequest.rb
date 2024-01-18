require './DeepStackSDK/lib/models/PaymentInstrumentCard'
require './DeepStackSDK/DeepStackClient'
require './DeepStackSDK/lib/requests/IRequest'

class CreateTokenRequest < IRequest

    def initialize(creditCard)
        @action = "gettoken"
        @creditCard = creditCard
        @options = {}
    end

    def send(client)
        params = {}
        # params = params.merge(JSON.parse(@creditCard.to_json))
        params = addPaymentInstrument(@creditCard, params)
        # puts @options
        client.Send(@action, params, @options)
    end
end