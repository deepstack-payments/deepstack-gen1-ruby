require 'json'

class PaymentInstrumentCard
    attr_accessor :card_first_name, :card_last_name, :card_number, :card_expiration, :card_billing_address, :card_billing_zipcode, :card_cvv, :card_billing_city, :card_billing_country, :card_billing_state
    def initialize(card_number, card_expiration, card_billing_address, card_billing_zipcode, card_cvv = nil, card_first_name = nil, card_last_name = nil, card_billing_city = nil, card_billing_state = nil, card_billing_country = nil)
        @card_first_name = card_first_name
        @card_last_name = card_last_name
        @card_number = card_number
        @card_expiration = card_expiration
        @card_billing_address = card_billing_address
        @card_billing_zipcode = card_billing_zipcode
        @card_cvv = card_cvv
    end
    def to_json
        {
            # Required fields 
            "ccnumber" => @card_number,
            "ccexp" => @card_expiration,
            "CCBillingAddress" => @card_billing_address,
            # "CCBillingZip" => @card_billing_zipcode,
            "CCBillingZip" => @card_billing_zipcode ? @card_billing_zipcode : "",
            # Optional Fields 
            "CCHolderFirstName" => @card_first_name ? @card_first_name : "",
            "CCHolderLastName" => @card_last_name ? @card_last_name : "",
            "cvv" => @card_cvv ? @card_cvv : "",
            "ccbillingcity" => @card_billing_city ? @card_billing_city : "",
            "ccbillingstate" => @card_billing_state ? @card_billing_state : "",
            "ccbillingcountry" => @card_billing_country ? @card_billing_country : "USA"
        }.to_json
    end
end    