module Iamspec::Type
  include Iamspec::Helpers

  def iam_user(account_id=AccountHelper.current_account_id, name)
    IamUser.new(account_id,name)
  end

  class IamUser < GenericPolicySource
    def initialize(account_id, user_name)
      super("arn:aws:iam::#{account_id}:user/#{user_name}")
      @user_name = user_name
    end

    def to_s
      "IAM User \"#{@user_name}\""
    end
  end
end
