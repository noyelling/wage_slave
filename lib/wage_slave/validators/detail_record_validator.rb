module WageSlave
  class ABA
    class DetailRecordValidator

      include WageSlave::Validate

      validates :type,
        with: proc { |p| p.type === '1' },
        msg: "must be '1'"

      validates :bsb, 
        with: proc { |p| p.bsb =~ /^\d{3}-\d{3}$/ },
        msg: "is not in the required format (xxx-xxx)"

      validates :account_number,
        with: proc { |p| p.account_number.to_s =~ /^[\d\- ]{1,9}$/ && p.account_number !~ /^0*$/ },
        msg: "not a valid account number"

      validates :indicator, 
        type: String,
        msg: "must be defined as a String"

      validates :transaction_code, 
        type: String,
        msg: "must be defined as a String"

      validates :amount,
        with: proc { |p| p.amount > 0 && p.amount <= 9_999_999_999 },
        msg: "must be greater than 0 and less than 10,000,000,000"

      validates :name,
        with: proc { |p| p.name.to_s.length > 0 && p.name.to_s.length <= 32 },
        msg: "is required and must not be longer than 32 characters"

      validates :lodgement_reference,
        with: proc { |p| p.lodgement_reference.to_s.length > 0 && p.lodgement_reference.to_s.length <= 18 },
        msg: "is required and must not be longer than 18 characters"

      validates :trace_bsb,
        with: proc { |p| p.trace_bsb =~ /^\d{3}-\d{3}$/ },
        msg: "is not in the required format (xxx-xxx)"

      validates :trace_account,
        with: proc { |p| p.trace_account.to_s =~ /^[\d\- ]{1,9}$/ && p.trace_account !~ /^0*$/ },
        msg: "not a valid account number"

      validates :remitter,
        with: proc { |p| p.remitter.to_s.length > 0 && p.remitter.to_s.length <= 16 },
        msg: "is required and must not be longer than 16 characters"

      validates :withholding_amount,
        with: proc { |p| p.withholding_amount <= 99_999_999 },
        msg: "must be less than 100,000,000"

    end
  end
end
