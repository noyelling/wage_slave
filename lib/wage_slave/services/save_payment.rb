module WageSlave

  class SavePayment

    include WageSlave::Base

    def call payment
    	payment.save
    end

  end

end