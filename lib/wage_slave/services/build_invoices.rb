module WageSlave

  class BuildInvoices

    include WageSlave::Base

    def call payments
      payments.map { | p |
        WageSlave.configuration.xero.Invoice.build(
          type: "ACCREC",
          status: "AUTHORISED",
          line_amount_types: "Inclusive",
          date: Date.today,
          due_date: p[:due_date],
          contact: { name: p[:name] },
          line_items: {
            description: p[:description],
            quantity: p[:quantity],
            unit_amount: p[:amount],
            account_code: p[:account_code]
          }
        ) 
      }
    end
      
  end

end
