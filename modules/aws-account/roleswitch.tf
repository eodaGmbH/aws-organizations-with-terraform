locals {
  policy_role_switch_template = file("${path.module}/policy_role_switch.json")
}

// create policies in root account

resource "aws_iam_policy" "roleswitch_reader" {
  name   = "${var.account_name}-reader"
  policy = format(local.policy_role_switch_template, aws_organizations_account.account.id, "reader")
}

resource "aws_iam_policy" "roleswitch_dev" {
  name   = "${var.account_name}-dev"
  policy = format(local.policy_role_switch_template, aws_organizations_account.account.id, "dev")
}

resource "aws_iam_policy" "roleswitch_owner" {
  name   = "${var.account_name}-owner"
  policy = format(local.policy_role_switch_template, aws_organizations_account.account.id, "owner")
}

// create groups in root account

resource "aws_iam_group" "reader" {
  name = "${var.account_name}-reader"
}

resource "aws_iam_group" "dev" {
  name = "${var.account_name}-dev"
}

resource "aws_iam_group" "owner" {
  name = "${var.account_name}-owner"
}

// attach policies to group in root account

resource "aws_iam_group_policy_attachment" "reader" {
  group      = aws_iam_group.reader.name
  policy_arn = aws_iam_policy.roleswitch_reader.arn
}

resource "aws_iam_group_policy_attachment" "dev" {
  // A user in the "dev" group should also be allowed to assume the lower privileged role "reader"
  for_each = {
    reader = aws_iam_policy.roleswitch_reader.arn
    dev    = aws_iam_policy.roleswitch_dev.arn
  }
  group      = aws_iam_group.dev.name
  policy_arn = each.key
}

resource "aws_iam_group_policy_attachment" "owner" {
  // A user in the "owner" group should be allowed to assume all other roles
  for_each = {
    reader = aws_iam_policy.roleswitch_reader.arn
    dev    = aws_iam_policy.roleswitch_dev.arn
    owner  = aws_iam_policy.roleswitch_owner.arn
  }
  group      = aws_iam_group.owner.name
  policy_arn = each.key
}

// add users to groups

resource "aws_iam_group_membership" "reader" {
  group = aws_iam_group.reader.name
  name  = "${var.account_name}-reader-membership"
  users = var.reader_users
}

resource "aws_iam_group_membership" "dev" {
  group = aws_iam_group.dev.name
  name  = "${var.account_name}-dev-membership"
  users = var.dev_users
}

resource "aws_iam_group_membership" "owner" {
  group = aws_iam_group.owner.name
  name  = "${var.account_name}-owner-membership"
  users = var.owner_users
}
