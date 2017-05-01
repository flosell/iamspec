require 'spec_helper'

def get_account_id
  # TODO: duplicate
  sts = Aws::STS::Client.new(region: 'us-east-1')
  sts.get_caller_identity.account
end

describe 'AWS IAM Integration' do
  describe("Using a generic resource") do
    describe generic_policy_source("arn:aws:iam::#{get_account_id}:user/some_user_with_admin_permissions") do
      it { should be_allowed_to('sts:AssumeRole').with_resource("arn:aws:iam::#{get_account_id}:role/Administrator") }
    end

    describe generic_policy_source("arn:aws:iam::#{get_account_id}:user/some_user_without_admin_permissions") do
      it { should_not be_allowed_to('sts:AssumeRole').with_resource("arn:aws:iam::#{get_account_id}:role/Administrator") }
    end
  end

  describe('Using syntactic sugar') do
    describe iam_user('some_user_with_admin_permissions') do
      it { should be_able_to_assume_role('Administrator') }
    end

    describe iam_user('some_user_without_admin_permissions') do
      it { should_not be_able_to_assume_role('Administrator') }
    end
  end

end
