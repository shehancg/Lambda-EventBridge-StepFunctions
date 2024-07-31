// Lambda function to fetch access token
resource "aws_lambda_function" "fetch_token" {
  function_name    = "fetch_access_token"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "lambda_token_gen.handler"
  runtime          = "python3.11"
  filename         = "${path.module}./lambda_token_gen/function_one.zip"
  source_code_hash = filebase64sha256("${path.module}./lambda_token_gen/function_one.zip")

# Add environment variables
  environment {
    variables = {
      SECRET_ARN     = var.secret_arn
      AUTH_URL       = var.auth_url
      COMPANY_CODE   = var.company_code
      SECRET_PREFIX  = var.secret_prefix
    }
  }
}


// Lambda function to sync data
resource "aws_lambda_function" "sync_data" {
  function_name    = "sync_data"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "lambda_api_call.handler"
  runtime          = "python3.11"
  filename         = "${path.module}./lambda_api_call/function_two.zip"
  source_code_hash = filebase64sha256("${path.module}./lambda_api_call/function_two.zip")

  environment {
    variables = {
      API_KEY = var.api_key
      CITY    = var.city
    }
  }
}