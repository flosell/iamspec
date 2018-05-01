module Iamspec::Type
  include Iamspec::Helpers

  def iam_user(account_id=AccountHelper.current_account_id, name)
    ArnPolicySource.new(account_id,name, 'user', 'IAM User')
  end
  def iam_role(account_id=AccountHelper.current_account_id, name)
    ArnPolicySource.new(account_id,name, 'role', 'IAM Role')
  end
  def iam_group(account_id=AccountHelper.current_account_id, name)
    ArnPolicySource.new(account_id,name, 'group', 'IAM Group')
  end

  class ArnPolicySource < GenericPolicySource
    def initialize(account_id, user_name, arn_type, human_readable_name)
      super("arn:aws:iam::#{account_id}:#{arn_type}/#{user_name}")
      @user_name = user_name
      @human_readable_name = human_readable_name
    end

    def to_s
      "#{@human_readable_name} \"#{@user_name}\"" + context_entries_to_s
    end
  end
end
