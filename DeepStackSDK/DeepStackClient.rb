require 'uri'
require 'net/http'
require 'net/https'

require './DeepStackSDK/lib/requests/CreateTokenRequest'
require './DeepStackSDK/lib/requests/AuthorizationRequest'
require './DeepStackSDK/lib/requests/RefundRequest'
require './DeepStackSDK/lib/requests/CaptureRequest'
require './DeepStackSDK/lib/models/PaymentInstrumentCard.rb'
require './DeepStackSDK/lib/requests/SaleRequest'
require './DeepStackSDK/lib/requests/VoidRequest'




class DeepStackClient

    def initialize(api_username, api_password, client_id, isProduction = false)
        @api_username = api_username
        @api_password = api_password
        @client_id = client_id
        @isProduction = isProduction
        @url = isProduction ? 'https://salecctxngpg.net/default.aspx' : 'https://sandbox.transactions.gpgway.com/'
        # puts @url
    end


    def Send(action, params, options)
        headers = getHeaders()
        params = params.merge({:transactiontype => action})
        params = addCredentials(params)
        params = addOptions(params, options)

        # Create request (url-encoded)
        begin
            uri = URI(@url)
            # uri = URI(uri)
            https = Net::HTTP.new(uri.host, uri.port)
            https.use_ssl = true
            req = Net::HTTP::Post.new(uri.path, init_header = headers)
            req.body = URI.encode_www_form(params)
            response = https.request(req)
            if response.code != "200"
                raise "Bad request... code: " + response.code + " message: " + response.message
            end
            # puts response.body
            jResponse = parseResponse(response)
            # puts jResponse
            return JSON.parse(jResponse)
        rescue => exception
            puts exception
        end
    end

    # Adding specific Options fields
    def addOptions(params, options)
        if options.empty?
            params
        else
            params.merge(options)
        end
    end
    def addCredentials(params)
        params.merge({
            :clientid => @client_id,
            :apiusername => @api_username,
            :apipassword => @api_password
        })
    end
    # Request related helpers

    def parseResponse(response)
        if(response.body.index("\n"))
            useFullResponse = response.body[0, response.body.index("\n")]
            return URI.decode_www_form(useFullResponse).to_h.to_json
        else
            return URI.decode_www_form(response.body).to_h.to_json
        end
    end

    def getHeaders()
        {
            "Content-Type" => "application/x-www-form-urlencoded",
            "Accept" => "*/*" 
        }
    end
end