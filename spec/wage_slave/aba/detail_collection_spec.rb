require "spec_helper"

describe WageSlave::ABA::DetailRecord do

  let(:details) {[
    { bsb: "789-112", account_number: "12345678", name: "Jim Sanders",  amount: 5000 },
    { bsb: "213-213", account_number: "98765432", name: "Herc Dundall",  amount: 6000 },
    { bsb: "099-231", account_number: "00012312", name: "Ridgells",  amount: 12421 },
    { bsb: "123-444", account_number: "34432131", name: "Sam Blimpton",  amount: 8753 }
	]}

	describe "#new" do
    
		it "it creates a new collection of DetailRecords when given an array of hashes" do
			
			collection = WageSlave::ABA::DetailCollection.new(details)
			collection.must_be_instance_of WageSlave::ABA::DetailCollection
			collection.size.must_equal 4

			collection.each do | d |
				assert d.is_a? WageSlave::ABA::DetailRecord
			end

		end

	end

	describe "#credit_total" do
		it "sums up the total amount to be credited" do
			collection = WageSlave::ABA::DetailCollection.new(details)
			collection.credit_total.must_equal (5000 + 6000 + 12421 + 8753)
		end
	end

	describe "#to_s" do
		it "prints all members as strings and joins them with a newline" do
			collection = WageSlave::ABA::DetailCollection.new(details)
			collection.to_s.split("\r\n").each do | d |
				assert d.length === 120
			end
		end
	end

end
