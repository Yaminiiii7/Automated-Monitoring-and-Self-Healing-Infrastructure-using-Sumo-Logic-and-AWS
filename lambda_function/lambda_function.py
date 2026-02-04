import boto3
import logging
import os
import json

logger = logging.getLogger()
logger.setLevel(logging.INFO)
ec2 = boto3.client("ec2")
sns = boto3.client("sns")

EC2_INSTANCE_ID = os.environ["EC2_INSTANCE_ID"]
SNS_TOPIC_ARN = os.environ["SNS_TOPIC_ARN"]

def lambda_handler(event, context):
    logger.info("Triggered by Sumo alert. Event: %s", json.dumps(event))

    # Restart EC2 instance
    ec2.reboot_instances(InstanceIds=[EC2_INSTANCE_ID])
    logger.info("Reboot initiated for instance %s", EC2_INSTANCE_ID)

    # Notify via SNS
    message = f"Auto-remediation: rebooted EC2 {EC2_INSTANCE_ID} due to slow /api/data alert."
    sns.publish(
        TopicArn=SNS_TOPIC_ARN,
        Subject="EC2 Restart Triggered",
        Message=message
    )
    logger.info("SNS notification sent to %s", SNS_TOPIC_ARN)

    return {"statusCode": 200, "body": "EC2 reboot initiated; SNS sent"}
