class WageSlave::Invoice

  attr_accessor :name, :email, :item_amount, :due_date, :item_description, :item_quantity, :account_code, :xero_id

  def initialize(attrs = {})
    @id= DateTime.now
    @name= attrs[:name]
    @email= attrs[:email]
    @item_amount= attrs[:item_amount]
    @due_date = attrs[:due_date] # Format: Wed, 18 May 2016
    @item_description = attrs[:item_description]
    @item_quantity = attrs[:item_quantity]
    @account_code = attrs[:account_code]
    @xero_id= nil
  end

  ## Build a single line Authorised invoice for XERO.
  ## Developer must specify a Due Date, Description, Quantity, Amount, Account Code, Name.

  ## No Yelling Commission Invoice Data
  # due_date         = Date.today
  # item_description = "No Yelling Commission"
  # item_quantity    = 1
  # item_amount      = invoice.item_amount
  # account_code     = 240
  # name             = invoice.name

  def build
    WageSlave.configuration.xero.Invoice.build(
      :type => "ACCREC", :date => Date.today, :due_date => self.due_date, :line_amount_types => "Inclusive", 
      :line_items => {:description => self.item_description, :quantity => self.item_quantity, :unit_amount => self.item_amount, 
      :account_code => self.account_code}, :contact => {:name => self.name}, :status => "AUTHORISED"
      )
  end

end