require "spec_helper"

describe WageSlave::Aba do
	
	describe ".batch" do

			let(:attributes) {{ financial_institution: 'ANZ', user_name: 'Joe Blow', user_id: 123456, process_at: 200615 }}
			let(:transactions) {[
        { bsb: '123-456', account_number: '000-123-456', amount: 50000 }, 
        { bsb: '456-789', account_number: '123-456-789', amount: '10000', transaction_code: 13 }
      ]}

		it	"initialize instance of Aba::Batch with passed arguments" do

			WageSlave::Aba::Batch.expects(:new).with(attributes, transactions)
			WageSlave::Aba::Batch.new(attributes, transactions)

		end

		it "returns instance of Aba::Batch" do

			obj = WageSlave::Aba.batch(attributes, transactions)

			obj.must_be_kind_of(WageSlave::Aba::Batch)
		end

	end

end
