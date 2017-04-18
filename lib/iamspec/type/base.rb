module Iamspec::Type
  class Base

    attr_reader :name
    attr_reader :account_id

    def initialize(name=nil, options = {})
      @name    = name
      @options = options

      @account_id = get_account_id
      # @runner  = Specinfra::Runner
    end

    def to_s
      type = self.class.name.split(':')[-1]
      type.gsub!(/([a-z\d])([A-Z])/, '\1 \2')
      type.capitalize!
      %Q!#{type} "#{@name}"!
    end

    def inspect
      if defined?(PowerAssert)
        @inspection
      else
        to_s
      end
    end

    def to_ary
      to_s.split(" ")
    end

    private

    def get_account_id
      sts = Aws::STS::Client.new(region: 'us-east-1')
      sts.get_caller_identity.account
    end
  end
end
