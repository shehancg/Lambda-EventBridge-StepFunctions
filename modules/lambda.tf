// Lambda function to fetch access token
resource "aws_lambda_function" "fetch_token" {
  function_name    = "fetch_access_token"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "lambda_token_gen.handler"
  runtime          = "python3.8"
  filename         = "${path.module}./lambda_token_gen/function_one.zip"
  source_code_hash = filebase64sha256("${path.module}./lambda_token_gen/function_one.zip")
}

// Lambda function to sync data
resource "aws_lambda_function" "sync_data" {
  function_name    = "sync_data"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "lambda_api_call.handler"
  runtime          = "python3.8"
  filename         = "${path.module}./lambda_api_call/function_two.zip"
  source_code_hash = filebase64sha256("${path.module}./lambda_api_call/function_two.zip")
}
