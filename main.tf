terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {

}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  count = 2

  instance_type          = "t2.micro"
  monitoring             = true
  vpc_security_group_ids = ["sg-039da37dd0401a632",
                            "sg-039da37dd0401a632"]
  subnet_id              = var.subnet_ids[count.index]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
resource "aws_elb" "bar" {
  name               = "my-elb"
  subnets = module.vpc.public_subnets
  security_groups = ["sg-039da37dd0401a632",
                     "sg-039da37dd0401a632"]

  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }

  instances                   = [for instance in var.ec2_instance_ids : instance]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "my-elb"
  }
}

