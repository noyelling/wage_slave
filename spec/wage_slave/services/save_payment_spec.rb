require 'spec_helper'

describe WageSlave::SavePayment do

  let(:data) {
      { id: "00000000-0000-0000-000000000000", account_code: 821, date: Date.today, amount: 123.45 }
  }

  let(:payment) {
    WageSlave::BuildPayment.call data
  }

  before :each do
    WageSlave.configure do |config|
      config.xero = {
          consumer_key: "test",
          consumer_secret: "test",
          pem_file_location: "test"
      }
    end
  end

  it "must be a class" do
    WageSlave::SavePayment.must_be_instance_of Class
  end

  it "will attempt to save a Xeroizer Payment" do

    payment
    .expects(:save)

    WageSlave::SavePayment.call payment

  end

end