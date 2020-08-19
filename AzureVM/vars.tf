# Variables

variable "location" {}

variable "rgName" {}

variable "tags" {
    type = map
    default = {
        Environment = "tst"
        ApplicationName = "tst"
    }
}

