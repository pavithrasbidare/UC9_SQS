data "archive_file" "insert_data_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_functions/insert_data"
  output_path = "${path.module}/lambda_functions/insert_data.zip"
}

resource "aws_lambda_function" "insert_data_lambda" {
  function_name = var.function_name
  role          = "arn:aws:iam::302263075199:role/lambda-execution-role"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"
  filename      = data.archive_file.insert_data_zip.output_path
}

output "lambda_arn" {
  value = aws_lambda_function.insert_data_lambda.arn
}
