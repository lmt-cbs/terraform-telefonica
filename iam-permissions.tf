# Definimos el Role IAM que permitira a la funcion Lambda acceder a servicios.

resource "aws_iam_role" "lambda_exec" {
  name = "tf-${terraform.workspace}-${var.nombre_role}-${random_id.nombre_role_rand.hex}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com",
        "Service": "codepipeline.amazonaws.com",
        "Service": "secretsmanager.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

tags =  {
  "tf:${terraform.workspace}" = "tf-${terraform.workspace}"
  }
}

# Generamos la politica (POLICIES) para que la lambda pueda interactuar con Dynamodb

resource "aws_iam_role_policy" "dynamodb-lambda-policy"{
  name = "tf-${terraform.workspace}-dynamodb-lambda-policy"
  role = "${aws_iam_role.lambda_exec.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:*"
      ],
      "Resource": "${aws_dynamodb_table.tf-mc-azure-table.arn}"
    }
  ]
}
EOF

}

# Generamos la politica (POLICIES) para que la lambda pueda interactuar con Secrets Manager

resource "aws_iam_role_policy" "secrets-manager-policy"{
  name = "tf-${terraform.workspace}-secrets-manager-policy"
  role = "${aws_iam_role.lambda_exec.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:*"
      ],
      "Resource": "${aws_secretsmanager_secret.tf-secret.arn}"
    }
  ]
}
EOF
}

# Generamos la politica (POLICIES) para que la lambda pueda interactuar con CodePipeline

resource "aws_iam_role_policy" "code-pipeline-policy"{
  name = "tf-${terraform.workspace}-code-pipeline-policy"
  role = "${aws_iam_role.lambda_exec.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    { 
      "Effect": "Allow",
      "Action": [
        "codepipeline:*",
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

# Generamos la politica (POLICIES) para que la lambda pueda interactuar con SNS

resource "aws_iam_role_policy" "sns-policy"{
  name = "tf-${terraform.workspace}-sns-policy"
  role = "${aws_iam_role.lambda_exec.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "sns:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

# Generamos la politica (POLICIES) para que la lambda pueda interactuar con STS

resource "aws_iam_role_policy" "sts-policy"{
  name = "tf-${terraform.workspace}-sts-policy"
  role = "${aws_iam_role.lambda_exec.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "sts:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

# Generamos la politica (POLICIES) para que la lambda pueda interactuar con EC2

resource "aws_iam_role_policy" "ec2-policy"{
  name = "tf-${terraform.workspace}-ec2-policy"
  role = "${aws_iam_role.lambda_exec.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

# Generamos la politica (POLICIES) para que la lambda pueda interactuar con s3

resource "aws_iam_role_policy" "s3-policy"{
  name = "tf-${terraform.workspace}-s3-policy"
  role = "${aws_iam_role.lambda_exec.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
