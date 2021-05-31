data "aws_caller_identity" "root" {}

resource "aws_organizations_account" "account" {
  # Account name for the "My organizations" overview
  # This is not the account alias which can be used
  # when switching roles
  name = var.account_name
  # Globally unique email address.
  # Each email account can only have one AWS account
  email = var.email_address
  # A role will be automatically created which has
  # full admin rights. Let's call it "owner"
  role_name = "owner"
  # Tags are not required, but might be helpful for others
  # in the future who read the assigned tags.
  tags = {
    "terraform-managed" : true
  }
}

resource "aws_iam_account_alias" "alias" {
  provider      = aws.sub-account
  account_alias = var.account_name
}