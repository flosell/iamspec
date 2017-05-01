resource "aws_iam_role" "administrator" {
  name = "Administrator"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy_iam_user.json}"
}

