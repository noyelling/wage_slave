require 'wage_slave'
require 'csv'

invoices = []

path = "/Users/jasper/Desktop/PaymentFile.csv"

CSV.foreach(path, headers: true, header_converters: :symbol) do |row|
	if !row[:commission].nil?
		row.delete(:transfer)
		invoices.push(row)
	end
end

comms = invoices.map { |i| 
	{
		due_date: Date.today,
		name: i[:name],
		description: i[:name] + " Commission",
		quantity: 1,
		unit_amount: i[:commission],
		account_code: 240,
	}
 }

@invoice = WageSlave::BuildInvoice.call comms

WageSlave::SaveInvoice.call @invoice

payment = {
	id: @invoice.id, 
	amount: @invoice.total, 
	account_code: 821 
}

p = WageSlave::BuildPayment.call payment

WageSlave::SavePayment.call p