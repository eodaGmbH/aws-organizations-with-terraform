variable "account_name" {}
variable "email_address" {}
variable "reader_users" {
  type    = list(string)
  default = []
}
variable "dev_users" {
  type    = list(string)
  default = []
}
variable "owner_users" {
  type    = list(string)
  default = []
}