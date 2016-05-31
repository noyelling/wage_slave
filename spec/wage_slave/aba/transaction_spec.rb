require 'spec_helper'

describe WageSlave::Aba::Transaction do
		
	let(:transaction_params){
		{
			:account_number => 23432342,
	    :transaction_code => 53,
	    :amount => 50050,
	    :account_name => "John Doe",
	    :bsb => "345-453",
	    :witholding_amount => 87,
	    :indicator => "W",
	    :lodgement_reference => "R45343",
	    :trace_bsb => "123-234",
	    :trace_account_number => "4647642",
	    :name_of_remitter => "Remitter"
		}
	}

	subject { WageSlave::Aba::Transaction.new(transaction_params) }

	describe "#to_s" do
		it "should create a transaction row" do
			subject.to_s.must_include("1345-453 23432342W530000050050John Doe                        R45343            123-234  4647642Remitter        00000087")
		end
	end

	describe "#valid?" do
		it "should be valid" do
			subject.valid?.must_equal true
		end
	end

	it "should not be valid" do
		transaction_params.delete(:bsb)
		subject.valid?.must_equal false
		subject.errors.must_equal ["bsb format is incorrect"]
	end

end