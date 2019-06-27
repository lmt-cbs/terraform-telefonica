resource "aws_cloudwatch_event_rule" "schedule_rule" {
  name = "tf-${terraform.workspace}-event-rule"
  schedule_expression = "rate(2 minutes)"

tags =  {
    "tf:${terraform.workspace}" = "tf-${terraform.workspace}"
  }
}

# permisos a la cuernta para poner eventos en el bus

resource "aws_cloudwatch_event_permission" "DevAccountAccess" {
  principal    = "*"
  statement_id = "DevAccountAccess"
}
