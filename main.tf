module "my_subaccount" {
  source        = "./modules/aws-account"
  account_name  = "my-account-name"
  email_address = "my-team@my-company.com"
  owner_users   = ["some-iam-username"]
  dev_users     = ["developer-a", "developer-b"]
  reader_users  = ["junior-developer-x", "manager-y"]
}
