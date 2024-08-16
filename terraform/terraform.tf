provider "aws" {
  region = "us-east-1"
}

# CloudFront para distribuir o conteúdo
resource "aws_cloudfront_distribution" "cdn" {
  # Configuração do CloudFront
}

# API Gateway
resource "aws_api_gateway_rest_api" "api_gateway" {
  name = "ecommerce_api_gateway"
}

# Load Balancer
resource "aws_lb" "lb" {
  name               = "ecommerce_lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = aws_subnet.public[*].id
}

# Microserviços com AWS Lambda
resource "aws_lambda_function" "auth_service" {
  function_name = "auth_service"
  runtime       = "python3.8"
  handler       = "lambda_function.lambda_handler"
  role          = aws_iam_role.lambda_exec_role.arn
  # Código e configuração da Lambda
}

resource "aws_lambda_function" "catalog_service" {
  function_name = "catalog_service"
  runtime       = "python3.8"
  handler       = "lambda_function.lambda_handler"
  role          = aws_iam_role.lambda_exec_role.arn
  # Código e configuração da Lambda
}

resource "aws_lambda_function" "order_service" {
  function_name = "order_service"
  runtime       = "python3.8"
  handler       = "lambda_function.lambda_handler"
  role          = aws_iam_role.lambda_exec_role.arn
  # Código e configuração da Lambda
}

# Banco de Dados RDS
resource "aws_db_instance" "database" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  name                 = "ecommerce_db"
  username             = "admin"
  password             = "password"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
}

# S3 Bucket para armazenamento de imagens
resource "aws_s3_bucket" "images_storage" {
  bucket = "ecommerce-images-storage"
  acl    = "private"
}

# Fila SQS
resource "aws_sqs_queue" "order_queue" {
  name = "ecommerce_order_queue"
}

# Regras IAM para as Lambdas
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_exec_role_policy" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Monitoramento com CloudWatch
resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/aws/lambda/ecommerce"
  retention_in_days = 14
}