require 'aws-sdk'
require 'iamspec/version'
require 'iamspec/helper/type'
module Iamspec
  # Your code goes here...
end

extend Iamspec::Helper::Type
class RSpec::Core::ExampleGroup
  extend Iamspec::Helper::Type
  include Iamspec::Helper::Type
end
