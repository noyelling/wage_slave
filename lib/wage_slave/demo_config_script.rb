# Configure Application with Demo API Keys

WageSlave.configure do | config |
	config.financial_institution = "ANZ"
	config.bank_code 						 = "123-456"
	config.user_id							 = "000001"
	config.description					 = "No Yelling Commission"
end

WageSlave.configure_xero ENV['DEMO_XERO_CONSUMER_KEY'], ENV['DEMO_XERO_CONSUMER_SECRET'], ENV['XERO_PEM_FILE_LOCATION']