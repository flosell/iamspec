require 'aws-sdk'
require 'iamspec/version'
%w( base generic_policy_source iam_user).each {|type| require "iamspec/type/#{type}"}

extend Iamspec::Type
class RSpec::Core::ExampleGroup
  extend Iamspec::Type
  include Iamspec::Type
end
