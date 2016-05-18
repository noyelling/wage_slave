require 'spec_helper'

describe WageSlave::Payment do

	let(:payment) { WageSlave::Payment.new({xero_id: "12345abcde", payment_amount: 123.45}) }
	
	it "is an class" do
		WageSlave::Payment.must_be_instance_of Class
	end

	it "must have a xero_id" do
		payment.xero_id.must_equal "12345abcde"
	end

	it "must have a payment_amount" do
		payment.payment_amount.must_equal 123.45
	end

end