require 'spec_helper'

describe 'AWS IAM Integration' do
  describe iam_user('some_user_with_admin_permissions') do
    it { should be_able_to_assume_role('Administrator')}
  end

  describe iam_user('some_user_without_admin_permissions') do
    it { should_not be_able_to_assume_role('Administrator')}
  end
end
