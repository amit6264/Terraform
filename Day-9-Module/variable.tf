variable "ami_id" {
  description = "Passing values to main.tf"
  type = string
  default = ""
}

variable "type" {
  type = string
  default = ""
}

variable "bucket" {
  type = string
  default = ""
}