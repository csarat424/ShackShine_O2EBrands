# provider block
provider "aws" {
  region = "us-east-1"
}


# VPC Block
resource "aws_vpc" "ShackShine_VPC" {
  cidr_block         = var.cidr_block
  enable_dns_support = true

  tags = {
    Name        = "ShackShine_VPC"
    Environment = var.environment
    Project     = var.project
    Owner       = var.owner
  }
}

# Subnet Block
resource "aws_subnet" "Public_Subnet" {
  vpc_id            = aws_vpc.ShackShine_VPC.id
  cidr_block        = var.public_subnet_cidr_block
  availability_zone = var.availability_zone

  tags = {
    Name        = "Public_Subnet"
    Environment = var.environment
    Project     = var.project
    Owner       = var.owner
  }
}

# Internet Gateway Block
resource "aws_internet_gateway" "Igw" {
  vpc_id = aws_vpc.ShackShine_VPC.id

  tags = {
    Name        = "Igw"
    Environment = var.environment
    Project     = var.project
    Owner       = var.owner
  }
}

# Route Table Block
resource "aws_route_table" "Public_RT" {
  vpc_id = aws_vpc.ShackShine_VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Igw.id
  }

  tags = {
    Name        = "${aws_vpc.ShackShine_VPC.tags.Name}-public-rt"
    Environment = "var.environment"
    Project     = var.project
    Owner       = var.owner
  }
}

# Route Table Association Block
resource "aws_route_table_association" "Public_RTA" {
  subnet_id      = aws_subnet.Public_Subnet.id
  route_table_id = aws_route_table.Public_RT.id

}

# Security Group Block
resource "aws_security_group" "Security_Group" {
  name   = "shackshine-security_group"
  vpc_id = aws_vpc.ShackShine_VPC.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow all traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }



  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "shackshine-security_group"
    Environment = var.environment
    Project     = var.project
    Owner       = var.owner
  }
}
