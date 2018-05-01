require_relative 'generic_allowed_to.rb'

# TODO: shouldn't this be `should_not be_allowed_to perform_action('iam:ListUsers')`?

def not_be_allowed_to(action)
  NotBeAllowedTo.new(action)
end

class NotBeAllowedTo < GenericAllowedTo
  def initialize(action)
    @action = action
  end

  def matches?(subject)
    @evaluation_results = super(subject)
    failure_results(@evaluation_results).empty?
  end

  def description
    "not be allowed to #{@action.to_s}#{@action.userid ? ' with userid ' + @action.userid : ''}"
  end

  def failure_message
    "#{@action.to_s} was allowed because of #{failure_strings(@evaluation_results)}"
  end

  def expected
    @evaluation_results.map {|result| "#{result.eval_action_name} is not allowed"}.join("\n")
  end

  def diffable?
    true
  end

  private

  def failure_results(results)
    results.select {|result| result.eval_decision == 'allowed'}
  end

end
