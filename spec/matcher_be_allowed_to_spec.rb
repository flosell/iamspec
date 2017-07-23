require 'spec_helper'


describe 'be_allowed_to matcher' do
  describe 'all cases' do
    subject {be_allowed_to(perform_action('SomeAction'))}
    describe('description') do
      it 'should have a nice description' do
        expect(subject.description).to eq('be allowed to SomeAction')
      end
    end
    it 'should be diffable' do
      expect(subject.diffable?).to be_truthy
    end
  end
  describe 'a simple case' do
    subject {be_allowed_to(perform_action('SomeAction'))}

    describe('matching') do
      it 'should match if AWS says its allowed' do
        stub_simulation([{
            eval_decision:    'allowed',
            eval_action_name: 'SomeAction'
        }])
        expect(subject.matches?(generic_policy_source('some policy source arn'))).to be_truthy
      end

      it 'should not match if AWS says its implicitDeny' do
        stub_simulation([{
            eval_decision:    'implicitDeny',
            eval_action_name: 'SomeAction'
        }])
        expect(subject.matches?(generic_policy_source('some policy source arn'))).to be_falsy
      end

      it 'should not match if AWS says its explicitDeny' do
        stub_simulation([{
            eval_decision:    'explicitDeny',
            eval_action_name: 'SomeAction'
        }])
        expect(subject.matches?(generic_policy_source('some policy source arn'))).to be_falsy
      end
    end

    describe('failure message') do
      it 'should tell us why something was not allowed' do
        stub_simulation([{
            eval_decision:    'implicitDeny',
            eval_action_name: 'SomeAction'
        }])
        subject.matches?(generic_policy_source('some policy source arn'))
        expect(subject.failure_message).to eq('wasn\'t allowed because of implicitDeny for SomeAction')
      end
    end
  end

  describe 'a case with multiple actions' do
    subject {be_allowed_to(perform_actions(['SomeAction', 'SomeOtherAction']))}
    describe('matching') do
      it 'should match if AWS says all actions are allowed' do
        stub_simulation([{
            eval_decision:    'allowed',
            eval_action_name: 'SomeAction'
        },{
            eval_decision:    'allowed',
            eval_action_name: 'SomeOtherAction'
        }])
        expect(subject.matches?(generic_policy_source('some policy source arn'))).to be_truthy
      end

      it 'should not match if AWS says one of the actions is not allowed' do
        stub_simulation([{
            eval_decision:    'allowed',
            eval_action_name: 'SomeAction'
        },{
            eval_decision:    'implicitDeny',
            eval_action_name: 'SomeOtherAction'
        }])
        expect(subject.matches?(generic_policy_source('some policy source arn'))).to be_falsy
      end
    end

    describe('failure message') do
      it 'should tell us why something was not allowed' do
        stub_simulation([{
            eval_decision:    'allowed',
            eval_action_name: 'SomeAction'
        },{
            eval_decision:    'implicitDeny',
            eval_action_name: 'SomeOtherAction'
        }])
        subject.matches?(generic_policy_source('some policy source arn'))
        expect(subject.failure_message).to eq('wasn\'t allowed because of implicitDeny for SomeOtherAction')
      end
    end

    describe('diffing') do
      before(:each) do
        stub_simulation([{
            eval_decision:    'allowed',
            eval_action_name: 'SomeAction'
        },{
            eval_decision:    'implicitDeny',
            eval_action_name: 'SomeOtherAction'
        }])
        subject.matches?(generic_policy_source('some policy source arn'))
      end

      it 'should have an expectation that all our evaluation results are allowed' do
        expect(subject.expected).to eq("SomeAction is allowed\nSomeOtherAction is allowed")
      end
      it 'should have an actual that represents what really happened' do
        expect(subject.actual).to eq("SomeAction is allowed\nSomeOtherAction is implicitDeny")
      end
    end
  end
end

def stub_simulation(evaluation_results)
  iam_client = Aws::IAM::Client.new(stub_responses: true)
  iam_client.stub_responses(:simulate_principal_policy, {
      evaluation_results: evaluation_results
  })
  expect(Aws::IAM::Client).to receive(:new).and_return(iam_client)
end
