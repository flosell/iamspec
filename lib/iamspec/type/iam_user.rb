module Iamspec::Type
  def iam_user(name)
    IamUser.new(name)
  end

  class IamUser < GenericPolicySource
    def initialize(name)
      super("arn:aws:iam::#{get_account_id}:user/#{name}", {})
      @user_name = name
    end

    def able_to_assume_role?(role_name)
      allowed_to?('sts:AssumeRole', ["arn:aws:iam::#{get_account_id}:role/#{role_name}"])
    end

    def to_s
      "IAM User \"#{@user_name}\""
    end
  end
end
