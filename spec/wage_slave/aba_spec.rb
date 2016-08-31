require "spec_helper"

describe WageSlave::ABA do

  let(:details) {[
    { bsb: "789-112", account_number: "12345678", name: "Jim Sanders",  amount: 5000 },
    { bsb: "213-213", account_number: "98765432", name: "Herc Dundall",  amount: 6000 },
    { bsb: "099-231", account_number: "00012312", name: "Ridgells",  amount: 12421 },
    { bsb: "123-444", account_number: "34432131", name: "Sam Blimpton",  amount: 8753 }
	]}
	
	describe "#new" do

		it "will create a new ABA object" do
			aba = WageSlave::ABA.new(details)
			aba.must_be_instance_of WageSlave::ABA
			aba.descriptive_record.must_be_instance_of WageSlave::ABA::DescriptiveRecord
			aba.details.must_be_instance_of WageSlave::ABA::DetailCollection
			aba.details.each do | d |
				d.must_be_instance_of WageSlave::ABA::DetailRecord
			end
		end

	end

	describe "#to_s" do
		
		it "will generate a valid ABA that is 120 characters wide" do
			aba = WageSlave::ABA.new(details)
			aba.to_s.split("\r\n").each do | str |
				str.length.must_equal 120
			end
		end

	end

end
