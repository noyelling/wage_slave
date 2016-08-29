module WageSlave
  class ABA
    class DetailRecord < WageSlave::ABA::Record

      include WageSlave::Validation

      # Key   Value
      # ===========
      # "N"   For new or varied Bank/State/Branch number or name details, otherwise blank filled.
      #
      #       Withholding Tax Indicators
      #       ==========================
      # "W"   Dividend paid to a resident of a country where a double tax agreement is in force.
      # "X"   Dividend paid to a resident of any other country.
      # "Y"   Interest paid to all non-residents.

      @@indicators = Set.new ["N", "W", "X", "Y"]

      # Code	Transaction Description
      # =============================
      # 13	  Externally initiated debit items
      # 50	  Externally initiated credit items with the exception of those bearing Transaction Codes
      # 51	  Australian Government Security Interest
      # 52	  Family Allowance
      # 53	  Pay
      # 54	  Pension
      # 55	  Allotment
      # 56	  Dividend
      # 57	  Debenture/Note Interest

      @@transaction_codes = Set.new [
        "13", "50", "51", "52", "53", "54", "55", "56", "57"
      ]

      attr_accessor :bsb, :account_number, :indicator, :transaction_code, :amount, :name, :lodgement_reference,
        :trace_bsb, :trace_account, :remitter, :witholding_amount

      def initialize(attrs={})
        @type                 = "1"
        @bsb                  = attrs[:bsb] || ""
        @account_number       = attrs[:account_number] || ""
        @indicator            = attrs[:indicator] || "N"
        @transaction_code     = attrs[:transaction_code] || "53"
        @amount               = attrs[:amount] || 0
        @name                 = attrs[:name] || ""
        @lodgement_reference  = attrs[:lodgement_reference] || WageSlave.configuration.user_name
        @trace_bsb            = attrs[:trace_bsb] || WageSlave.configuration.bank_code
        @trace_account        = attrs[:trace_account] || WageSlave.configuration.account_number
        @remitter             = attrs[:remitter] || WageSlave.configuration.user_name
        @witholding_amount    = attrs[:tax_withholding] || 0
      end

      def transaction_code=(code)
        @transaction_code = code if @@transaction_codes.include? code
      end

      def indicator=(key)
        @indicator = key if @@indicators.include? key
      end

      def to_s
        raise RuntimeError, 'Transaction data is invalid - check the contents of `errors`' unless self.valid?

        # Record type
        output = @type

        # BSB of account
        output += @bsb

        # Account number
        output += @account_number.to_s.rjust(9, " ")

        # Withholding Tax Indicator
        output += @indicator.to_s.ljust(1, " ")

        # Transaction Code
        output += @transaction_code.to_s

        # Amount to be credited or debited
        output += @amount.to_i.abs.to_s.rjust(10, "0")

        # Title of Account
        # Full BECS character set valid
        output += @account_name.to_s.ljust(32, " ")

        # Lodgement Reference Produced on the recipient’s Account Statement.
        # Full BECS character set valid
        output += @lodgement_reference.to_s.ljust(18, " ")

        # Trace BSB Number
        output += @trace_bsb

        # Trace Account Number
        output += @trace_account_number.to_s.rjust(9, " ")

        # Name of Remitter Produced on the recipient’s Account Statement
        # Full BECS character set valid
        output += @remitter.to_s.ljust(16, " ")

        # Withholding amount in cents
        output += @witholding_amount.abs.to_s.rjust(8, "0")
      end

    end
  end
end
