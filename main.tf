resource "aws_vpc" "dev-test" {
  cidr_block = "10.10.10.0/26"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    "Name" = "webapp-1"
  }
}
resource "aws_subnet" "private" {
  count             = length(var.subnet_cidr_private)
  vpc_id            = aws_vpc.dev-test.id
  cidr_block        = var.subnet_cidr_private[count.index]
  availability_zone = var.availability_zone[count.index]
  tags = {
    "Name" = "webapp-1-private"
  }
}
resource "aws_route_table" "dev-test-rt" {
  vpc_id = aws_vpc.dev-test.id
  tags = {
    "Name" = "webapp-1-route-table"
  }
}
resource "aws_route_table_association" "private" {
  count          = length(var.subnet_cidr_private)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.dev-test-rt.id
}
resource "aws_internet_gateway" "dev-test-igw" {
  vpc_id = aws_vpc.dev-test.id
  tags = {
    "Name" = "webapp-1-gateway"
  }
}
resource "aws_route" "internet-route" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.dev-test-rt.id
  gateway_id             = aws_internet_gateway.dev-test-igw.id
}