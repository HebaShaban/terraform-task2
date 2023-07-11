#create routing table
resource "aws_route_table" "pub-route-table" {
  vpc_id = aws_vpc.example.id

  route {
    cidr_block = var.cidrs["route-table"]
    gateway_id = aws_internet_gateway.IGW-vpc.id
  }
   tags = {
    Name = "pub-route-table"
  }
}
#association the route table with the public subnet
resource "aws_route_table_association" "pub-route-table-association" {
  subnet_id      = aws_subnet.subnets["public"].id
  route_table_id = aws_route_table.pub-route-table.id
}
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.example.id
  tags = { Name = "private-route-table" }
}

resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.private-route-table.id
  destination_cidr_block = var.cidrs["route-table"]
  nat_gateway_id         = aws_nat_gateway.NAT-IGW.id
}

resource "aws_route_table_association" "private-route-table-association" {
  subnet_id      = aws_subnet.subnets["private"].id
  route_table_id = aws_route_table.private-route-table.id
}