# WageSlave
[![Build Status](https://travis-ci.org/noyelling/wage_slave.png)](https://travis-ci.org/noyelling/wage_slave)

A toolkit for generating and working with bulk payment files in various banking formats.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'wage_slave', '~> 2.0'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install wage_slave

## Formats

WageSlave can generate payment files in the following formats:

### Available

1. [ABA / Cemtext](https://www.cemtexaba.com/aba-format) (Australian Banks)

### Coming soon

1. [NZ-DE](http://help.westpac.com.au/help/content/col/documents/pdfs/olpimportnzde.pdf) (New Zealand Direct Entry File Format)
2. [IB4B](https://www.bnz.co.nz/assets/business-banking-help-support/internet-banking/ib4b-file-format-guide.pdf) (Bank of New Zealand)
3. More...

## Usage

Configure your application with information relating to your financial institution. For Rails applications this should be kept in
an initializer. Keep this information secure and out of version control.

### Configuration

```ruby
WageSlave.configure do | config |
  config.financial_institution                  = "ANZ" # Name of your bank
  config.bank_code                              = "123-456" # i.e. BSB, Sort code etc
  config.user_id                                = "12345678" # i.e. CRN, Acc no. etc
  config.description                            = "A default description for all WageSlave transactions"
  config.user_name 								= "Username"
end
```

### ABA / Cemtext

A bulk payment file that works with most Australian banks.

```ruby
    
    # Build individual transactions
    transactions = [
        { name: "John Doe", account_number: "12345678", bsb: "999-999", amount: 5000 },
        { name: "Jane Doe", account_number: "87654321", bsb: "999-999", amount: 6000 }
    ]

    # Create an ABA object
    aba = WageSlave::ABA.new(transactions)

    # Print in ABA format
    # Validation errors will raise a RuntimeError when calling #to_s on an ABA object.
    aba.to_s

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `ruby bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/noyelling/wage_slave.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Author

Wage slave is developed and actively maintained by No Yelling, a [Melbourne driving school](https://www.noyelling.com.au/melbourne).

