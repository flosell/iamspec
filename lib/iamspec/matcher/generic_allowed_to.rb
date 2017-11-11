class GenericAllowedTo
  def matches?(subject)
    @subject = subject
    iam_opts ||= {region: 'us-east-1'}
    iam_opts[:credentials] = @action.creds if @action and @action.creds
    iam = Aws::IAM::Client.new(iam_opts)
    opts = {
        action_names: @action.action_names,
        resource_arns: @action.resource_arns,
    }
    opts[:policy_source_arn] = subject.arn if subject.is_a? Iamspec::Type::GenericPolicySource
    opts[:policy_input_list] = [@action.policy] if @action.policy
    opts[:caller_arn] = @action.caller_arn if @action.caller_arn
    opts[:context_entries] = @action.context_entries.values
    opts[:resource_policy] = @action.policy_string if @action.policy_string
    resp = iam.simulate_principal_policy(opts)

    # puts "fooo: #{resp.evaluation_results}"

    resp.evaluation_results
  end
end
