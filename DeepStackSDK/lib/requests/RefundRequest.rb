require './DeepStackSDK/DeepStackClient'
require './DeepStackSDK/lib/requests/IRequest'

class RefundRequest < IRequest

    attr_accessor :amount, :transactionID

    def initialize(amount, transactionID=nil)
        @action = "refund"
        @amount = amount
        @transactionID = transactionID
        @options = {}
    end

    def send(client)
        params = {}
        params = addAmount(@amount, params)
        params = addTransactionID(@transactionID, params)
        # puts params
        client.Send(@action, params, @options)
    end

end