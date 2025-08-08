# Provider
provider "aws" {
  region = "us-east-1"
}

# VPC Module Block
module "vpc" {
  source                   = "./vpc"
  environment              = "dev"
  project                  = "shackshine"
  owner                    = "saratchandramotamarri"
  public_subnet_cidr_block = "10.0.1.0/24"
  availability_zone        = "us-east-1a"
  aws_region               = "us-east-1"
  cidr_block               = "10.0.0.0/16"
  security_group_id        = "sg-xxxxxxxx"
}

module "ec2" {
  source = "./ec2"

  vpc_id            = module.vpc.vpc_id
  subnet_id         = module.vpc.public_subnet_id
  security_group_id = module.vpc.security_group_id
  ami_id            = "ami-08a6efd148b1f7504"
  instance_type     = "t2.micro"
  instance_name     = "Shackshine-EC2-Instance"
}

module "s3" {
  source = "./s3"

  bucket_name = "shackshines3bucket-${random_string.bucket_suffix.result}"
}

resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

