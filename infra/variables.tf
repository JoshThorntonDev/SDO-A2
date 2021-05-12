variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "db_instance_count" {
  type    = number
  default = 1
}

variable "db_instance_size" {
  type    = string
  default = "db.t3.medium"
}