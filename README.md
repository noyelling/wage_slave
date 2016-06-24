# WageSlave

Payroll made easy for Ruby applications. Integrates with Xero and may transact to any Australian bank account.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'wage_slave'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install wage_slave

## Usage

### Configuration

```ruby
WageSlave.configure do | config |
  config.financial_institution                  = "ANZ" # Name of your bank
  config.bank_code                              = "123-456" # i.e. BSB, Sort code etc
  config.user_id                                = "12345678" # i.e. CRN, Acc no. etc
  config.description                            = "A default description for all WageSlave transactions"
  config.user_name 															= "Username"
  config.xero = {
		consumer_key: "YOUR_XERO_CONSUMER_KEY",
	  consumer_secret: "YOUR_XERO_CONSUMER_SECRET",
	  pem_file_location: "YOUR_PEM_FILE_LOCATION"
  }
end
```

### Build Invoices
Build an invoice

```ruby
payment1 = {
	# Required attributes
	due_date: Date.today,
	description: "Payroll",
	quantity: 1,
	unit_amount: 220.20, # in dollars
	account_code: 245
}

payments = [payment1, payment2, payment3]

xero_invoice = WageSlave::BuildInvoice.call payments

```

### Save Invoice
Save invoice to Xero.

```ruby
WageSlave::SaveInvoice.call xero_invoice
```

### Build Payments
Builds Xero Payment linked to Invoice with #invoice_id

```ruby
payment = {
	# Required Attributes
	amount: amount_due,
	id: invoice_id,
	account_code: 238 # Account that payment is being made from
}

xero_payment = WageSlave::BuildPayment.call payment
```

### Save Payment
Save payment to Xero.

```ruby
WageSlave::SavePayment.call xero_payment
```

### ABA File
```ruby
# Initialise ABA
aba = WageSlave::Aba.batch(
  bsb: "123-345", # Optional (Not required by NAB)
  financial_institution: "WPC",
  user_name: "John Doe",
  user_id: "466364",
  description: "Payroll",
  process_at: Time.now.strftime("%d%m%y")
)

# Add Transaction
aba.add_transaction(
    {
      bsb: "342-342",
      account_number: "3244654",
      amount: 10000, # Amount in cents
      account_name: "John Doe",
      transaction_code: 53,
      lodgement_reference: "R435564",
      trace_bsb: "453-543",
      trace_account_number: "45656733",
      name_of_remitter: "Remitter"
    }
  )
```

Transactions are passed as an array to the second param of Aba.batch

```ruby
aba = WageSlave::Aba.batch(
  { financial_institution: 'ANZ', bsb: "123-456", user_name: 'Joe Blow', user_id: 123456, process_at: 200615, description: "Payroll" },
  [
    { bsb: '123-456', account_number: '000-123-456', amount: 50000 },
    { bsb: '456-789', account_number: '123-456-789', amount: '-10000', transaction_code: 13 }
  ]
)
```

Validation erros can be caught in several ways:

```ruby
# Create an ABA object with invalid character in the user_name
aba = Aba.batch(
  financial_institution: "ANZ",
  user_name: "Jøhn Doe",
  user_id: "123456",
  process_at: Time.now.strftime("%d%m%y")
)

# Add a transaction with a bad BSB
aba.add_transaction(
  bsb: "abc-123",
  account_number: "000123456"
)

# Is the data valid?
aba.valid?
# Returns: false

# Return a structured array of errors
puts aba.errors
# Returns:
# {:aba => ["user_name must not contain invalid characters"],
#  :transactions =>
#   {0 => ["bsb format is incorrect", "trace_bsb format is incorrect"]}}
```

Validation erros will stop the parsing of the data to an ABA formatted string using `to_s`. `aba.to_s` will raise a `RuntimeError` instead of returning output.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `ruby bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/noyelling/wage_slave.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

