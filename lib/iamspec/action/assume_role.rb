module Iamspec::Action
  include Iamspec::Helpers

  def assume_role(account_id=AccountHelper.current_account_id, role_name)
    AssumeRole.new(account_id, role_name)
  end

  class AssumeRole < GenericAction
    def initialize(account_id, role_name)
      @role_name = role_name
      super(['sts:AssumeRole'], ["arn:aws:iam::#{account_id}:role/#{role_name}"])
    end

    def to_s
      "assume role #{@role_name}"
    end
  end
end
