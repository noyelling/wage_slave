module WageSlave
	class ABA
		class DetailCollection < Array

			def initialize(details = [])
				self.concat(
					details.map { |d| WageSlave::ABA::DetailRecord.new(d) }
				)
			end

			def net_total
				self.credit_total + self.debit_total
			end

			def credit_total
				self
					.select { |d| d.amount > 0 }
					.reduce(0) { |acc, n| acc + n.amount }
			end

			def debit_total
				self
					.select { |d| d.amount < 0 }
					.reduce(0) { |acc, n| acc + n.amount }
			end

			def to_s
				self.map(&:to_s).join("\r\n")
			end

		end
	end
end
