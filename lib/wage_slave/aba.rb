module WageSlave
  class ABA

		attr_reader :descriptive_record, :details

    def initialize(transactions = [])
      @descriptive_record = WageSlave::ABA::DescriptiveRecord.new
			@details = WageSlave::ABA::DetailCollection.new(transactions)
    end

		def to_s
			output = @descriptive_record.to_s + "\r\n"
			output += @details.to_s + "\r\n"

			# Record Type
			# Max: 1
			# Char position: 1
			# Must be 7
			output += "7"

			# BSB format filler
			# Max: 7
			# Char position: 2-8
			# Must be 999-999
			output += "999-999"

			# Reserved
			# Max: 12
			# Char position: 9-20
			# Blank filled
			output += " " * 12

			# Net total amount
			# Max: 10
			# Char position: 21-30
			# Right justified, zero filled.
			output += @details.net_total.abs.to_s.rjust(10, "0")

			# Credit total amount
			# Max: 10
			# Char position: 31-40
			# Right justified, zero filled.
			output += @details.credit_total.abs.to_s.rjust(10, "0")

			# Debit total amount
			# Max: 10
			# Char position: 41-50
			# Right justified, zero filled.
			output += @details.debit_total.abs.to_s.rjust(10, "0")

			# Reserved
			# Max: 24
			# Char position: 51-74
			# Blank filled
			output += " " * 24

			# Count of Type 1 records
			# Max: 6
			# Char position: 75-80
			# Right justified, zero filled.
			output += @details.size.to_s.rjust(6, "0")

			# Reserved
			# Max: 40
			# Char position: 81-120
			# Blank filled
			output += " " * 40
		end

  end
end
