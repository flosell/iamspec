require 'spec_helper'

describe Iamspec::Type do

  describe iam_user('SomeAccountId', 'SomeUser') do
    it 'should have a correct arn' do
      expect(subject.arn).to eq('arn:aws:iam::SomeAccountId:user/SomeUser')
    end

    it 'should have a human readable name' do
      expect(subject.to_s).to eq('IAM User "SomeUser"')
    end
  end
  describe iam_role('SomeAccountId', 'SomeRole') do
    it 'should have a correct arn' do
      expect(subject.arn).to eq('arn:aws:iam::SomeAccountId:role/SomeRole')
    end

    it 'should have a human readable name' do
      expect(subject.to_s).to eq('IAM Role "SomeRole"')
    end
  end

  describe iam_group('SomeAccountId', 'SomeGroup') do
    it 'should have a correct arn' do
      expect(subject.arn).to eq('arn:aws:iam::SomeAccountId:group/SomeGroup')
    end

    it 'should have a human readable name' do
      expect(subject.to_s).to eq('IAM Group "SomeGroup"')
    end
  end
end
