module Iamspec::Action
  def assume_role(role_name)
    AssumeRole.new(role_name)
  end

  class AssumeRole < GenericAction
    def initialize(role_name)
      @role_name = role_name
      super(['sts:AssumeRole'], ["arn:aws:iam::#{get_account_id}:role/#{role_name}"])
    end

    def to_s
      "assume role #{@role_name}"
    end
  end
end
