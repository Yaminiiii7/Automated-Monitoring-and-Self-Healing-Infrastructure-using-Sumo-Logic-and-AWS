resource "aws_sns_topic" "topic" {
  name = "sumoLogic-topic"
}


resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.topic.arn
  protocol  = "email"
  endpoint  = var.alert_email
}