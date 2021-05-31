locals {
  // The policy is the same for all roles, so we read it once to stay DRY
  // It allows the root account to switch to these roles
  policy_assume_role = templatefile("${path.module}/policy_assume_role.json.tpl", {
    root_account_id = data.aws_caller_identity.root.account_id
  })
}

resource "aws_iam_role" "reader" {
  provider           = aws.sub-account
  name               = "reader"
  assume_role_policy = local.policy_assume_role
  tags = {
    "terraform-managed" : true
  }
}

resource "aws_iam_role" "dev" {
  provider           = aws.sub-account
  name               = "dev"
  assume_role_policy = local.policy_assume_role
  tags = {
    "terraform-managed" : true
  }
}

// Give roles the desired permissions

resource "aws_iam_role_policy_attachment" "reader" {
  provider   = aws.sub-account
  role       = aws_iam_role.reader.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "dev" {
  for_each = toset([
    "arn:aws:iam::aws:policy/ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
  ])
  provider   = aws.sub-account
  role       = aws_iam_role.dev.name
  policy_arn = each.key
}