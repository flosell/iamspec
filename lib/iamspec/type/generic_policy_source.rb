RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.include_chain_clauses_in_custom_matcher_descriptions = true
  end
end

RSpec::Matchers.define :be_allowed_to do |entry|
  match do |subject|
    if subject.respond_to?(:allowed_to?)
      if @resource_arn.nil?
        subject.allowed_to?(entry, [])
      else
        subject.allowed_to?(entry, [@resource_arn])
      end
    end
  end

  # For cron type
  chain :with_resource do |arn|
    @resource_arn = arn
  end
end

module Iamspec::Type
  def generic_policy_source(arn)
    GenericPolicySource.new(arn, {})
  end

  class GenericPolicySource < Base
    def allowed_to?(action_name, resource_arns)
      iam  = Aws::IAM::Client.new(region: 'us-east-1')
      resp = iam.simulate_principal_policy({
          policy_source_arn: name,
          action_names:      [action_name],
          resource_arns:     resource_arns,
      })
      resp.evaluation_results[0].eval_decision == 'allowed'
    end
  end
end
