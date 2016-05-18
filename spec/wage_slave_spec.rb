require 'spec_helper'

describe WageSlave do

  before :each do
    WageSlave.reset
  end

  it "is a Module" do
    WageSlave.must_be_instance_of Module
  end

  describe "configuration" do

    it "has a default financial_institution of nil" do
      WageSlave.configuration.financial_institution.must_equal nil
    end

    it "has a default bank_code of nil" do
      WageSlave.configuration.bank_code.must_equal nil
    end

    it "has a default user_id of nil" do
      WageSlave.configuration.user_id.must_equal "000001"
    end

    it "has a default description of 'Payroll'" do
      WageSlave.configuration.description.must_equal "Payroll"
    end

    it "has a default xero_consumer_key of nil" do
      WageSlave.configuration.xero_consumer_key.must_equal nil
    end

    it "has a default xero_consumer_secret of nil" do
      WageSlave.configuration.xero_consumer_secret.must_equal nil
    end

    it "has a default xero_pem_file_location of nil" do
      WageSlave.configuration.xero_pem_file_location.must_equal nil
    end

  end

  describe "configure" do
    
    it "allows the programmer to configure the financial_institution" do
      WageSlave.configure do | config |
        config.financial_institution = "ANZ"
      end

      WageSlave.configuration.financial_institution.must_equal "ANZ"
    end

    it "allows the programmer to configure the bank_code" do
      WageSlave.configure do | config |
        config.bank_code = "000-000"
      end

      WageSlave.configuration.bank_code.must_equal "000-000"
    end

    it "allows the programmer to configure the user_id" do
      WageSlave.configure do | config |
        config.user_id = "1209309709712"
      end

      WageSlave.configuration.user_id.must_equal "1209309709712"
    end

    it "allows the programmer to configure the description" do
      WageSlave.configure do | config |
        config.description = "A new description"
      end

      WageSlave.configuration.description.must_equal "A new description"
    end

    it "allows the programmer to configure the xero keys" do
      WageSlave.configure do | config |
        config.xero_consumer_key = "XERO_CONSUMER_KEY"
        config.xero_consumer_secret = "XERO_CONSUMER_SECRET"
        config.xero_pem_file_location = "XERO_PEM_FILE_LOCATION"
      end

      WageSlave.configuration.xero_consumer_key.must_equal "XERO_CONSUMER_KEY"
      WageSlave.configuration.xero_consumer_secret.must_equal "XERO_CONSUMER_SECRET"
      WageSlave.configuration.xero_pem_file_location.must_equal "XERO_PEM_FILE_LOCATION"
    end

  end

end
