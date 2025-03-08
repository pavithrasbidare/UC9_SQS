data "archive_file" "insert_data_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_functions/insert_data"
  output_path = "${path.module}/lambda_functions/insert_data.zip"
}


resource "aws_lambda_function" "insert_data_lambda" {
  function_name = var.function_name
  role          = var.role_arn
  handler       = "index.lambda_handler"
  runtime       = "python3.8"
  filename      = data.archive_file.insert_data_zip.output_path
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      function_name,
      role,
      handler,
      runtime,
      filename,
    ]
  }
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_dynamodb_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
