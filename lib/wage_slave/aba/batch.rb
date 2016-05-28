module WageSlave

	class Aba

		class Batch

			include WageSlave::Aba::Validations

			attr_accessor :bsb, :financial_institution, 
						  :user_name, :user_id, :description, 
						  :process_at, :transactions

			def initialize(attrs = {}, transactions = [])
				attrs.each do |key, value|
					send("#{key}=", value)
				end

				@transaction_index = 0
				@transactions = {}

				unless transactions.nil? || transactions.empty?
					transactions.to_a.each do |t|
						self.add_transactions(t) unless t.nil? || t.empty?
					end
				end

				yield self if block_given?

			end

		end

	end

end