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
      record.process_at.must_be_instance_of(Date)
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

  describe "validations" do
    
    it "must have a type of '0'" do
      record = WageSlave::ABA::DescriptiveRecord.new
      assert record.type === "0"
      assert record.valid? === true

      record.instance_variable_set :@type, '1'
      assert record.valid? === false
    end

    it "if bsb is specified it must be in the format xxx-xxx" do
      record = WageSlave::ABA::DescriptiveRecord.new
      record.instance_variable_set :@bsb, "000-000"
      assert record.valid? === true

      record.instance_variable_set :@bsb, nil
      assert record.valid? === true

      record.instance_variable_set :@bsb, "123123"
      assert record.valid? === false

      record.instance_variable_set :@bsb, "abc-abc"
      assert record.valid? === false
    end

    it "must have a reel_sequence that is numeric and does not exceed 99" do
      record = WageSlave::ABA::DescriptiveRecord.new
      assert record.reel_sequence === "01"
      assert record.valid? === true

      record.instance_variable_set :@reel_sequence, "99"
      assert record.valid? === true

      record.instance_variable_set :@reel_sequence, "ok"
      assert record.valid? === false

      record.instance_variable_set :@reel_sequence, "100"
      assert record.valid? === false
    end

    it "must have a valid 3 character abbreviation for an Australian financial institution" do
      record = WageSlave::ABA::DescriptiveRecord.new
      assert record.financial_institution === "ANZ"
      assert record.valid? === true

      record.instance_variable_set :@financial_institution, "AN"
      assert record.valid? === false
    end

    it "must have a user_name less than 26 characters long" do
      record = WageSlave::ABA::DescriptiveRecord.new
      assert record.user_name === "NYDS"
      assert record.valid? === true

      record.instance_variable_set :@user_name, "n" * 26
      assert record.valid? === true

      record.instance_variable_set :@user_name, "n" * 27
      assert record.valid? === false
    end

    it "must have a numeric user_id less than or equal 6 characters long" do
      record = WageSlave::ABA::DescriptiveRecord.new
      record.instance_variable_set :@user_id, "1" * 6
      assert record.valid? === true

      record.instance_variable_set :@user_id, "2" * 7
      assert record.valid? === false

      record.instance_variable_set :@user_id, "Fail"
      assert record.valid? === false
    end

    it "must not have a description that exceeds 12 characters long" do
      record = WageSlave::ABA::DescriptiveRecord.new
      record.instance_variable_set :@description, "n" * 12
      assert record.valid? === true

      record = WageSlave::ABA::DescriptiveRecord.new
      record.instance_variable_set :@description, "n" * 13
      assert record.valid? === false
    end

    it "must specify process_at as a a Ruby Date" do
      record = WageSlave::ABA::DescriptiveRecord.new
      record.instance_variable_set :@process_at, Date.today
      assert record.valid? === true

      record.instance_variable_set :@process_at, Time.now
      assert record.valid? === false
    end

  end

  describe "#to_s" do
    
    it "will print a valid descriptive record in ABA format" do
      
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
      aba.slice(74,6).must_equal record.process_at.strftime("%d%m%y")

      # Reserved
      # Max: 40
      # Char position: 81-120
      aba.slice(80, 40).must_equal " " * 40

    end

    it "will raise a RuntimeError if the record is invalid" do
      record = WageSlave::ABA::DescriptiveRecord.new

      record.instance_variable_set :@type, '1'
      assert record.valid? === false

      -> { record.to_s }.must_raise RuntimeError
    end

  end

end
