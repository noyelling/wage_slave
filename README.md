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
Builds an Array of Xero Invoice Objects

```ruby
invoice1 = {
	# Required attributes
	due_date: Date.today,
	name: "Joe Bloggs",
	description: "Payroll",
	quantity: 1,
	unit_amount: 220.20, # in dollars
	account_code: 245
}

invoices = [invoice1, invoice2, invoice3]

xero_invoices = WageSlave::BuildInvoices.call payments

```

### Save Invoices
Save invoices to Xero.

```ruby
WageSlave::SaveInvoices.call xero_invoices
```

### Build Payments
Builds an Array of Xero Payments linked to Invoices with #invoice_id

```ruby
payment1 = {
	# Required Attributes
	amount: amount_due,
	id: invoice_id,
	account_code: 238 # Account that payment is being made from
}

payments = [payment1, payment2, payment3]

xero_payments = WageSlave::BuildPayments.call payments
```

### Save Payments
Save payments to Xero.

```ruby
WageSlave::SavePayments.call xero_payments
```

#### Test Title

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `ruby bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/noyelling/wage_slave.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

