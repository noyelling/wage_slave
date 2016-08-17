module WageSlave
	class Aba
		def self.batch(attrs = {}, transactions = [])
			Aba::Batch.new({
				financial_institution: attrs[:financial_institution] || WageSlave.configuration.financial_institution,
	      bsb: attrs[:bsb] || WageSlave.configuration.bank_code,
	      user_name: attrs[:user_name] || WageSlave.configuration.user_name,
	      user_id: attrs[:user_id] || WageSlave.configuration.user_id,
	      process_at: attrs[:process_at] || Time.now.strftime("%d%m%y"),
	      description: attrs[:description] || "Payroll"
			}, transactions)
		end
	end
end
