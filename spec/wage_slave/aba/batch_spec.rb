require 'spec_helper'

describe WageSlave::Aba::Batch do
	
	let(:aba) { WageSlave::Aba::Batch.new(
		financial_institution: "ANZ", 
		user_name: "No Yelling",
		user_id: "000001", 
		description: "Payroll", 
		process_at: "201016"
		)}

	let(:transaction_values) { [30, -20] }
	
	let(:transactions) do
		transaction_values.map do |amount|
			WageSlave::Aba::Transaction.new(
				bsb: '342-342', account_number: '3244654', amount: amount,
      	account_name: 'John Doe', transaction_code: 53,
      	lodgement_reference: 'R435564', trace_bsb: '453-543',
      	trace_account_number: '45656733', name_of_remitter: 'Remitter'
      )
		end
	end

	subject { aba }

	before do
		transactions.each { |trx| aba.add_transaction(trx)} 
	end

	describe "#to_s" do

		it "should return a string containing the descriptive record without the bsb" do
			subject.to_s.must_include("0                 01ANZ       No Yelling                000001Payroll     201016                                        \r\n")
		end

		it "should return a string containing the descriptive record with bsb" do
			subject.bsb = "123-456"
			subject.to_s.must_include("0123-456          01ANZ       No Yelling                000001Payroll     201016                                        \r\n")
		end

		it "should contain transactions records" do
			subject.to_s.must_include("1342-342  3244654 530000000030John Doe                        R435564           453-543 45656733Remitter        00000000\r\n")
			subject.to_s.must_include("1342-342  3244654 530000000020John Doe                        R435564           453-543 45656733Remitter        00000000\r\n")
		end

		it "should return a string (file total record) where net total is not zero with unbalanced transactions" do
			subject.to_s.must_include("7999-999            000000001000000000300000000020                        000002                                        ")
		end

	end

end