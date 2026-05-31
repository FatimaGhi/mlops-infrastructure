resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "nat-eip"
  }
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = var.public_subnet_id

   depends_on = [
    var.igw_dependency
  ]

  tags = {
    Name = var.nat_name
  }
}