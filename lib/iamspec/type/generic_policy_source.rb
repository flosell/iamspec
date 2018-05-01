module Iamspec::Type
  def generic_policy_source(arn)
    GenericPolicySource.new(arn)
  end

  class GenericPolicySource
    attr_reader :arn
    attr_reader :context_entries

    def initialize(arn)
      @arn = arn
      @context_entries = {}
    end

    def with_mfa_present(b)
      with_context("aws:multifactorauthpresent", b.to_s, "boolean")
    end

    def with_context(key, value, type="string")
      @context_entries[key] = Aws::IAM::Types::ContextEntry.new({context_key_name: key, context_key_values: [value], context_key_type: type})
      self
    end


    def to_s
      type = self.class.name.split(':')[-1]
      type.gsub!(/([a-z\d])([A-Z])/, '\1 \2')
      type.capitalize!
      %Q!#{type} "#{@arn}"! + " "+context_entries_to_s
    end

    def context_entries_to_s
      if not @context_entries.empty?
        " with " + @context_entries.values.map do |entry|
          context_entry_to_s(entry)
        end.join(" and ")
      else
        ""
      end
    end

    def context_entry_to_s(entry)
      if entry.context_key_name == "aws:multifactorauthpresent"
        if entry.context_key_values == ["true"]
          "MFA present"
        else
          "MFA absent"
        end
      else
        entry.context_key_name + '=' + entry.context_key_values.join(",")
      end
    end

    def inspect
      to_s
    end

    def to_ary
      to_s.split(" ")
    end
  end
end
