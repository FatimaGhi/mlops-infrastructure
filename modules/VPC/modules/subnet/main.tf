
# PUBLIC SUBNETS

resource "aws_subnet" "public" {
  for_each = var.public_subnets

  vpc_id                  = var.vpc_id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = {
    Name                                  = each.value.name
    "kubernetes.io/role/elb"              = "1"
    "kubernetes.io/cluster/mlops-cluster" = "shared"
  }
}


# PRIVATE SUBNETS


resource "aws_subnet" "private" {
  for_each = var.private_subnets

  vpc_id            = var.vpc_id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name                                  = each.value.name
    "kubernetes.io/role/internal-elb"     = "1"
    "kubernetes.io/cluster/mlops-cluster" = "shared"
  }
}