require "spec_helper"

describe WageSlave::ABA::DescriptiveRecord do

  before :each do
    WageSlave::ABA::DescriptiveRecord.class_variable_set :@@reel_sequence, 0
  end
	
	describe "#new" do
    
    it "creates a descriptive record based on the WageSlave configuration" do
      
      record = WageSlave::ABA::DescriptiveRecord.new
      record.must_be_instance_of(WageSlave::ABA::DescriptiveRecord)

      record.type.must_equal "0"
      record.bsb.must_equal WageSlave.configuration.bank_code
      record.financial_institution.must_equal WageSlave.configuration.financial_institution
      record.user_name.must_equal WageSlave.configuration.user_name
      record.user_id.must_equal WageSlave.configuration.user_id
      record.description.must_equal WageSlave.configuration.description

      record.process_at.must_be_instance_of(String)
      record.process_at.length.must_equal 6

      record.reel_sequence.must_equal "01"

    end

    it "will bump the reel_sequence each time an object is initialized" do

      2.times do
        WageSlave::ABA::DescriptiveRecord.new
      end

      record = WageSlave::ABA::DescriptiveRecord.new
      record.reel_sequence.must_equal "03"

    end

	end

  describe "#to_s" do
    
    it "Will print a valid descriptive record in ABA format" do
      
      record = WageSlave::ABA::DescriptiveRecord.new
      aba = record.to_s

      aba.length.must_equal(120)

      # Record type
      # Max: 1
      # Char position: 1
      aba.slice(0,1).must_equal record.type

      # Optional branch number of the funds account with a hyphen in the 4th character position
      # Char position: 2-18
      # Max: 17
      # Blank filled
      aba.slice(1,17).must_equal record.bsb.to_s.ljust(17)

      # Sequence number
      # Char position: 19-20
      # Max: 2
      # Zero padded
      aba.slice(18,2).must_equal record.reel_sequence

      # Name of user financial instituion
      # Max: 3
      # Char position: 21-23
      aba.slice(20,3).must_equal record.financial_institution

      # Reserved (Blank filled)
      # Max: 7
      # Char position: 24-30
      aba.slice(23,7).must_equal " " * 7

      # Name of User supplying File
      # Char position: 31-56
      # Max: 26
      # Full BECS character set valid
      # Blank filled
      aba.slice(30,26).must_equal record.user_name.to_s.ljust(26)

      # Direct Entry User ID
      # Char position: 57-62
      # Max: 6
      # Zero padded
      aba.slice(56,6).must_equal record.user_id.to_s.ljust(6, "0")

      # Description of payments in the file (e.g. Payroll, Creditors etc.)
      # Char position: 63-74
      # Max: 12
      # Full BECS character set valid
      # Left justified, blank filled
      aba.slice(62,12).must_equal record.description.to_s.ljust(12)

      # Date on which the payment is to be processed
      # Char position: 75-80
      # Max: 6
      aba.slice(74,6).must_equal record.process_at.to_s.rjust(6, "0")

      # Reserved
      # Max: 40
      # Char position: 81-120
      aba.slice(80, 40).must_equal " " * 40

    end

  end

end
