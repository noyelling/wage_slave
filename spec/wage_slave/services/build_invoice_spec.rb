require 'spec_helper'

describe WageSlave::BuildInvoice do

  let(:data) {[
    { due_date: Date.today, name: "Nikko Mackintosh", description: "No Yelling commission", quantity: 1, unit_amount: 100, account_code: 240 },
    { due_date: Date.today, name: "Robert Tulis", description: "No Yelling commission", quantity: 1, unit_amount: 100, account_code: 240 },
    { due_date: Date.today, name: "Justin Maher", description: "No Yelling commission", quantity: 1, unit_amount: 100, account_code: 240 },
    { due_date: Date.today, name: "Joanne Donovan", description: "No Yelling commission", quantity: 1, unit_amount: 100, account_code: 240 },
    { due_date: Date.today, name: "Mike Stanley", description: "No Yelling commission", quantity: 1, unit_amount: 100, account_code: 240 },
  ]}

  it "must be a class" do
    WageSlave::BuildInvoice.must_be_instance_of Class
  end

  it "will build an array of Xeroizer Invoice Objects" do

    WageSlave.configure do | config |
      config.xero = {
      consumer_key: "test",
      consumer_secret: "test",
      pem_file_location: "test",
    }
    end

    xero_invoices = WageSlave::BuildInvoice.call data

    xero_invoices.must_be_instance_of Array

    xero_invoices.each do | x |
      x.must_be_instance_of Xeroizer::Record::Invoice
    end

  end

end
