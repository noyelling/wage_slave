require 'spec_helper'

describe WageSlave::SaveInvoice do

  let(:data) {[
    { due_date: Date.today, name: "Nikko Mackintosh", description: "No Yelling commission", quantity: 1, unit_amount: 100, account_code: 240 },
    { due_date: Date.today, name: "Robert Tulis", description: "No Yelling commission", quantity: 1, unit_amount: 100, account_code: 240 },
    { due_date: Date.today, name: "Justin Maher", description: "No Yelling commission", quantity: 1, unit_amount: 100, account_code: 240 },
    { due_date: Date.today, name: "Joanne Donovan", description: "No Yelling commission", quantity: 1, unit_amount: 100, account_code: 240 },
    { due_date: Date.today, name: "Mike Stanley", description: "No Yelling commission", quantity: 1, unit_amount: 100, account_code: 240 }
  ]}

  let(:invoice) {
    WageSlave::BuildInvoice.call data
  }

  before :each do
    WageSlave.configure do | config |
      config.xero = {
        consumer_key: "test",
        consumer_secret: "test",
        pem_file_location: "test",
      }
    end
  end

  it "must be a class" do
    WageSlave::SaveInvoice.must_be_instance_of Class
  end

  it "will save a Xeroizer invoice" do

    invoice
    .expects(:save)

    WageSlave::SaveInvoice.call invoice

  end

  # Commented out until Xeroizer allows for Line Item Validation

  # it "will report errors if the records are invalid" do

  #   invalid_data = []

  #   # Invalidate invoice
  #   invoice = WageSlave::BuildInvoice.call invalid_data

  #   invoice.valid?.must_equal false

  #   saved_invoice = WageSlave::SaveInvoice.call invoice

  #   saved_invoice.must_equal false

  # end

end
