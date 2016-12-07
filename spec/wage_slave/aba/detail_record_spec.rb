require "spec_helper"

describe WageSlave::ABA::DetailRecord do

  let(:details) {{
    bsb: "789-112", account_number: "12345678", name: "Jim Sanders",  amount: 5000
  }}

	describe "#new" do
    
    it "creates a detail record based on WageSlave config and programmer input" do
      record = WageSlave::ABA::DetailRecord.new(details)
      record.must_be_instance_of(WageSlave::ABA::DetailRecord)

      # From input
      record.bsb.must_equal details[:bsb]
      record.account_number.must_equal details[:account_number]
      record.name.must_equal details[:name]
      record.amount.must_equal details[:amount]

      # From config
      record.lodgement_reference.must_equal WageSlave.configuration.user_name
      record.trace_bsb.must_equal WageSlave.configuration.bank_code
      record.trace_account.must_equal WageSlave.configuration.account_number
      record.remitter.must_equal WageSlave.configuration.user_name

      # Implied
      record.type.must_equal "1"
      record.indicator.must_equal "N"
      record.transaction_code.must_equal "53"
    end

    it "will only set indicators that are a part of @@indicators" do
      record = WageSlave::ABA::DetailRecord.new
      codes = WageSlave::ABA::DetailRecord.class_variable_get(:@@indicators)

      codes.each do | code |
        record.indicator = code
        record.indicator.must_equal code
      end

      record.indicator = "Z"
      assert record.indicator != "Z"
    end

    it "will only set transaction codes that are a part of @@transaction_codes" do
      codes = WageSlave::ABA::DetailRecord.class_variable_get(:@@transaction_codes)
      record = WageSlave::ABA::DetailRecord.new

      codes.each do | code |
        record.transaction_code = code
        record.transaction_code.must_equal code
      end

      record.transaction_code = "100"
      assert record.transaction_code != "100"
    end

	end

  describe "validations" do

    it "must have type of '1'" do
      record  = WageSlave::ABA::DetailRecord.new(details) 
      assert record.type === "1"
      assert record.valid? === true

      record.instance_variable_set :@type, '0'
      assert record.valid? === false
    end

    it "must have a BSB in the format XXX-XXX" do
      record  = WageSlave::ABA::DetailRecord.new(details) 
      assert record.bsb === details[:bsb]
      assert record.valid? === true

      record.instance_variable_set :@bsb, 'fail'
      assert record.valid? === false
    end

    it "must have a numeric account number no longer than 9 characters" do
      record  = WageSlave::ABA::DetailRecord.new(details) 
      assert record.account_number === details[:account_number]
      assert record.valid? === true

      record.instance_variable_set :@account_number, 'fail'
      assert record.valid? === false

      record.instance_variable_set :@account_number, '1234567890' # 10
      assert record.valid? === false
    end

    it "must have a defined indicator" do
      record  = WageSlave::ABA::DetailRecord.new(details) 
      assert record.indicator === "N"
      assert record.valid? === true

      record.instance_variable_set :@indicator, nil
      assert record.valid? === false
    end

    it "must have a defined transaction_code" do
      record  = WageSlave::ABA::DetailRecord.new(details) 
      assert record.transaction_code === "53"
      assert record.valid? === true

      record.instance_variable_set :@transaction_code, nil
      assert record.valid? === false
    end

    it "must have an amount greater than 0 and less than 10,000,000,000" do
      record  = WageSlave::ABA::DetailRecord.new(details) 
      assert record.amount === details[:amount]
      assert record.valid? === true

      record.instance_variable_set :@amount, 0
      assert record.valid? === false

      record.instance_variable_set :@amount, 10_000_000_000
      assert record.valid? === false
    end

    it "will cast amounts to Fixnum" do
      details[:amount] = "50000"
      record = WageSlave::ABA::DetailRecord.new(details)
      assert record.amount.class == Fixnum, "class was #{record.amount.class.name}, not Fixnum"
      assert record.amount === 50000, "not equal to the fixnum 50000"
      assert record.valid? === true
    end

    it "must have a name no longer than 32 characters" do
      record  = WageSlave::ABA::DetailRecord.new(details) 
      assert record.name === details[:name]
      assert record.valid? === true

      record.instance_variable_set :@name, "n" * 32
      assert record.valid? === true

      record.instance_variable_set :@name, "n" * 33
      assert record.valid? === false
    end

    it "must have a lodgement reference no longer than 18 characters" do
      record  = WageSlave::ABA::DetailRecord.new(details) 
      assert record.lodgement_reference === WageSlave.configuration.user_name
      assert record.valid? === true

      record.instance_variable_set :@lodgement_reference, "n" * 18
      assert record.valid? === true

      record.instance_variable_set :@lodgement_reference, "n" * 19
      assert record.valid? === false
    end

    it "must have a trace_bsb in the format xxx-xxx" do
      record  = WageSlave::ABA::DetailRecord.new(details) 
      assert record.trace_bsb === WageSlave.configuration.bank_code
      assert record.valid? === true

      record.instance_variable_set :@trace_bsb, "fail"
      assert record.valid? === false
    end

    it "must have a numberic trace_account no longer than 9 characters" do
      record  = WageSlave::ABA::DetailRecord.new(details) 
      assert record.trace_account === WageSlave.configuration.account_number
      assert record.valid? === true

      record.instance_variable_set :@trace_account, 'fail'
      assert record.valid? === false

      record.instance_variable_set :@trace_account, '1234567890' # 10
      assert record.valid? === false
    end

    it "must have a remitter no longer than 16 characters" do
      record  = WageSlave::ABA::DetailRecord.new(details) 
      assert record.remitter === WageSlave.configuration.user_name
      assert record.valid? === true

      record.instance_variable_set :@remitter, 'n' * 16
      assert record.valid? === true

      record.instance_variable_set :@remitter, ''
      assert record.valid? === false

      record.instance_variable_set :@remitter, ' ' * 17
      assert record.valid? === false
    end

    it "must have a withholding amount less than 100,000,000" do
      record  = WageSlave::ABA::DetailRecord.new(details) 
      assert record.withholding_amount === 0
      assert record.valid? === true

      record.instance_variable_set :@withholding_amount, 99_999_999
      assert record.valid? === true

      record.instance_variable_set :@withholding_amount, 100_000_000
      assert record.valid? === false
    end

    it "will cast withholding amounts to Fixnum" do
      details[:withholding_amount] = "2000"
      record = WageSlave::ABA::DetailRecord.new(details)
      assert record.withholding_amount.class == Fixnum, "class was #{record.withholding_amount.class.name} not Fixnum"
      assert record.withholding_amount === 2000, "withholding amount not equal to fixnum 2000"
      assert record.valid? === true
    end

  end

  describe "#to_s" do
    
    it "will print a valid detail record in ABA format" do

      record = WageSlave::ABA::DetailRecord.new(details)
      aba = record.to_s

      # ABA files are exactly 120 characters wide
      assert aba.length === 120
      
      # Record type
      # Size: 1
      # Char position: 1
      aba.slice(0,1).must_equal record.type

      # BSB of account
      # Size: 7
      # Char position: 2-8
      # Format: XXX-XXX
      aba.slice(1,7).must_equal record.bsb

      # Account number
      # Size: 9
      # Char position: 9-17
      # Blank filled, right justified.
      aba.slice(8,9).must_equal record.account_number.to_s.rjust(9, " ")

      # Indicator
      # Size: 1
      # Char position: 18
      # Valid entries: N, W, X or Y.
      aba.slice(17,1).must_equal record.indicator

      # Transaction Code
      # Size: 2
      # Char position: 19-20
      aba.slice(18,2).must_equal record.transaction_code

      # Amount to be credited or debited
      # Size: 10
      # Char position: 21-30
      # Numeric only, shown in cents. Right justified, zero filled.
      aba.slice(20,10).must_equal record.amount.abs.to_s.rjust(10, "0")

      # Title of Account
      # Full BECS character set valid
      # Size: 32
      # Char position: 31-62
      # Blank filled, left justified.
      aba.slice(30,32).must_equal record.name.ljust(32, " ")

      # Lodgement Reference Produced on the recipient’s Account Statement.
      # Size: 18
      # Char position: 63-80
      # Full BECS character set valid
      # Blank filled, left justified.
      aba.slice(62,18).must_equal record.lodgement_reference.ljust(18," ")

      # Trace BSB Number
      # Size: 7
      # Char position: 81-87
      # Format: XXX-XXX
      aba.slice(80,7).must_equal record.trace_bsb

      # Trace Account Number
      # Size: 9
      # Char position: 88-96
      # Blank filled, right justified.
      aba.slice(87,9).must_equal record.trace_account.rjust(9, " ")

      # Name of Remitter Produced on the recipient’s Account Statement
      # Size: 16
      # Char position: 97-112
      # Full BECS character set valid
      # Blank filled, left justified.
      aba.slice(96,16).must_equal record.remitter.ljust(16, " ")

      # Withholding amount in cents
      # Size: 8
      # Char position: 113-120
      # Numeric only, shown in cents. Right justified, zero filled.
      aba.slice(112,8).must_equal record.withholding_amount.abs.to_s.rjust(8, "0")

    end

    it "will raise a RuntimeError if the record is invalid" do
      record = WageSlave::ABA::DetailRecord.new

      assert record.valid? === false

      -> { record.to_s }.must_raise RuntimeError
    end

  end

end
