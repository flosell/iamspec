module Iamspec::Type
  def iam_user(name)
    IamUser.new(name, {})
  end

  class IamUser < Base
    def able_to_assume_role?(role_name)
      iam = Aws::IAM::Client.new(region: 'us-east-1')
      resp = iam.simulate_principal_policy({
          policy_source_arn: "arn:aws:iam::#{account_id}:user/#{name}",
          action_names: ['sts:AssumeRole'],
          resource_arns: ["arn:aws:iam::#{account_id}:role/#{role_name}"], # TODO: should also be possible with other accounts
      })
      resp.evaluation_results[0].eval_decision == 'allowed'
    end
  end
end
