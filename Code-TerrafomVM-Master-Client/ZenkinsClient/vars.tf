variable "location" {
  type    = string
  default = "eastus2"
}
variable "prefix" {
  type    = string
  default = "vmclient"
}

variable "tags" {
}

variable "ssh-source-address" {
  type    = string
  default = "*"
}

