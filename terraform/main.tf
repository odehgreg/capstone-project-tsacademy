resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "novara-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "novara-igw"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = true

  tags = {
    Name                                                       = "novara-public-a"
    Type                                                       = "public"
    SubnetType                                                 = "Utility"
    "kubernetes.io/cluster/cluster.dev.taskapp-james-greg.xyz" = "shared"
    "kubernetes.io/role/elb"                                   = "1"
    "kubernetes.io/role/internal-elb"                          = "1"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = true

  tags = {
    Name                                                       = "novara-public-b"
    Type                                                       = "public"
    SubnetType                                                 = "Utility"
    "kubernetes.io/cluster/cluster.dev.taskapp-james-greg.xyz" = "shared"
    "kubernetes.io/role/elb"                                   = "1"
    "kubernetes.io/role/internal-elb"                          = "1"
  }
}

resource "aws_subnet" "public_c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "eu-west-1c"
  map_public_ip_on_launch = true

  tags = {
    Name                                                       = "novara-public-c"
    Type                                                       = "public"
    SubnetType                                                 = "Utility"
    "kubernetes.io/cluster/cluster.dev.taskapp-james-greg.xyz" = "shared"
    "kubernetes.io/role/elb"                                   = "1"
    "kubernetes.io/role/internal-elb"                          = "1"
  }
}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "eu-west-1a"

  tags = {
    Name                                                       = "novara-private-a"
    Type                                                       = "private"
    SubnetType                                                 = "Private"
    "kubernetes.io/cluster/cluster.dev.taskapp-james-greg.xyz" = "shared"
    "kubernetes.io/role/internal-elb"                          = "1"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.12.0/24"
  availability_zone = "eu-west-1b"

  tags = {
    Name                                                       = "novara-private-b"
    Type                                                       = "private"
    SubnetType                                                 = "Private"
    "kubernetes.io/cluster/cluster.dev.taskapp-james-greg.xyz" = "shared"
    "kubernetes.io/role/internal-elb"                          = "1"
  }
}

resource "aws_subnet" "private_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.13.0/24"
  availability_zone = "eu-west-1c"

  tags = {
    Name                                                       = "novara-private-c"
    Type                                                       = "private"
    SubnetType                                                 = "Private"
    "kubernetes.io/cluster/cluster.dev.taskapp-james-greg.xyz" = "shared"
    "kubernetes.io/role/internal-elb"                          = "1"
  }
}

resource "aws_eip" "nat_a" {
  domain = "vpc"

  tags = {
    Name = "novara-nat-eip-a"
  }
}

resource "aws_eip" "nat_b" {
  domain = "vpc"

  tags = {
    Name = "novara-nat-eip-b"
  }
}

resource "aws_eip" "nat_c" {
  domain = "vpc"

  tags = {
    Name = "novara-nat-eip-c"
  }
}

resource "aws_nat_gateway" "nat_a" {
  allocation_id = aws_eip.nat_a.id
  subnet_id     = aws_subnet.public_a.id

  tags = {
    Name = "novara-nat-a"
  }
}

resource "aws_nat_gateway" "nat_b" {
  allocation_id = aws_eip.nat_b.id
  subnet_id     = aws_subnet.public_b.id

  tags = {
    Name = "novara-nat-b"
  }
}

resource "aws_nat_gateway" "nat_c" {
  allocation_id = aws_eip.nat_c.id
  subnet_id     = aws_subnet.public_c.id

  tags = {
    Name = "novara-nat-c"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "novara-public-rt"
  }
}

resource "aws_route_table" "private_a" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_a.id
  }

  tags = {
    Name = "novara-private-rt-a"
  }
}

resource "aws_route_table" "private_b" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_b.id
  }

  tags = {
    Name = "novara-private-rt-b"
  }
}

resource "aws_route_table" "private_c" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_c.id
  }

  tags = {
    Name = "novara-private-rt-c"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_c" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_a.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private_b.id
}

resource "aws_route_table_association" "private_c" {
  subnet_id      = aws_subnet.private_c.id
  route_table_id = aws_route_table.private_c.id
}