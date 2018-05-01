resource "aws_iam_user" "some_user_with_admin_permissions" { name = "some_user_with_admin_permissions" }
resource "aws_iam_user" "some_user_without_admin_permissions" { name = "some_user_without_admin_permissions" }


data "aws_iam_policy_document" "assume_administrator_roles" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::${var.account_id}:role/Administrator"]

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }
}

resource "aws_iam_user_policy" "some_user_with_admin_permissions_assume_administrator_roles" {
  policy = "${data.aws_iam_policy_document.assume_administrator_roles.json}"
  user = "${aws_iam_user.some_user_with_admin_permissions.id}"
}
