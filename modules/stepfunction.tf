// Step Functions state machine definition
resource "aws_sfn_state_machine" "state_machine" {
  name     = "MyStateMachine"
  role_arn = aws_iam_role.step_functions_exec.arn

  // State machine definition in Amazon States Language (ASL)
  definition = jsonencode({
    Comment = "A description of my state machine",
    StartAt = "FetchAccessToken",
    States = {
      FetchAccessToken = {
        Type = "Task",
        Resource = "${aws_lambda_alias.fetch_token_alias.arn}",
        Next = "SyncData",
        Catch = [{
          ErrorEquals = ["States.ALL"],
          ResultPath = "$.error-info",
          Next = "Failure"
        }]
      },
      SyncData = {
        Type = "Task",
        Resource = "${aws_lambda_alias.sync_data_alias.arn}",
        End = true,
        Catch = [{
          ErrorEquals = ["States.ALL"],
          ResultPath = "$.error-info",
          Next = "Failure"
        }]
      },
      Failure = {
        Type = "Fail",
        Error = "States.ALL",
        Cause = "An error occurred"
      }
    }
  })
}
