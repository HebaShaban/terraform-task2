#create vpc
resource "aws_vpc" "example" {
    cidr_block = var.cidrs["vpc"]
    tags = {
        "Name"= "test"
        project= "sprints"
    }
}

#create Internet gateway
resource "aws_internet_gateway" "IGW-vpc" {
  vpc_id = aws_vpc.example.id
    tags = {
    Name = "IGW-vpc"
  }
}

resource "aws_eip" "NAT" {
  vpc = true
  depends_on = [aws_internet_gateway.IGW-vpc]
}

resource "aws_nat_gateway" "NAT-IGW" {
  allocation_id = aws_eip.NAT.id
  subnet_id     = aws_subnet.subnets["public"].id
  depends_on    = [aws_internet_gateway.IGW-vpc]
  tags = { Name = "NAT-IGW" }
}

resource "aws_subnet" "subnets" {
  for_each = var.subnet_cidrs
  vpc_id     = aws_vpc.example.id
  cidr_block = each.value
  tags = {Name = "${each.key}-subnet"}
}