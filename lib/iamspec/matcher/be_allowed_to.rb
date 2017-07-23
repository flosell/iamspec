RSpec::Matchers.define :be_allowed_to do |action|
  match do |policy_source|

    iam  = Aws::IAM::Client.new(region: 'us-east-1')
    resp = iam.simulate_principal_policy({
        policy_source_arn: policy_source.arn,
        action_names:      action.action_names,
        resource_arns:     action.resource_arns,
    })
    @evaluation_result  = resp.evaluation_results[0]
    @evaluation_result.eval_decision == 'allowed'
  end

  description do |subject|
    "be allowed to #{action.to_s}"
  end

  failure_message do |subject|
    "expected #{subject} to be allowed to #{action.to_s} but wasn't because of #{@evaluation_result.eval_decision}"
  end
end
