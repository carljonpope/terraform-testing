# Variables

variable "location" {}

variable "rgName" {}

variable "vmName" {}

variable "tags" {
    type = map
    default = {
        Environment = "tst"
        ApplicationName = "tst"
    }
}

