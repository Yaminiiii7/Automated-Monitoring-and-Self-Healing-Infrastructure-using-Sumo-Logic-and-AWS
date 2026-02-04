output "ec2_instance_id" {
  value = aws_instance.ec2.id
}

output "ec2_public_ip" {
  value = aws_instance.ec2.public_ip
}

output "lambda_function_url" {
  value = aws_lambda_function_url.func_URL.function_url
}

output "sumoLogicAccessKeyID" {
  value = aws_iam_access_key.sumouseraccesskey.id
}

output "sumoLogicAccessKeySecret" {
  value = aws_iam_access_key.sumouseraccesskey.secret
  sensitive = true
}