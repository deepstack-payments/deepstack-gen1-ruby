# DeepStack Ruby SDK #


## General Flow ##

1. Create DeepStackClient object
2. Create DeepStackRequest object (Request will require other Deepstack objects/initialization parameters but we'll discuss those below)
3. Send request using each objects .send(DeepStackClient) method
4. Response will be returned in a hash

### Creating DeepStackClient ###

Creating the client requires 4 parameters: apiusername, apipassword, clientid, and isProduction. The value of isProduction is defaulted to `false` so make sure to change that to `true` to begin processing on the live server

```ruby
# Parameters:
#   Required
#       apiusername: given by Deepstack
#       apipassword: given by Deepstack
#       clientid: given by Deepstack
#   Optional
#       isProduction: specify whether to use live or test server (defaulted to false- test)

client = DeepStackClient.new(apiusername, apipassword, clientid, true)
```

### Creating a PaymentInstrument (token) ###

This method returns a token that can be used in place of PAN. Parameter for the method is a PaymentInstrumentCard object

First create the PaymentInstrumentCard
```ruby
# def initialize(card_number, card_expiration, card_billing_address, card_billing_zipcode, card_cvv = nil, card_first_name = nil, card_last_name = nil, card_billing_city = nil, card_billing_state = nil, card_billing_country = nil)
# Each parameter set as attr_accessor, so able to change any time after creation
# Parameters
#   Required
#       card_number: card number
#       card_expiration: card expiration in format 'MMYY'
#       card_billing_address: billing address associated with card
#       card_billing_zipcode: billing zipcode associated with card
#       card_cvv: cvv code (not REQUIRED but best practice to include)
#   Optional
#       card_first_name: first name
#       card_last_name: last name
#       card_billing_city: billing city associated with card
#       card_billing_state: billing state associated with card
#       card_billing_country: billing country associated with card (ISO3166CountryCode) default value "USA"

card = PaymentInstrumentCard.new(cardnumber, cardexpiration, cardbillingaddress, cardbillingzipcode)
card.card_cvv = '123'
```
Now send the request for token
```ruby
# Parameters
#   Required
#       creditCard: PaymentInstrumentCard

request = CreateTokenRequest.new(card)
response = request.send(client)

# "responsecode": "00" => success
# "responsetext" : "Transaction was successful" or error message
responseCode = response["responsecode"]
responseText = response["responsetext"]
transactionType = response["transactiontype"] # Returns name of method... "gettoken" in this case
# Token
token = response["clienttransdescription"]
```

### Authorizing transaction ###

Country codes are standardized to ISO3166CountryCode format with default value being "USA"
To change the country use
```ruby
request.changeISOCountry("USA")
```

Currency codes are standardized to ISO4217CurrencyCode format with default value being "USD"
To change the currency use
``` ruby
request.changeISOCurrency("USD")
```

AVS is enabled by default, however if you would like to turn this off use the following 
```ruby
request.changeAVS("n")
```

For authorizing with a credit card... it is as simple as creating the request and passing the card object and amount as parameters. For using a token, the card expiration, billing address, and billing zipcode will also need to be passed

Authorizing with card
```ruby
# Parameters
#   Required
#       amount: amount to authorize in dollar amount. Ex: 10.25
#       creditCard: PaymentInstrumentCard
request = AuthorizationRequest.new(10.25, card)

## OPTIONAL
# Pass shipping information into request
# shipping = {
#   #Optional- non-filled will fill to ""
#   first_name, last_name, address, city, zip, country, phone, email
# }
shipping = {
    :first_name => "John",
    :last_name => "Doe",
    :address => "123 Main St",
    :city => "Some city",
    :zip => "12345",
    :country => "US",
    :phone => "1234567890",
    :email => "someemail@gmail.com"
}
request.addShipping(shipping)

## OPTIONAL
# Pass client specific fields (invoice, trans id, etc... all optional)
# clientInfo = {
#   client_trans_id, client_invoice_id, client_trans_desc
# }
clientInfo = {
    :client_trans_id => "123",
    :client_invoice_id => "1234",
    :client_trans_desc => "Sold something cool"
}
request.addClientInfo(clientInfo)

##Optional
# Change AVS, ISOCurrency, ISOCountry
# Default values: 'y', 'USD', 'USD'
request.changeAVS("avs")
request.changeISOCurrency("currency")
request.changeISOCountry("country")

## Optional
# Pass optional card holder IP address or session ID
request.addCCIPAddress("IP.Address")
request.addDeviceSessionID("SomeSessionID")

response = request.send(client)
# "responsecode": "00" => success
# "responsetext" : "Transaction was successful" or error message
responseCode = response["responsecode"]
responseText = response["responsetext"]
transactionType = response["transactiontype"] # Returns name of method... "auth" in this case
# Transaction ID used for refund/capture
transactionID = response["anatransactionid"]
```

Authorizing with token
```ruby
# Parameters
#   Required
#       amount: amount to authorize in dollar amount. Ex: 10.25
#       creditCard: token
request = AuthorizationRequest.new(10.25, token)
# Pass required billing information
# billing = {
#   #Required
#       card_expiration, billing_address, billing_zip,
#   #Optional
#       billing_state, billing_city, billing_country
# }

billing = {
    :card_expiration => "MMYY",
    :billing_address => "123 Main st",
    :billing_zip => "12345",
    :billing_state => "CA",
    :billing_city => "some city",
    :billing_country => "US"
}
request.addBilling(billing)

## OPTIONAL
# Pass shipping information into request
# shipping = {
#   #Optional- non-filled will fill to ""
#   first_name, last_name, address, city, zip, country, phone, email
# }
shipping = {
    :first_name => "John",
    :last_name => "Doe",
    :address => "123 Main St",
    :city => "Some city",
    :zip => "12345",
    :country => "US",
    :phone => "1234567890",
    :email => "someemail@gmail.com"
}
request.addShipping(shipping)

## OPTIONAL
# Pass client specific fields (invoice, trans id, etc... all optional)
# clientInfo = {
#   client_trans_id, client_invoice_id, client_trans_desc
# }
clientInfo = {
    :client_trans_id => "123",
    :client_invoice_id => "1234",
    :client_trans_desc => "Sold something cool"
}
request.addClientInfo(clientInfo)

##Optional
# Change AVS, ISOCurrency, ISOCountry
# Default values: 'y', 'USD', 'USA'
request.changeAVS("avs")
request.changeISOCurrency("currency")
request.changeISOCountry("country")

## Optional
# Pass optional card holder IP address or session ID
request.addCCIPAddress("IP.Address")
request.addDeviceSessionID("SomeSessionID")

# "responsecode": "00" => success
# "responsetext" : "Transaction was successful" or error message
responseCode = response["responsecode"]
responseText = response["responsetext"]
transactionType = response["transactiontype"] # Returns name of method... "auth" in this case
# Transaction ID used for refund/capture
transactionID = response["anatransactionid"]
```

### Sale (Authorizing + Capture) ###

Sale with card 
```ruby
# Parameters
#   Required
#       amount: amount to authorize in dollar amount. Ex: 10.25
#       creditCard: PaymentInstrumentCard
request = SaleRequest.new(10.25, card)

## OPTIONAL
# Pass shipping information into request
# shipping = {
#   #Optional- non-filled will fill to ""
#   first_name, last_name, address, city, zip, country, phone, email
# }
shipping = {
    :first_name => "John",
    :last_name => "Doe",
    :address => "123 Main St",
    :city => "Some city",
    :zip => "12345",
    :country => "USA",
    :phone => "1234567890",
    :email => "someemail@gmail.com"
}
request.addShipping(shipping)

## OPTIONAL
# Pass client specific fields (invoice, trans id, etc... all optional)
# clientInfo = {
#   client_trans_id, client_invoice_id, client_trans_desc
# }
clientInfo = {
    :client_trans_id => "123",
    :client_invoice_id => "1234",
    :client_trans_desc => "Sold something cool"
}
request.addClientInfo(clientInfo)

##Optional
# Change AVS, ISOCurrency, ISOCountry
# Default values: 'y', 'USD', 'USA'
request.changeAVS("avs")
request.changeISOCurrency("currency")
request.changeISOCountry("country")

## Optional
# Pass optional card holder IP address or session ID
request.addCCIPAddress("IP.Address")
request.addDeviceSessionID("SomeSessionID")

response = request.send(client)
# "responsecode": "00" => success
# "responsetext" : "Transaction was successful" or error message
responseCode = response["responsecode"]
responseText = response["responsetext"]
transactionType = response["transactiontype"] # Returns name of method... "auth" in this case
# Transaction ID used for refund/capture
transactionID = response["anatransactionid"]
```

Sale with token 
```ruby
# Parameters
#   Required
#       amount: amount to authorize in dollar amount. Ex: 10.25
#       creditCard: token
request = SaleRequest.new(10.25, token)
# Pass required billing information
# billing = {
#   #Required
#       card_expiration, billing_address, billing_zip,
#   #Optional
#       billing_state, billing_city, billing_country
# }

billing = {
    :card_expiration => "MMYY",
    :billing_address => "123 Main st",
    :billing_zip => "12345",
    :billing_state => "CA",
    :billing_city => "some city",
    :billing_country => "USA"
}
request.addBilling(billing)

## OPTIONAL
# Pass shipping information into request
# shipping = {
#   #Optional- non-filled will fill to ""
#   first_name, last_name, address, city, zip, country, phone, email
# }
shipping = {
    :first_name => "John",
    :last_name => "Doe",
    :address => "123 Main St",
    :city => "Some city",
    :zip => "12345",
    :country => "US",
    :phone => "1234567890",
    :email => "someemail@gmail.com"
}
request.addShipping(shipping)

## OPTIONAL
# Pass client specific fields (invoice, trans id, etc... all optional)
# clientInfo = {
#   client_trans_id, client_invoice_id, client_trans_desc
# }
clientInfo = {
    :client_trans_id => "123",
    :client_invoice_id => "1234",
    :client_trans_desc => "Sold something cool"
}
request.addClientInfo(clientInfo)

##Optional
# Change AVS, ISOCurrency, ISOCountry
# Default values: 'y', 'USD', 'USA'
request.changeAVS("avs")
request.changeISOCurrency("currency")
request.changeISOCountry("country")

## Optional
# Pass optional card holder IP address or session ID
request.addCCIPAddress("IP.Address")
request.addDeviceSessionID("SomeSessionID")

# "responsecode": "00" => success
# "responsetext" : "Transaction was successful" or error message
responseCode = response["responsecode"]
responseText = response["responsetext"]
transactionType = response["transactiontype"] # Returns name of method... "auth" in this case
# Transaction ID used for refund/capture
transactionID = response["anatransactionid"]
```

### Capture with transaction ID ###

Capture a transaction with that handy transaction ID that came from authorization

```ruby
# Parameters
#   Required
#       amount: amount in dollar amount. Ex: 10.25
#       transactionID: transaction ID from auth (can be set later)
request = CaptureRequest.new(10.25, token)
#OR
request = CaptureRequest.new(10.25)
request.transactionID = token

## OPTIONAL
# Pass client specific fields (invoice, trans id, etc... all optional)
# clientInfo = {
#   client_trans_id, client_invoice_id, client_trans_desc
# }
clientInfo = {
    :client_trans_id => "123",
    :client_invoice_id => "1234",
    :client_trans_desc => "Sold something cool"
}
request.addClientInfo(clientInfo)

response = request.send(client)
# "responsecode": "00" => success
# "responsetext" : "Transaction was successful" or error message
responseCode = response["responsecode"]
responseText = response["responsetext"]
transactionType = response["transactiontype"] # Returns name of method... "capture" in this case
```

### Void with transaction ID ###

Void the transaction

```ruby
# Parameters
    # Required
    # transactionID: transaction ID from auth(can be set later)
    request = VoidRequest.new(transactionID)
    response = request.send(client)
```


### Refund with transaction ID ###

Refund with a transaction ID (very similar to capture)

```ruby
# Parameters
#   Required
#       amount: amount in dollar amount. Ex: 10.25
#       transactionID: transaction ID from auth (can be set later)
request = RefundRequest.new(10.25, transactionID)
#OR
request = RefundRequest.new(10.25)
request.transactionID = transactionID

## OPTIONAL
# Pass client specific fields (invoice, trans id, etc... all optional)
# clientInfo = {
#   client_trans_id, client_invoice_id, client_trans_desc
# }
clientInfo = {
    :client_trans_id => "123",
    :client_invoice_id => "1234",
    :client_trans_desc => "Sold something cool"
}
request.addClientInfo(clientInfo)

response = request.send(client)
# "responsecode": "00" => success
# "responsetext" : "Transaction was successful" or error message
responseCode = response["responsecode"]
responseText = response["responsetext"]
transactionType = response["transactiontype"] # Returns name of method... "refund" in this case
```
