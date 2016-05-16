class WageSlave::Invoice
  attr_accessor :name, :email, :status, :description, :transfer, :commission, :xero_id

  def initialize(attrs = {})
    @id= DateTime.now
    @name= attrs[:name]
    @email= attrs[:email]
    @status= attrs[:status]
    @transfer= attrs[:transfer]
    @commission= attrs[:commission]
    @xero_id= nil
  end

  def build
    if self.transfer
      return build_transfer_invoice(self.name, self.transfer)
    elsif self.commission
      return build_commission_invoice(self.name, self.commission)
    else
      return false
    end
  end

  private

  def build_transfer_invoice(name, transfer)

    ::XERO.Invoice.build(:type => "ACCREC", :date => Date.today, :due_date => Date.today + 7.days, :line_amount_types => "NoTax", 
          :line_items => {:description => "No Yelling Transfer", :quantity => 1, :unit_amount => transfer.to_f.abs, :account_code => 821}, :contact => {:name => name},
          :status => "AUTHORISED"
          )
  end

  def build_commission_invoice(name, commission)
    ::XERO.Invoice.build(:type => "ACCREC", :date => Date.today, :due_date => Date.today, :line_amount_types => "Inclusive", 
          :line_items => {:description => "No Yelling Commission", :quantity => 1, :unit_amount => commission, :account_code => 240}, :contact => {:name => name},
          :status => "AUTHORISED"
          )
  end
end
