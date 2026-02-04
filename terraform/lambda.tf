resource "aws_iam_role" "lambda_role" {
  name = "lambda-ec2-restart-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement= [
          {
            Sid: "RebootSpecificInstance",
            Effect: "Allow",
            Action: "ec2:RebootInstances",
            Resource: "arn:aws:ec2:${var.region}:${var.aws_account_no}:instance/${aws_instance.ec2.id}"
          },
          {
            Sid: "PublishToSpecificTopic",
            Effect: "Allow",
            Action: "sns:Publish",
            Resource: "arn:aws:sns:${var.region}:${var.aws_account_no}:${aws_sns_topic.topic.name}"
          },
          {
            Sid    = "AllowBasicLogging"
            Effect = "Allow"
            Action = [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ]
            Resource = "*"
          }
    ]    
  })
}



# Package the Lambda function code
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/../lambda_function/lambda_function.py"
  output_path = "${path.module}/lambda/lambdafunction.zip"
}

resource "aws_lambda_function" "lambda" {
  function_name = "SumoLogicLambdafunction"
  runtime       = "python3.14"
  role          = aws_iam_role.lambda_role.arn 

  handler       = "lambda_function.lambda_handler"
  filename      = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      EC2_INSTANCE_ID = aws_instance.ec2.id
      SNS_TOPIC_ARN   = aws_sns_topic.topic.arn
    }
  }
  tags = {
    Name = "main"
  }
}

resource "aws_lambda_function_url" "func_URL" {
  function_name      = aws_lambda_function.lambda.function_name
  authorization_type = "NONE"
}

resource "aws_lambda_permission" "invoke_function_url" {
  statement_id  = "AllowInvokeURL"
  action        = "lambda:InvokeFunctionUrl"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "*"
  function_url_auth_type = "NONE"
}

resource "aws_lambda_permission" "invoke_function" {
  statement_id  = "AllowPublicInvokefunction"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "*"
}

resource "aws_iam_user" "user" {
  name = "SumoLogicUser"

  tags = {
    Name = "main"
  }
}

resource "aws_iam_access_key" "sumouseraccesskey" {
  user = aws_iam_user.user.name
}

data "aws_iam_policy_document" "policy" {
  statement {
    effect    = "Allow"
    actions   = ["lambda:InvokeFunctionUrl"]
    resources = ["arn:aws:lambda:*:*:function:*"]
  }
}


resource "aws_iam_user_policy" "lb_ro" {
  name   = "functionURLaccess"
  user   = aws_iam_user.user.name
  policy = data.aws_iam_policy_document.policy.json
}



