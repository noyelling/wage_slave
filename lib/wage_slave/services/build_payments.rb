module WageSlave

  class BuildPayments

    include WageSlave::Base

    def call payments
      payments.map { | p | 
        WageSlave.configuration.xero.Payment.build(
          date: Date.today,
          amount: p[:amount],
          invoice: { invoice_id: p[:id] },
          account: { code: p[:account_code] }
        )
      }
    end

  end
end
