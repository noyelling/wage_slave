class WageSlave::Payment

	attr_accessor :xero_id, :payment_amount

	def initialize(attrs = {})
		@xero_id= attrs[:xero_id]
		@payment_amount= attrs[:payment_amount]
	end

end