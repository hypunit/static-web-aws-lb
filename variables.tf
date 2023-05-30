variable "region" {
    type = string
    default = "us-east-1"
}
variable "access_key" {
    type = string
}
variable "secret_key" {
    type = string
}
variable "subnet_cidr_private" {
  description = "cidr blocks for the private subnets"
  default     = ["10.10.10.0/28", "10.10.10.16/28", "10.10.10.32/28"]
  type        = list(any)
}

variable "availability_zone" {
  description = "availability zones for the private subnets"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
  type        = list(any)
}
