
module WageSlave
	class Aba
		def self.batch(attrs = {}, transactions = [])
			Aba::Batch.new(attrs, transactions)
		end
	end
end