module WageSlave

  class SavePayments

    include WageSlave::Base

    def call payments

      WageSlave.configuration.xero.Payment.save_records payments

    end

  end

end