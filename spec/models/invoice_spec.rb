require 'spec_helper'

describe WageSlave::Invoice do

	let(:invoice) { WageSlave::Invoice.new({name: "Jasper Boyschau", email: "jasper@noyelling.com.au", item_amount: 123.45, 
																					due_date: Date.today, item_description: "No Yelling Commission", 
																					item_quantity: 1, account_code: 240
																					}) }

	it "is a Class" do
		WageSlave::Invoice.must_be_instance_of Class
	end

	it "must have a name" do
		invoice.name.must_equal "Jasper Boyschau"
	end

	it "must have an email" do
		invoice.email.must_equal "jasper@noyelling.com.au"
	end

	it "must have an item_amount" do
		invoice.item_amount.must_equal 123.45
	end

	it "must have a xero_id" do
		invoice.xero_id.must_equal nil
	end

	it "must have a due_date" do
		invoice.due_date.must_equal Date.today
	end	

	it "must have an item_description" do
		invoice.item_description.must_equal "No Yelling Commission"
	end

	it "must have an item_quantity" do
		invoice.item_quantity.must_equal 1
	end

	it "must have an account_code" do
		invoice.account_code.must_equal 240
	end

	describe "#build" do

		it "builds a Xeroizer Invoice Object" do
			WageSlave.configure_xero "test", "test", "test"
			xero_invoice = invoice.build
			xero_invoice.type.must_equal "ACCREC"
		end

	end

end