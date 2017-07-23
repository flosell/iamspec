resource "aws_iam_role" "administrator" {
  name = "Administrator"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy_iam_user.json}"
}

resource "aws_iam_role" "some_role" {
  name = "SomeRole"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy_iam_user.json}"
}

data "aws_iam_policy_document" "describe_instances" {
  statement {
    actions = ["ec2:DescribeInstances"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "describe_instances" {
  policy = "${data.aws_iam_policy_document.describe_instances.json}"
  role = "${aws_iam_role.some_role.id}"
}
