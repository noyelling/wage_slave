module WageSlave
  class ABA
    class DescriptiveRecord < WageSlave::ABA::Record

      include WageSlave::Validation

      ##
      # Reel sequence becomes important for payment runs of multiple ABA files. 
      # It is incremented each time a descriptive record is created.

      @@reel_sequence = 0

      attr_reader :bsb, :financial_institution, :user_name, :user_id, :description, :process_at, :reel_sequence

      def initialize(attrs = {})
        @type                   = "0"
        @bsb                    = WageSlave.configuration.bank_code
        @financial_institution  = WageSlave.configuration.financial_institution
        @user_name              = WageSlave.configuration.user_name
        @user_id                = WageSlave.configuration.user_id
        @description            = WageSlave.configuration.description
        @process_at             = attrs[:process_at] || Date.today

        # Bump reel sequence number.
        @reel_sequence = '%02d' % @@reel_sequence+=1
      end

      ## 
      # This method was adapted from https://github.com/andrba/aba which is released under MIT.
      # See /LICENSE.txt for details.

      def to_s
        raise RuntimeError.new "Descriptive record is invalid. Check the contents of 'errors'" unless self.valid?

        # Record type
        # Size: 1
        # Char position: 1
        # Must be 0
        output = @type

        # Optional branch number of the funds account
        # Char position: 2-18
        # Size: 17
        # Format: XXX-XXX
        # Blank filled
        output += @bsb.nil? ? " " * 17 : @bsb.to_s.ljust(17)

        # Sequence number
        # Char position: 19-20
        # Size: 2
        # Zero padded
        output += @reel_sequence

        # Name of user financial instituion
        # Size: 3
        # Char position: 21-23
        output += @financial_institution.to_s

        # Reserved
        # Size: 7
        # Char position: 24-30
        output += " " * 7

        # Name of User supplying File
        # Char position: 31-56
        # Size: 26
        # Full BECS character set valid
        # Blank filled
        output += @user_name.to_s.ljust(26)

        # Direct Entry User ID
        # Char position: 57-62
        # Size: 6
        # Zero padded
        output += @user_id.to_s.rjust(6, "0")

        # Description of payments in the file (e.g. Payroll, Creditors etc.)
        # Char position: 63-74
        # Size: 12
        # Full BECS character set valid
        # Blank filled
        output += @description.to_s.ljust(12)

        # Date on which the payment is to be processed
        # Char position: 75-80
        # Size: 6
        output += @process_at.strftime("%d%m%y")

        # Reserved
        # Size: 40
        # Char position: 81-120
        output += " " * 40
      end

    end
  end
end
