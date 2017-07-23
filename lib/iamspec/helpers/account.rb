module Iamspec::Helpers
  class AccountHelper
    IAM_REGION = 'us-east-1'
    def self.current_account_id
      sts = Aws::STS::Client.new(region: IAM_REGION)
      sts.get_caller_identity.account
    end
  end
end
