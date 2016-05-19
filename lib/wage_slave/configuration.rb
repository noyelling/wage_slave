module WageSlave

  ##
  # Configuration for WageSlave
  #
  # @financial_institution is your bank
  # @bank_code is your BSB for Australian banks
  # @user_id is your banking account ID
  # @description is the default description for transactions

  class Configuration
    attr_accessor( 
      :financial_institution, 
      :bank_code, 
      :user_id, 
      :user_name, 
      :description,
      :xero_consumer_key,
      :xero_consumer_secret,
      :xero_pem_file_location)

    def initialize
      @financial_institution = nil
      @bank_code = nil
      @user_id = nil
      @user_name = nil
      @description = "Payroll"
      @xero_consumer_key = nil
      @xero_consumer_secret = nil
      @xero_consumer_pem_file_location = nil
    end
  end

  ##
  # Simple way to configure WageSlave
  # WageSlave.configure do | config |
  #   config.bank_code = "123-234"
  # end

  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def reset
      @configuration = Configuration.new
    end

    def configure
      yield(configuration)
    end
  end

end
