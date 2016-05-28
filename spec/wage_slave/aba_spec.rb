require "spec_helper"

describe Aba do
	
	describe ".batch" do

		it	"initialize instance of Aba::Batch with passed arguments" do
			atrributes = double.as_null_object
			transactions = double.as_null_object

			expect(Aba::Batch).to receive(:new).with(attributes, transactions)
			described_class.batch(attributes, transactions)
		end

	end

end