variable "region" {
    description = "AWS-region"
    type = string
    default = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID"
  type        = string
  default     = "ami-05c13eab67c5d8861"  # Amazon Linux 2 AMI in us-east-1
}