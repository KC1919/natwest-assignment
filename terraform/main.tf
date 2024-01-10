terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.region
}

resource "aws_instance" "test_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = "test-instance"
  }

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.test_network_interface.id
  }
}

resource "aws_network_interface" "test_network_interface" {
  subnet_id       = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.test_sg.id]
}

resource "aws_vpc" "test_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "test-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.test_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a" # Replace with your desired availability zone
  map_public_ip_on_launch = true

  tags = {
    Name = "test-public-subnet"
  }
}

# resource "aws_instance_network_interface_attachment" "test_instance_net_interface_attachment" {
#   instance_id          = aws_instance.test_instance.id
#   network_interface_id = aws_network_interface.test_network_interface.id
#   device_index         = 0
# }


resource "aws_internet_gateway" "test_gateway" {
  vpc_id = aws_vpc.test_vpc.id

  tags = {
    Name = "test-internet-gateway"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.test_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_gateway.id
  }

  tags = {
    Name = "test-public-route-table"
  }
}

resource "aws_route_table_association" "public_table_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}


resource "aws_security_group" "test_sg" {
  name        = "test-security-group"
  description = "Allow inbound SSH and HTTP traffic"
  vpc_id      = aws_vpc.test_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}