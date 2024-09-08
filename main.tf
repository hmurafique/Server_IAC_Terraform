# main.tf

provider "aws" {
  region = "us-east-1d" #
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1d"
  tags = {
    Name = "subnet1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1d"
  tags = {
    Name = "subnet2"
  }
}

resource "aws_security_group" "instance_sg" {
  vpc_id = aws_vpc.main.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "instance-sg"
  }
}

resource "aws_instance" "server" {
  ami           = "i-0f629d6e3a8329fd7"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet1.id
  security_groups = [aws_security_group.instance_sg.name]
  tags = {
    Name = "ServerInstance"
  }
}

resource "aws_instance" "client" {
  ami           = "i-07855260a2a60ff23"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet2.id
  security_groups = [aws_security_group.instance_sg.name]
  tags = {
    Name = "ClientInstance"
  }
}
