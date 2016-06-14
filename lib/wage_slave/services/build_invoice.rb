module WageSlave

  class BuildInvoice

    include WageSlave::Base

    def call payments
        WageSlave.configuration.xero.Invoice.build(
          type: "ACCREC",
          status: "AUTHORISED",
          line_amount_types: "Inclusive",
          date: Date.today,
          due_date: Date.today,
          contact: { name: "No Yelling" },
          line_items: payments.map { | p | 
            {
              description: p[:description],
              quantity: p[:quantity],
              unit_amount: p[:unit_amount],
              account_code: p[:account_code]
            }
          }
        )
    end
      
  end

end