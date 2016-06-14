module WageSlave

  class SaveInvoice

    include WageSlave::Base

    def call invoice

    	invoice.save
    	
    end
      
  end

end
