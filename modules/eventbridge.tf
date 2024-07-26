// creating the eventbridge schedules
resource "aws_scheduler_schedule" "my_schedule" {
  name        = "my-schedule"
  description = "Fires every day"
  group_name  = "default"
  flexible_time_window {
    mode = "OFF"
  }
  schedule_expression = "rate(1 day)"
  target {
    arn      = aws_sfn_state_machine.state_machine.arn
    role_arn = aws_iam_role.eventbridge_role.arn
  }
}

// Permission for EventBridge to invoke the Lambda function
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.fetch_token.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_scheduler_schedule.my_schedule.arn
}
