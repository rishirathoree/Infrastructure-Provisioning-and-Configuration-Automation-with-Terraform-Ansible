variable "environment" {
    description = "The environment for the VPC (e.g., dev, staging, prod)"
    type        = string
}

variable "vpc_cidr" {
    description = "The CIDR block for the VPC"
    type        = string
}

variable "public_subnet_cidr" {
    description = "The CIDR block for the public subnet"
    type        = string
}

variable "ami" {
    description = "The AMI ID for the EC2 instance"
    type        = string
}

variable "instance_type_jenkins" {
    description = "The instance type for the EC2 instance"
    type        = string
}
variable "instance_type_agent" {
    description = "The instance type for the EC2 instance"
    type        = string
}
variable "key_name" {
    description = "The name of the key pair to use for the EC2 instance"
    type        = string
}
