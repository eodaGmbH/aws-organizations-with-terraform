module "my_subaccount" {
  source        = "./modules/aws-account"
  account_name  = "my-account-name"
  email_address = "my-team@my-company.com"
}
