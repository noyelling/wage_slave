require 'spec_helper'

describe WageSlave::BuildPayment do
	let(:data) {
		{ id: "00000000-0000-0000-000000000000", account_code: 821, date: Date.today, amount: 123.45 }
	}

	it "must be a class" do
		WageSlave::BuildPayment.must_be_instance_of Class
	end

	it "will build an array of Xeroizer Payment Objects" do

		WageSlave.configure do | config |
			config.xero = {
				consumer_key: "test",
				consumer_secret: "test",
				pem_file_location: "test"
			}
		end

		xero_payment = WageSlave::BuildPayment.call data

		xero_payment.must_be_instance_of Xeroizer::Record::Payment

	end

end