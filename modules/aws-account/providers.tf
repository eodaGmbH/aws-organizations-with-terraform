provider "aws" {
  region = "eu-central-1"
  alias  = "sub-account"

  assume_role {
    # Switch into the account we created in this module
    role_arn = "arn:aws:iam::${aws_organizations_account.account.id}:role/${aws_organizations_account.account.role_name}"
  }
}