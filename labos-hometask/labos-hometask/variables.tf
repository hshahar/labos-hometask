variable "region" {
  description = "The AWS region to create resources in"
  type        = string
  default     = "us-west-2"
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t2.micro"
}

variable "ami" {
  description = "The AMI to use for the instance"
  type        = string
}

variable "vpc_cidr" {
  description = "The IP addresses for your virtual private cloud"
  type        = string
}

variable "route_cidr_block" {
  description = "The IP addresses for your route private cloud"
  type        = string
}

variable "vpc_id_cidr" {
  description = "The IP addresses for your vpc-id private cloud"
  type        = string
}

variable "availability_zone" {
  description = "The availability_zone for the vpc"
  type        = string
}

