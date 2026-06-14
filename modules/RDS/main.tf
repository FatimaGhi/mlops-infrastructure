resource "random_password" "mlflow_db" {
  length  = 16
  special = false
}

resource "aws_secretsmanager_secret" "mlflow_db" {
  name                    = "mlflow-db-credentials"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "mlflow_db" {
  secret_id = aws_secretsmanager_secret.mlflow_db.id
  secret_string = jsonencode({
    username = var.db_username
    password = random_password.mlflow_db.result
    host     = aws_db_instance.mlflow.address
    port     = 5432
    dbname   = "mlflow"
  })
}

resource "aws_db_subnet_group" "mlflow" {
  name       = "mlflow-db-subnet"
  subnet_ids = var.private_subnet_ids
}

resource "aws_security_group" "rds" {
  name   = "mlflow-rds-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.eks_node_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mlflow-rds-sg"
  }
}

resource "aws_db_instance" "mlflow" {
  identifier     = "mlflow-db"
  engine         = "postgres"
  engine_version = "15"
  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = "mlflow"
  username = var.db_username
  password = random_password.mlflow_db.result

  db_subnet_group_name   = aws_db_subnet_group.mlflow.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  skip_final_snapshot = true
  publicly_accessible = false

  tags = {
    Name    = "mlflow-postgres"
    Project = "mlops"
  }
}