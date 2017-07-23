module Iamspec::Type
  def generic_policy_source(arn)
    GenericPolicySource.new(arn)
  end

  class GenericPolicySource
    attr_reader :arn

    def initialize(arn)
      @arn = arn
    end

    def to_s
      type = self.class.name.split(':')[-1]
      type.gsub!(/([a-z\d])([A-Z])/, '\1 \2')
      type.capitalize!
      %Q!#{type} "#{@arn}"!
    end

    def inspect
      to_s
    end

    def to_ary
      to_s.split(" ")
    end
  end
end
