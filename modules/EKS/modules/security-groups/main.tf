
# EKS CLUSTER SG


resource "aws_security_group" "eks_cluster_sg" {
  name   = "${var.cluster_name}-cluster-sg"
  vpc_id = var.vpc_id

  ingress {
    description = "HTTPS"

    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-cluster-sg"
  }
}


# NODE GROUP SG


resource "aws_security_group" "node_sg" {
  name   = "${var.cluster_name}-node-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"

    self = true
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-node-sg"
  }
}