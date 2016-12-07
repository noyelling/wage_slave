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

      attr_reader :bsb, :account_number, :indicator, :transaction_code, :amount, :name,
        :lodgement_reference, :trace_bsb, :trace_account, :remitter, :withholding_amount

      def initialize(attrs={})
        @type                 = "1"
        @bsb                  = attrs[:bsb]
        @account_number       = attrs[:account_number]
        self.indicator        = attrs[:indicator] || "N"
        self.transaction_code = attrs[:transaction_code] || "53"
        @amount               = attrs[:amount].to_i || 0
        @name                 = attrs[:name]
        @lodgement_reference  = attrs[:lodgement_reference] || WageSlave.configuration.user_name
        @trace_bsb            = attrs[:trace_bsb] || WageSlave.configuration.bank_code
        @trace_account        = attrs[:trace_account] || WageSlave.configuration.account_number
        @remitter             = attrs[:remitter] || WageSlave.configuration.user_name
        @withholding_amount   = attrs[:withholding_amount].to_i || 0
      end

      def transaction_code=(code)
        @transaction_code = code if @@transaction_codes.include? code
      end

      def indicator=(key)
        @indicator = key if @@indicators.include? key
      end

      ## 
      # This method was adapted from https://github.com/andrba/aba which is released under MIT.
      # See /LICENSE.txt for details.

      def to_s
        raise RuntimeError.new "Detail record is invalid. Check the contents of 'errors'" unless self.valid?

        # Record type
        # Size: 1
        # Char position: 1
        # Must be 1
        output = @type

        # BSB of account
        # Size: 7
        # Char position: 2-8
        # Format: XXX-XXX
        output += @bsb.to_s

        # Account number
        # Size: 9
        # Char position: 9-17
        # Blank filled, right justified.
        output += @account_number.to_s.rjust(9, " ")

        # Indicator
        # Size: 1
        # Char position: 18
        # Valid entries: N, W, X or Y.
        output += @indicator.to_s.ljust(1, " ")

        # Transaction Code
        # Size: 2
        # Char position: 19-20
        output += @transaction_code.to_s

        # Amount to be credited or debited
        # Size: 10
        # Char position: 21-30
        # Numeric only, shown in cents. Right justified, zero filled.
        output += @amount.to_i.abs.to_s.rjust(10, "0")

        # Title of Account
        # Full BECS character set valid
        # Size: 32
        # Char position: 31-62
        # Blank filled, left justified.
        output += @name.to_s.ljust(32, " ")

        # Lodgement Reference Produced on the recipient’s Account Statement.
        # Size: 18
        # Char position: 63-80
        # Full BECS character set valid
        # Blank filled, left justified.
        output += @lodgement_reference.to_s.ljust(18, " ")

        # Trace BSB Number
        # Size: 7
        # Char position: 81-87
        # Format: XXX-XXX
        output += @trace_bsb.to_s

        # Trace Account Number
        # Size: 9
        # Char position: 88-96
        # Blank filled, right justified.
        output += @trace_account.to_s.rjust(9, " ")

        # Name of Remitter Produced on the recipient’s Account Statement
        # Size: 16
        # Char position: 97-112
        # Full BECS character set valid
        # Blank filled, left justified.
        output += @remitter.to_s.ljust(16, " ")

        # Withholding amount in cents
        # Size: 8
        # Char position: 113-120
        # Numeric only, shown in cents. Right justified, zero filled.
        output += @withholding_amount.abs.to_s.rjust(8, "0")
      end

    end
  end
end
