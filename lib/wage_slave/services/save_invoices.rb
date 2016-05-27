module WageSlave

  class SaveInvoices

    include WageSlave::Base

    def call invoices
      WageSlave.configuration.xero.Invoice.save_records invoices
    end
      
  end

end
