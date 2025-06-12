variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-2"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "key_name" {
  description = "SSH key pair name to access EC2 instances"
  type        = string
  default     = "petra-hs-project"   # Change this to your actual key pair name in AWS
}

variable "vpc_id" {
  description = "VPC ID where instances will be launched"
  type        = string
  default     = "vpc-00762ade5bbfce868"     # Change to your VPC ID
}

variable "subnet_ids" {
  description = "List of subnet IDs in the VPC"
  type        = list(string)
  default     = ["subnet-071b487d93bd190a8", "subnet-0a45d2d21609ffb5a", "subnet-00eb8b06a1ee85266"]  # Change to your subnet IDs
}

variable "db_instance_type" {
  default = "t3.small" # 2 vCPUs, 2 GB RAM (burstable)
}

