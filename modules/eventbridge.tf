// creating the eventbridge schedules
resource "aws_scheduler_schedule" "my_schedule" {
  name        = "my-schedule"
  description = "Fires every 2 minute"
  group_name  = "default"
  flexible_time_window {
    mode = "OFF"
  }
  schedule_expression = "rate(2 minutes)"
  target {
    arn      = aws_sfn_state_machine.state_machine.arn
    role_arn = aws_iam_role.eventbridge_role.arn
  }
}