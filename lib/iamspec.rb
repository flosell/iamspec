require 'aws-sdk'
require 'iamspec/version'
require 'iamspec/helpers/account'
require 'iamspec/matcher/be_allowed_to'
require 'iamspec/type/generic_policy_source'
require 'iamspec/type/iam_user'
require 'iamspec/action/generic_action'
require 'iamspec/action/assume_role'

extend Iamspec::Type
class RSpec::Core::ExampleGroup

  extend Iamspec::Type
  include Iamspec::Type
  extend Iamspec::Action
  include Iamspec::Action
end
