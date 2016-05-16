module WageSlave
  module ABA
    module Payroll

      class << self
        attr_accessor :aba

        def build(transactions, process_at = Time.now.strftime("%d%m%y"))
          @aba = Aba.batch({ 
            financial_institution: WageSlave.configuration.financial_institution,
            user_name: WageSlave.configuration.user_name,
            bsb: WageSlave.configuration.bank_code,
            user_id: WageSlave.configuration.user_id,
            description: WageSlave.configuration.description,
            process_at: process_at
          }, transactions.map { |t| t.merge({ transaction_code: 53 }) })
        end
      end

    end
  end
end
