class WageSlave::BuildInvoices

	attr_accessor :payments

	def initialize(payments)
		@payments = payments
	end

	def build_invoices(item_description, due_date, item_quantity, account_code)

		@payments.map { |instructor| 
      WageSlave::Invoice.new({
        name: "Test Name", 
        email: instructor[1][0]["email"], 
        item_amount: instructor[1][0]["commission"], 
				due_date: due_date, 
        item_description: item_description, 
        item_quantity: item_quantity, 
        account_code: account_code 
			}).build
    }

	end

end
