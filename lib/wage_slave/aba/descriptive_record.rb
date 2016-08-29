module WageSlave
  class ABA
    class DescriptiveRecord < WageSlave::ABA::Record

      @@reel_sequence = 0

      attr_reader :bsb, :financial_institution, :user_name, :user_id, :description, :process_at, :reel_sequence

      attr_writer :transactions

      def initialize(attrs = {})
        @type = "0"
        @bsb = WageSlave.configuration.bank_code
        @financial_institution = WageSlave.configuration.financial_institution
        @user_name = WageSlave.configuration.user_name
        @user_id = WageSlave.configuration.user_id
        @description = WageSlave.configuration.description
        @process_at = attrs[:process_at] || Date.today.strftime('%d%m%y')

        # Bump reel sequence number.
        @reel_sequence = sequence(@@reel_sequence)
        @@reel_sequence+=1
      end

      def to_s
        # Record type
        # Max: 1
        # Char position: 1
        output = self.type

        # Optional branch number of the funds account with a hyphen in the 4th character position
        # Char position: 2-18
        # Max: 17
        # Blank filled
        output += self.bsb.nil? ? " " * 17 : self.bsb.to_s.ljust(17)

        # Sequence number
        # Char position: 19-20
        # Max: 2
        # Zero padded
        output += self.reel_sequence

        # Name of user financial instituion
        # Max: 3
        # Char position: 21-23
        output += self.financial_institution.to_s

        # Reserved
        # Max: 7
        # Char position: 24-30
        output += " " * 7

        # Name of User supplying File
        # Char position: 31-56
        # Max: 26
        # Full BECS character set valid
        # Blank filled
        output += self.user_name.to_s.ljust(26)

        # Direct Entry User ID
        # Char position: 57-62
        # Max: 6
        # Zero padded
        output += self.user_id.to_s.rjust(6, "0")

        # Description of payments in the file (e.g. Payroll, Creditors etc.)
        # Char position: 63-74
        # Max: 12
        # Full BECS character set valid
        # Blank filled
        output += self.description.to_s.ljust(12)

        # Date on which the payment is to be processed
        # Char position: 75-80
        # Max: 6
        output += self.process_at.to_s.rjust(6, "0")

        # Reserved
        # Max: 40
        # Char position: 81-120
        output += " " * 40
      end

      private

      def sequence(number)
        if number < 99
          sprintf '%02d', number+=1
        else
          raise "Reel sequence may not exceed the maximum allowed by the ABA (99)"
        end
      end

    end
  end
end
