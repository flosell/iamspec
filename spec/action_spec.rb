require 'spec_helper'

describe Iamspec::Action do
  describe('a simple action') do
    describe('without resources') do
      subject { perform_action('SomeAction')}

      it('should have one action name and no resources') do
        expect(subject.action_names).to eq(['SomeAction'])
        expect(subject.resource_arns).to eq([])
      end

      it('should have a good string representation') do
        expect(subject.to_s).to eq('SomeAction')
      end
    end
    describe('with resources') do
      subject { perform_action('SomeAction').with_resource('SomeResource')}

      it('should have an action name and resources') do
        expect(subject.action_names).to eq(['SomeAction'])
        expect(subject.resource_arns).to eq(['SomeResource'])
      end

      it('should have a good string representation') do
        expect(subject.to_s).to eq('SomeAction on SomeResource')
      end

    end
  end
  describe('multiple actions') do
    describe('without resources') do
      subject { perform_actions(['SomeAction','SomeOtherAction'])}

      it('should have one action name and no resources') do
        expect(subject.action_names).to eq(['SomeAction','SomeOtherAction'])
        expect(subject.resource_arns).to eq([])
      end

      it('should have a good string representation') do
        expect(subject.to_s).to eq('SomeAction,SomeOtherAction')
      end
    end
    describe('with resources') do
      subject { perform_actions(['SomeAction','SomeOtherAction']).with_resource('SomeResource')}

      it('should have an action name and resources') do
        expect(subject.action_names).to eq(['SomeAction','SomeOtherAction'])
        expect(subject.resource_arns).to eq(['SomeResource'])
      end

      it('should have a good string representation') do
        expect(subject.to_s).to eq('SomeAction,SomeOtherAction on SomeResource')
      end

    end
  end
end
