# Platform Engineer Coding Test – Monitoring & Auto-Remediation

This repository contains my solution for the Platform Engineer Coding Test.
The objective is to detect performance issues in a web application, automatically remediate them, and notify stakeholders using AWS and Sumo Logic.

---

## 📌 Overview

This solution implements:

- Log monitoring using **Sumo Logic**
- Alerting based on response time thresholds
- Automated remediation using **AWS Lambda**
- Infrastructure provisioning via **Terraform**
- Notifications through **Amazon SNS**

When the `/api/data` endpoint exceeds acceptable response time thresholds, an automated workflow restarts a specified EC2 instance and sends a notification.

---

## 🏗 Architecture Flow

1. Application logs are ingested into **Sumo Logic**
2. A Sumo Logic query identifies slow `/api/data` requests
3. An alert triggers when thresholds are exceeded
4. The alert invokes an **AWS Lambda** function via webhook
5. Lambda:
   - Restarts the EC2 instance
   - Logs the remediation action
   - Publishes a message to an SNS topic

---

## 📂 Repository Structure

```
.
├── sumo_logic_query.txt        # Sumo Logic query for detecting slow API responses
├── terraform/
│   ├── vpc.tf                  # VPC and networking resources
│   ├── ec2.tf                  # EC2 instance definition
│   ├── lambda.tf               # Lambda function and IAM role
│   ├── sns.tf                  # SNS topic and subscriptions
│   ├── variables.tf            # Terraform input variables
│   ├── outputs.tf              # Terraform outputs
│   ├── terraform.tfvars        # Variable values
│   └── terraform.tfstate       # Terraform state (demo only)
└── README.md
```

---



## ⚙️Part 1: AWS Lambda Function

The Lambda function is triggered by the Sumo Logic alert and performs:

- Restarting a specified EC2 instance
- Logging the action to CloudWatch Logs
- Sending a notification to an SNS topic

### AWS Services Used
- AWS Lambda
- Amazon EC2
- Amazon SNS
- AWS IAM (least-privilege permissions)

---

## 🧱 Part 2: Infrastructure as Code (Terraform)

Terraform provisions:

- VPC and networking components
- EC2 instance
- Lambda function and IAM roles
- SNS topic

### Deployment Steps

```bash
terraform init
terraform plan
terraform apply
```

## 🔍 Part 3: Sumo Logic Query & Alert

### Step 1: Create a Sumo Logic Account

1. Create an account at: https://www.sumologic.com/
2. Switch to the **New UI** after logging in

---

### Step 2: Create Webhook Connection (AWS Lambda)

1. Navigate to:
   **Manage Data → Connections → Create Connection**
2. Choose **AWS Lambda**
3. Paste the following details:
   - **Lambda Function URL**
   - **AWS Access Key**
   - **AWS Secret Access Key**

4. Retrieve the secret access key by running:

```bash
terraform output sumoLogicAccessKeySecret
```

5. Test the alert and payload
6. Save the connection

✅ Connection is now created

---

### Step 3: Create Log Search & Alert

1. Go to **Logs → Log Search**
2. Paste the query from:

```
sumo_logic_query.txt
```

---

3. Save the search
4. Click **Schedule This Search**
5. Choose:
   - **Schedule Type**: Alert
   - **Connection Type**: Webhook
   - **Webhook Connection**: Select the connection created earlier
6. Save the alert

---

## 🔐 Security Considerations

- IAM roles follow the **principle of least privilege**
- Lambda permissions are scoped to:
  - Restarting the specific EC2 instance
  - Publishing to the SNS topic
  - Writing logs to CloudWatch

---

## 📝 Assumptions & Notes

- Sumo Logic log ingestion is pre-configured
- EC2 instance ID is provided via environment variables
- Error handling prioritizes operational visibility

---

## 📎 Screen & Audio Recordings

Screen and audio recordings demonstrating implementation, deployment, and testing are provided separately per submission guidelines.


**AWS Lambda function - Implementation/Testing/Deployment**
https://calstatela.zoom.us/rec/share/9gvqIQKrrjJNhf6YyfFJqPF59PSE_mypFco8UUmKTE5MNh_0_EYWHnUDXUeQ6EyC.Ys6W8P3BsjdI1Zzq 
Passcode: DeT749.x


**SumoLogic SearchQuery and Alert**
https://calstatela.zoom.us/rec/share/NFedGwtX85e4BXdAJYoGtzS1oRXzg7B64NM9tE2ZDUIuP5hc5nV8tFZK4QO6M107.o1pIJDZX3F8R5exH 
Passcode: v8=0&&f+


**Terraform- Infrastruction implementation and testing as a whole**
https://calstatela.zoom.us/rec/share/eCrsx0Ev5g-Kd9neHyGuivxznQECR7zc80eAbQ28r4wDI3NzoKE3dB5PmwP-DaVG.gzHlX1ZJcFgV_cSY 
Passcode: ?6+sVbCz

---

## ✅ Conclusion

This project demonstrates an automated monitoring and remediation pipeline using cloud-native tooling, emphasizing reliability, automation, and infrastructure as code.
