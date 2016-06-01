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

		describe "Descriptive Record (type 0)" do

			let(:descriptive_record) { subject.to_s.split("\r\n").first }

			it "should include the first line of the file with a length of 120 characters" do
				descriptive_record.length.must_equal 120
			end

			it "should have the number 0 in Char Position 1" do
				descriptive_record[0].must_equal "0"
			end

			it "should be blank filled from Char Position 2-18 if no merchant bsb or account number provided" do
				descriptive_record[1..17].must_equal " " * 17
			end

			it "should include left justified and blank filled from Char Position 2-18 when optional bsb provided" do
				subject.bsb = "123-456"
				descriptive_record[1..17].must_equal subject.bsb.ljust(17)
			end

			it "should include numeric commencing at 01 from Char Position 19-20" do
				descriptive_record[18..19].must_equal "01"
			end

			it "should include an approved Financial Institution abbreviation (3 characters) from Char position 21-23." do
				descriptive_record[20..22].must_equal subject.financial_institution
			end

			it "should include blank filled from Char Position 24-30" do
				descriptive_record[23..29].must_equal " " * 7
			end

			it "should  name of the merchant left justified and blank filled from Char Position 31-56" do
				descriptive_record[30..55].must_equal subject.user_name.ljust(26)
			end

			it "should include the User Identification Number allocated by APCA right justified, zero filled from Char Position 57-62" do
				descriptive_record[56..61].must_equal subject.user_id
			end

			it "should include an explanation in character format, left justified, blank filled from Char Position 63-74" do
				descriptive_record[62..73].must_equal subject.description.ljust(12)
			end

			it "should include a numeric date in the format DDMMYY from Char Position 75-80" do
				descriptive_record[74..79].must_equal subject.process_at
			end

			it "should conclude with 40 blank spaces" do
				descriptive_record[80..119].must_equal " " * 40
			end

		end

		describe "File Total Record (type 7)" do

			let(:total_record) { subject.to_s.split("\r\n").last }

			it "should begin with the number 7" do
				total_record[0].must_equal "7"
			end

			it "should include 999-999 from char position 2-8" do
				total_record[1..7].must_equal "999-999"
			end

			it "should be blank filled from Char Position 9-20" do
				total_record[8..19].must_equal " " * 12
			end

			it "should include the difference between File Credit and Debit totals numerically, right justified and zero filled from Char Position 21-30" do
				net_total_amount = subject.transactions.reduce(0) { |sum, n| sum + n[1].amount.to_i }
				total_record[20..29].must_equal net_total_amount.abs.to_s.rjust(10, "0")
			end

			it "should include the Credit total right justified and zero filled @ char position 31-40" do
				credit_total_amount = 0
				subject.transactions.each { |t| credit_total_amount += t[1].amount.to_i unless t[1].amount.to_i < 0 }
				total_record[30..39].must_equal credit_total_amount.abs.to_s.rjust(10, "0")
			end

			it "should include the Debit total right justified and zero filled @ char position 41-50" do
				debit_total_amount = 0
				subject.transactions.each { |t| debit_total_amount += t[1].amount.to_i unless t[1].amount.to_i > 0 }
				total_record[40..49].must_equal debit_total_amount.abs.to_s.rjust(10, "0")
			end

			it "should be blank filled from char position 51-74" do
				total_record[50..73].must_equal " " * 24
			end

			it "should include the accumulated number of Record 1 Type items." do
				total = subject.transactions.size
				total_record[74..79].must_equal total.to_s.rjust(6, "0")
			end

			it "should conclude with blank spaces" do
				total_record[80..119].must_equal " " * 40
			end

		end


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