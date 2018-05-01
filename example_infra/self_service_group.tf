resource "aws_iam_group" "mfa_self_service" {
  name = "some_mfa_self_service_group"
}

resource "aws_iam_group_policy" "mfa_self_service_list_mfa" {
  group = "${aws_iam_group.mfa_self_service.name}"
  policy = "${data.aws_iam_policy_document.list_mfa.json}"
}

data "aws_iam_policy_document" "list_mfa" {
  statement {
    effect = "Allow"
    actions = ["iam:ListMFADevices"]
    resources = ["arn:aws:iam::${var.account_id}:user/$${aws:username}"]
  }
}
