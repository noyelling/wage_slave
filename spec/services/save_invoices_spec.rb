require 'spec_helper'

describe WageSlave::SaveInvoices do

  let(:data) {[
    { due_date: Date.today, name: "Nikko Mackintosh", description: "No Yelling commission", quantity: 1, unit_amount: 100, account_code: 240 },
    { due_date: Date.today, name: "Robert Tulis", description: "No Yelling commission", quantity: 1, unit_amount: 100, account_code: 240 },
    { due_date: Date.today, name: "Justin Maher", description: "No Yelling commission", quantity: 1, unit_amount: 100, account_code: 240 },
    { due_date: Date.today, name: "Joanne Donovan", description: "No Yelling commission", quantity: 1, unit_amount: 100, account_code: 240 },
    { due_date: Date.today, name: "Mike Stanley", description: "No Yelling commission", quantity: 1, unit_amount: 100, account_code: 240 },
  ]}

  let(:invoices) {
    WageSlave::BuildInvoices.call data
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
    WageSlave::SaveInvoices.must_be_instance_of Class
  end

  it "will attempt to save a batch of Xeroizer invoices" do

    WageSlave
      .configuration
      .xero.Invoice
      .expects(:save_records).with(invoices)

    WageSlave::SaveInvoices.call invoices

  end

  it "will report errors if the records are invalid" do

    invalid_data = [{ due_date: Date.today, name: nil, description: "No Yelling commission", quantity: 1, unit_amount: 100, account_code: 240 }]

    # Invalidate invoices
    invoices = WageSlave::BuildInvoices.call invalid_data

    invoices.each do | invoice |
      invoice.valid?.must_equal false
    end

    saved_invoices = WageSlave::SaveInvoices.call invoices

    saved_invoices.must_equal false

  end

end
