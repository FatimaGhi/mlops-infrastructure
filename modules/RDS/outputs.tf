output "endpoint" {
  value = aws_db_instance.mlflow.address
}

output "port" {
  value = aws_db_instance.mlflow.port
}

output "db_name" {
  value = aws_db_instance.mlflow.db_name
}
output "secret_arn" {
  value = aws_secretsmanager_secret.mlflow_db.arn
}