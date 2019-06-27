resource "aws_iam_role_policy" "cloudwatch-lambda-logs"{
  name = "tf-${terraform.workspace}-${var.lambda_policy_cloudwatch}-${random_id.lambda_policy_cloudwatch_rand.hex}"
  role = "${aws_iam_role.lambda_exec.id}"
  policy = "${data.aws_iam_policy_document.api-gateway-logs.json}"
}

data "aws_iam_policy_document" "api-gateway-logs" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }
}

resource "aws_cloudwatch_log_group" "cloudwatch_logs" {
  name = "tf-${terraform.workspace}-${var.cloudwatch_log_group}-${random_id.cloudwatch_log_group_rand.hex}"
  tags =  {
    "tf:${terraform.workspace}" = "tf-${terraform.workspace}"
  }
}
