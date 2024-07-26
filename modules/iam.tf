// IAM role for Lambda execution
resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

// Attach the basic execution policy to the Lambda IAM role
resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

// IAM role for Step Functions execution
resource "aws_iam_role" "step_functions_exec" {
  name = "step_functions_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "states.amazonaws.com"
      }
    }]
  })
}

// Policy for Step Functions to invoke Lambda functions
resource "aws_iam_role_policy" "step_functions_policy" {
  role = aws_iam_role.step_functions_exec.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "lambda:InvokeFunction"
      ],
      Resource = "*"
    }]
  })
}

// Creating IAM role for eventbridge role
resource "aws_iam_role" "eventbridge_role" {
  name = "eventbridge_lambda_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "scheduler.amazonaws.com"
      }
    }]
  })
}

// Applying policy for above IAM role
resource "aws_iam_role_policy_attachment" "eventbridge_lambda_policy" {
  role       = aws_iam_role.eventbridge_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaRole"
}