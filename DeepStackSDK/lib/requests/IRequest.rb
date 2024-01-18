require 'json'

require './DeepStackSDK/lib/models/PaymentInstrumentCard'

class IRequest
    attr_accessor :options

    def addEmployeeID(employeeID)
        @options = @options.merge({:employeeID => employeeID}) 
    end

    def addPaymentInstrument(paymentInstrument, params)
        if paymentInstrument.instance_of?(PaymentInstrumentCard)
            # puts JSON.parse(paymentInstrument.to_json)
            params.merge(JSON.parse(paymentInstrument.to_json))
        else
            params.merge({
                :ccnumber => paymentInstrument
            })
        end
    end

    def addAmount(amount, params)
        params.merge({:amount => amount})
    end

    # PaymentINstrument billing information (for token based authorizations)
    def addBilling(billing)
        @options = @options.merge({
            # Required fields
            :ccexp => billing[:card_expiration],
            :CCBillingAddress => billing[:billing_address],
            :CCBillingZip => billing.key?(:billing_zip) ? billing[:billing_zip] : "",
            # Optional fields
            :CCBillingState => billing.key?(:billing_state) ? billing[:billing_state] : "",
            :CCBillingCity => billing.key?(:billing_city) ? billing[:billing_city] : "",
            :CCBillingCountry => billing.key?(:billing_country) ? billing[:billing_country] : ""
        })
    end

    # Shipping information related to order
    def addShipping(shipping)
        @options = @options.merge({
            :ShippingFirstName => shipping.key?(:first_name) ? shipping[:first_name] : "",
            :ShippingLastName => shipping.key?(:last_name) ? shipping[:last_name] : "",
            :ShippingAddress => shipping.key?(:address) ? shipping[:address] : "",
            :ShippingCity => shipping.key?(:city) ? shipping[:city] : "",
            :ShippingZip => shipping.key?(:zip) ? shipping[:zip] : "",
            :ShippingCountry => shipping.key?(:country) ? shipping[:country] : "",
            :ShippingPhone => shipping.key?(:phone) ? shipping[:phone] : "",
            :ShippingEmail => shipping.key?(:email) ? shipping[:email] : ""
        })
    end

    # Client order information (invoice id, etc...)
    def addClientInfo(clientInfo)
        @options = @options.merge({
            :clienttransid => clientInfo.key?(:client_trans_id) ? clientInfo[:client_trans_id] : "",
            :clientinvoiceid => clientInfo.key?(:client_invoice_id) ? clientInfo[:client_invoice_id] : "",
            :clienttransdescription => clientInfo.key?(:client_trans_desc) ? clientInfo[:client_trans_desc] : ""
        })
    end

    # Add transaction ID for refund/capture
    def addTransactionID(transactionID, params)
        params.merge({:anatransactionid => transactionID})
    end

    def changeAVS(avs)
        @options[:avs] = avs
    end

    def addCCIPAddress(ipAddress)
        @options[:CCHolderIPAddress] = ipAddress
    end

    def addDeviceSessionID(sessionID)
        @options[:DeviceSessionID] = sessionID
    end

    def changeISOCurrency(currency)
        @options[:isocurrencycode] = currency
    end

    def changeISOCountry(country)
        @options[:isocountrycode] = country
    end

    def showOptions()
        puts @options
    end
end