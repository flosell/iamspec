module Iamspec::Action
  def perform_action(action_name, resource_arns = [])
    GenericAction.new([action_name], resource_arns)
  end

  class GenericAction
    attr_reader :action_names
    attr_reader :resource_arns

    def initialize(action_names, resource_arns)
      @action_names = action_names
      @resource_arns = resource_arns
    end

    def to_s
      if @resource_arns.empty?
        action_names.join(',')
      else
        "#{action_names.join(',')} on #{resource_arns.join(',')}"
      end
    end

    def with_resource(resource_arn)
      @resource_arns = [resource_arn]
      self
    end
  end
end
