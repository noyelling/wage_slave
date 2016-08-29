module WageSlave
  class ABA

    def initialize(transactions = [])
      @descriptive_record = WageSlave::ABA::DescriptiveRecord.new
    end

  end
end
