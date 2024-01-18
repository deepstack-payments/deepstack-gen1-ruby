require './DeepStackSDK/DeepStackClient'
require './DeepStackSDK/lib/requests/IRequest'

class VoidRequest < IRequest

    attr_accessor :amount, :transactionID

    def initialize(transactionID=nil)
        @action = "void"
        @transactionID = transactionID
        @options = {}
    end

    def send(client)
        params = {}
        params = addTransactionID(@transactionID, params)
        client.Send(@action, params, @options)
    end

end