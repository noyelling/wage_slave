module WageSlave
  class ABA
    class DescriptiveRecordValidator

      include WageSlave::Validate

      validates :type,
        with: proc { |p| p.type === "0" },
        msg: "must be '0'"

      validates :bsb, 
        with: proc { |p| p.bsb.nil? ? true : p.bsb.to_s =~ /^\d{3}-\d{3}$/ },
        msg: "is not in the required format (xxx-xxx)"

      validates :financial_institution,
        with: proc { |p| p.financial_institution.to_s.length === 3 },
        msg: "must be valid 3 character abbreviation of an Australian financial institution"

      validates :user_name,
        with: proc { |p| p.user_name.to_s.length <= 26 },
        msg: "must not exceed 26 characters"

      validates :user_id,
        with: proc { |p| p.user_id.to_s =~ /^\d{1,6}$/ },
        msg: "is required, must not exceed 6 characters and may only be numeric"

      validates :description,
        with: proc { |p| p.description.to_s.length <= 12 },
        msg: "must not exceed 12 characters"

      validates :process_at,
        with: proc { |p| p.process_at.is_a? Date },
        msg: "must be an instance of Date"

      validates :reel_sequence,
        with: proc { |p| p.reel_sequence =~ /^\d{2}$/ },
        msg: "must be 2 digits up to 99"

    end
  end
end
