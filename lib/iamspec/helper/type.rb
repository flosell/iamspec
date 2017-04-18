class String
  # FIXME: dirty monkeypatching stolen from specinfra
  def to_snake_case
    self.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase
  end

  def to_camel_case
    return self if self !~ /_/ && self =~ /[A-Z]+.*/
    split('_').map{|e| e.capitalize}.join
  end
end


module Iamspec
  module Helper
    module Type
      types = %w(
        base iam_user
      )

      types.each {|type| require "iamspec/type/#{type}" }

      types.each do |type|
        define_method type do |*args|
          eval "Iamspec::Type::#{type.to_camel_case}.new(*args)"
        end
      end
    end
  end
end
