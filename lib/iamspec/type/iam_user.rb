module Iamspec::Type
  def iam_user(name)
    IamUser.new(name)
  end

  class IamUser < GenericPolicySource
    def initialize(user_name)
      super("arn:aws:iam::#{get_account_id}:user/#{user_name}")
      @user_name = user_name
    end

    def to_s
      "IAM User \"#{@user_name}\""
    end
  end
end
