module WageSlave
  class ABA
    class DetailRecordValidator

      include WageSlave::Validate

      validates :bsb, 
        with: proc { |p| p.bsb =~ /^\d{3}-\d{3}$/ },
        msg: "is not in the required format (xxx-xxx)"

      validates :account_number,
        with: proc { |p| p.account_number.to_s =~ /[\d\- ]/ && p.account_number !~ /[0{8}]/ },
        msg: "not a valid account number"

      validates :indicator, type: String

      validates :transaction_code, type: String

      validates :amount,
        with: proc { |p| p.amount > 0 && p.amount < 9_999_999_999 },
        msg: "must be greater than 0 and less than 9,999,999,999"

      validates :name,
        with: proc { |p| !p.name.to_s.empty? },
        msg: "is required"

    end
  end
end
