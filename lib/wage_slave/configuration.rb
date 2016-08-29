module WageSlave

  ##
  # Configuration for WageSlave
  #
  # @financial_institution is your bank
  # @bank_code is your BSB for Australian banks
  # @user_id is your banking account ID
  # @description is the default description for transactions

  class Configuration
    attr_accessor :financial_institution, :bank_code, :user_id, :user_name, :account_number, :description

    def initialize
      @financial_institution = nil
      @bank_code = nil
      @account_number = nil
      @user_id = "000001"
      @user_name = nil
      @description = "Payroll"
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
