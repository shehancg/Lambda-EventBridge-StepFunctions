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

// Adding an inline policy to allow access to Secrets Manager
resource "aws_iam_role_policy" "secrets_manager_policy" {
  name   = "secrets_manager_policy"
  role   = aws_iam_role.lambda_exec.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = [
        "secretsmanager:GetSecretValue"
      ],
      Resource = "*"
    }]
  })
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

# IAM role for EventBridge to invoke Step Function
resource "aws_iam_role" "eventbridge_role" {
  name = "eventbridge-invoke-step-function-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "scheduler.amazonaws.com"
        }
      }
    ]
  })
}

# IAM policy to allow EventBridge to invoke Step Function
resource "aws_iam_role_policy" "eventbridge_invoke_step_function" {
  name = "eventbridge-invoke-step-function-policy"
  role = aws_iam_role.eventbridge_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "states:StartExecution"
        ]
        Resource = [
          aws_sfn_state_machine.state_machine.arn
        ]
      }
    ]
  })
}