module Iamspec::Type
  def iam_user(name)
    IamUser.new("arn:aws:iam::#{get_account_id}:user/#{name}", {})
  end

  class IamUser < GenericPolicySource
    def able_to_assume_role?(role_name)
      allowed_to?('sts:AssumeRole', ["arn:aws:iam::#{get_account_id}:role/#{role_name}"])
    end
  end
end
