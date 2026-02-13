resource "aws_vpc" "portfolio_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = { Name = "Portfolio-VPC" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.portfolio_vpc.id
  tags   = { Name = "Portfolio-IGW" }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.portfolio_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true # Automatically assigns Public IP
  availability_zone       = "us-east-1a"
  tags                    = { Name = "Portfolio-Public-Subnet" }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.portfolio_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}


resource "aws_security_group" "rhel_sg" {
  name        = "rhel-security-group"
  vpc_id      = aws_vpc.portfolio_vpc.id

  # Allow Web Traffic
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Secure SSH - Replace with your IP for a "Pro" touch
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Change this to "YOUR_IP/32" later
  }

  
ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"] # Change this to "YOUR_IP/32" later
  }

  # Allow all outbound (to download RHEL updates)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "rhel_web" {
  ami           = "ami-034faf0d89478216e" # RHEL 9 in us-east-1
  instance_type = "t3.micro"               # FREE TIER
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.rhel_sg.id]
  key_name      = "portfolio_key"          # Make sure you created this in AWS Console

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>test for micro micro </h1>" > /var/www/html/index.html
              EOF

  tags = { Name = "RHEL-Web-Server" }
}

resource "aws_eip" "portfolio_eip" {
  instance = aws_instance.rhel_web.id
  domain   = "vpc"
}
