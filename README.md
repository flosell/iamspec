# IAMSpec

RSpec Tests for AWS IAM using the AWS Policy Simulator - inspired by serverspec.

**Caution: this is a proof of concept I hacked together on a weekend. Don't expect everything to work perfectly!** - However, I'm interested in feedback, drop me a line if this feels useful to you!

The other day, after making some changes to our projects IAM configuration, I told my colleague: _"It should work now"_. When he tried it, it didn't. No worries, I found the mistake, fixed it and on second try, it worked. 

But something kept nagging me: As a developer, I don't usually tell people "it _should_ work". I write tests, I _know_ it works. But somehow, I didn't do that in an area that counts, identity and access management. IAMSpec is my attempt in filling this gap.

**TODO: asciicinema**
 
## FAQ

### What does it do? 

It automates dealing with the AWS Policy Simulator. It allows you to write tests against your IAM configuration

### Does it support everything I can do in IAM? 

No. It uses the AWS Policy Simulator in the background so iamspec can only check what's supported by the Policy Simulator.

For example, assume role policies seem to be ignored. 

### Does it support Terraform/CloudFormation/...?
 
IAMSpec runs your tests against the state in IAM, therefore it is independent from some tool. It is meant to run after you applied your changes in your favorite tool. 

### So it will only tell me after I broke something? 

Yes, unless you set up a separate "staging accounts" where you test your IAM config before rolling it out. Support for testing policy-files separately might be added in the future to at least partly solve this issue. 

### Can I extend it? 

Sure, you can write your own syntactic sugar based on `GenericAction` and `GenericType`. And if you think others can profit from your extension, why not send in a pull request?

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'iamspec'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install iamspec

Then add it to your `spec_helper`

    require "iamspec"

## Usage

Write your first test: 

```ruby
describe('Using syntactic sugar') do
  describe iam_user('some_user_with_admin_permissions') do
      it { should be_allowed_to assume_role('Administrator') }
  end
end
# OR 
describe("Using a generic resource") do
  describe generic_policy_source("arn:aws:iam::#{SOME_ACCOUNT_ID}:user/some_user_with_admin_permissions") do
    it { should be_allowed_to perform_action('sts:AssumeRole').with_resource("arn:aws:iam::#{SOME_ACCOUNT_ID}:role/Administrator") }
  end
end
```

See [`integration_spec.rb`](spec/integration_spec.rb) for more examples or TODO API docs

## TODO

* [ ] more syntactic sugar
* [ ] spec directly against policy JSON

## Development

The `go`-script is your central entrypoint. Call it without arguments to see what's available.

The integration-tests require an AWS account with certain IAM resources set up. Use the `go` script to apply the `example_infra` terraform code to do this (don't use a production account!)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/flosell/iamspec.

