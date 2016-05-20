$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'wage_slave'
require 'wage_slave/models/invoice'
require 'wage_slave/services/build_invoices'

# Configure testable environment
require 'dotenv'

Dotenv.load

# Configure Application with Demo API Keys
WageSlave.configure do | config |
	config.financial_institution = "ANZ"
	config.bank_code 						 = "123-456"
	config.user_id							 = "000001"
	config.description					 = "No Yelling Commission"
end

WageSlave.configure_xero(
  ENV['DEMO_XERO_CONSUMER_KEY'], 
  ENV['DEMO_XERO_CONSUMER_SECRET'], 
  File.expand_path("../../", __FILE__) + ENV['XERO_PEM_FILE_LOCATION']
)

require 'minitest'
require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/pride'
