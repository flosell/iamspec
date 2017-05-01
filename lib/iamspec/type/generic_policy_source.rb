module Iamspec::Type
  def get_account_id
    # TODO: the wrong place here
    sts = Aws::STS::Client.new(region: 'us-east-1')
    sts.get_caller_identity.account
  end

  def generic_policy_source(arn)
    GenericPolicySource.new(arn)
  end

  class GenericPolicySource
    attr_reader :name

    def initialize(name)
      @name    = name
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
  end
end
