def be_allowed_to(action)
  BeAllowedTo.new(action)
end

class BeAllowedTo
  def initialize(action)
    @action = action
  end

  def matches?(subject)
    @subject = subject
    iam  = Aws::IAM::Client.new(region: 'us-east-1')
    resp = iam.simulate_principal_policy({
        policy_source_arn: subject.arn,
        action_names:      @action.action_names,
        resource_arns:     @action.resource_arns,
    })

    # puts "fooo: #{resp.evaluation_results}"

    @evaluation_results = resp.evaluation_results
    failure_results(@evaluation_results).empty?
  end

  def description
    "be allowed to #{@action.to_s}"
  end

  def failure_message
    "wasn't allowed because of #{failure_strings(@evaluation_results)}"
  end

  def expected
    @evaluation_results.map {|result| "#{result.eval_action_name} is allowed"}.join("\n")
  end

  def actual
    @evaluation_results.map {|result| "#{result.eval_action_name} is #{result.eval_decision}"}.join("\n")
  end

  def diffable?
    true
  end

  private

  def failure_strings(results)
    failure_results(results)
        .map { |result| "#{result.eval_decision} for #{result.eval_action_name}"}
        .join(' and ')
  end

  def failure_results(results)
    results.select {|result| result.eval_decision != 'allowed'}
  end

end
