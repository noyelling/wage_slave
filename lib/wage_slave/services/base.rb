module BaseService
	def self.included(base)
		base.extend ClassMethods
	end

	module ClassMethods
		def call(*args, &block)
			@instance ||= self.new
			@instance.call(*args, &block)
		end
	end
end