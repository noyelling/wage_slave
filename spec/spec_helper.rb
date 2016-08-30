require 'pp'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

# Load gem and all of its dependencies
require 'wage_slave'

# Load a testable environment
require 'dotenv'
Dotenv.load

require 'mocha'
require 'minitest'
require 'minitest/spec'
require 'mocha/mini_test'
require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new(:color => true)]

WageSlave.configure do | config |
  config.financial_institution                  = "ANZ" # Name of your bank
  config.account_number                         = "12345678" # i.e. Account number
  config.bank_code                              = "123-456" # i.e. BSB, Sort code etc
  config.user_id                                = "123456" # i.e. Bank assigned code
  config.description                            = "PAYROLL"
  config.user_name                              = "NYDS"
end
