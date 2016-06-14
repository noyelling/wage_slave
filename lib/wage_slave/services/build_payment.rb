module WageSlave

  class BuildPayment

    include WageSlave::Base

    def call invoice

        WageSlave.configuration.xero.Payment.build(
          date: Date.today,
          amount: invoice[:amount],
          invoice: { invoice_id: invoice[:id] },
          account: { code: invoice[:account_code] }
        )
        
    end
  end
end
