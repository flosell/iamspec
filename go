#!/bin/bash
set -e

SCRIPT_DIR=$(cd $(dirname $0) ; pwd -P)

tf() {
  pushd "${SCRIPT_DIR}/example_infra" > /dev/null
    terraform $1
  popd > /dev/null
}

goal_test() {
  pushd "${SCRIPT_DIR}" > /dev/null
    bundle exec rake spec
  popd > /dev/null
}

goal_example-infra-plan() {
  tf "plan"
}

goal_example-infra-apply() {
  tf "plan"
}

if type -t "goal_$1" &>/dev/null; then
  goal_$1 ${@:2}
else
  echo "usage: $0 <goal>
goal:
    test                    -- run all tests

    example-infra-plan      -- terraform plan on example infra
    example-infra-apply     -- terraform apply on example infra
"
  exit 1
fi
