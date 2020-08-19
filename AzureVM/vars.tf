# Variables

variable "location" {}

variable "rgname" {}

variable "tags" {
    type = map
    default = {
        Environment = "tst"
        ApplicationName = "tst"
    }
}

