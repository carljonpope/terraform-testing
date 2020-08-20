# Variables

variable "location" {}

variable "rgName" {}

variable "vmName" {}

variable "publisher" {}

variable "offer" {}

variable "sku" {}

variable "version" {}

variable "tags" {
    type = map
    default = {
        Environment = "tst"
        ApplicationName = "tst"
    }
}

