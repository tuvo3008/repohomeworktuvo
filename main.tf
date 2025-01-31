terraform {
  backend "s3" {
    bucket         = "tuvo-s3-bucket"
    # key            = "terraform-jenkins"
    region         = "us-west-1"
    encrypt        = true
    # role_arn       = "arn:aws:iam::<ACCOUNT_ID>:role/Terraform-SeriesS3BackendRole"
    # dynamodb_table = "terraform-series-s3-backend"
  }
}

provider "aws" {
  region = "us-west-1"
}

data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "server" {
  ami           = data.aws_ami.ami.id
  instance_type = "t3.micro"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "Server"
  }
}

output "public_ip" {
  value = aws_instance.server.public_ip
}