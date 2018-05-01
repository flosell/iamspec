require 'spec_helper'

describe 'AWS IAM Integration' do
  account_id = Iamspec::Helpers::AccountHelper.current_account_id

  describe('Using a generic resource') do
    describe generic_policy_source("arn:aws:iam::#{account_id}:user/some_user_with_admin_permissions")
                 .with_context('aws:multifactorauthpresent', 'true', 'boolean') do
      it { should be_allowed_to perform_action('sts:AssumeRole').with_resource("arn:aws:iam::#{account_id}:role/Administrator") }
    end

    describe generic_policy_source("arn:aws:iam::#{account_id}:user/some_user_without_admin_permissions") do
      it { should_not be_allowed_to perform_action('sts:AssumeRole').with_resource("arn:aws:iam::#{account_id}:role/Administrator") }
    end

    describe generic_policy_source("arn:aws:iam::#{account_id}:role/SomeRole") do
      it { should be_allowed_to perform_actions(['ec2:DescribeInstances','ec2:DescribeAddresses','ec2:DescribeVolumes']) }
    end

    describe generic_policy_source("arn:aws:iam::#{account_id}:group/some_mfa_self_service_group") do
      it { should be_allowed_to perform_action('iam:ListMFADevices')
                                    .with_resource("arn:aws:iam::#{account_id}:user/the-current-user")
                                    .with_context('aws:username', 'the-current-user') }
    end

  end

  describe('Using syntactic sugar') do
    describe('for users') do
      describe iam_user('some_user_with_admin_permissions').with_mfa_present(true) do
        it { should be_allowed_to assume_role('Administrator') }
      end
      describe iam_user('some_user_with_admin_permissions').with_mfa_present(false) do
        it { should not_be_allowed_to assume_role('Administrator') }
      end

      describe iam_user('some_user_without_admin_permissions') do
        it { should_not be_allowed_to assume_role('Administrator') }
      end
    end

    describe('for roles') do
      describe iam_role('SomeRole') do
        it { should be_allowed_to perform_action('ec2:DescribeInstances') }
      end
    end
  end

end
