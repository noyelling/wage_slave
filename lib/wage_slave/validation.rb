# A module mixin for simple Ruby data validation. No Rails needed. Basic, but highly extentable with different kinds of
# validators. You can create new validation types by adding to the case statement on line 77, and adding an accompanying
# method.

module WageSlave

  module Validation
    def valid?
      klass = Object.const_get("#{self.class.name}Validator")
      @validator = klass.new(self)
      @validator.valid?
    end

    def errors
      return {} unless defined?(@validator)
      @validator.errors
    end
  end

  class ValidationErrors
    attr_accessor :all

    def initialize
      @all = {}
    end

    def add(name, msg)
      (@all[name] ||= []) << msg
    end

    def full_messages
      @all.map do |e|
        "#{e.first.capitalize} #{e.last.join(' & ')}. "
      end.join
    end
  end

  module Validate
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.extend(ClassMethods)
    end

    module InstanceMethods
      attr_reader :object, :errors

      def initialize(object)
        @object = object
        @errors = ValidationErrors.new
      end

      def valid?
        self.class.validators.each { |args| validate(args) }
        @errors.all.empty?
      end

      private

      def validate(args)
        case
        when args[1].key?(:with)
          with_validator(*args)
        when args[1].key?(:type)
          type_validator(*args)
        end
      end

      def with_validator(name, options)
        fail unless options[:with].call(@object)
      rescue
        @errors.add(name, options[:msg])
      end

      def type_validator(name, options)
        return if @object.send(name).is_a?(options[:type])
        @errors.add(name, "must be a #{options[:type].name}")
      end
    end

    module ClassMethods
      def validates(*args)
        create_validation(args)
      end

      def validators
        @validators
      end

      private

      def create_validation(args)
        @validators = [] unless defined?(@validators)
        @validators << args
      end
    end
  end

end
