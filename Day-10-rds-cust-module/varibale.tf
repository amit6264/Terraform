variable "security_group_id" {
  type = string
  default = ""
}

variable "subnet_1" {
  type = string
  default = ""
}

variable "subnet_2" {
  type = string
  default = ""
}

variable "allocated_storage" {
  type = any 
  default = ""
}

variable "db_name" {
  type = string
  default = ""
}

variable "identifier" {
  type = string
  default = ""
}

variable "engine" {
  type = string
  default = ""
}

variable "engine_version"{
   type = string
   default = ""
}

variable "instance_class" {
  type = string
  default = ""
}

variable "username" {
  type = string
  default = ""
}

variable "password" {
  type = string
  default = ""
}

variable "db_subnet_group" {
  type = string
  default = ""
}

variable "tags" {
  description = "Tags for the resources"
  type        = map(string)
}