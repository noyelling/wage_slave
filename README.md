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
  config.financial_institution                  = "ANZ" // Name of your bank
  config.bank_code                              = "123-456" // i.e. BSB, Sort code etc
  config.user_id                                = "12345678" // i.e. CRN, Acc no. etc
  config.description                            = "A default description for all WageSlave transactions"
  config.xero_consumer_key                      = "YOUR_XERO_CONSUMER_KEY"
  config.xero_consumer_secret                   = "YOUR_XERO_CONSUMER_SECRET"
  config.xero_pem_file_location                 = "YOUR_PEM_FILE_LOCATION"
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `ruby bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/noyelling/wage_slave.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

