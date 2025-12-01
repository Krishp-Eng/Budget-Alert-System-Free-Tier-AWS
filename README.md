<<<<<<< HEAD
# Budget-Alert-System-Free-Tier-AW
=======
# Budget-Alert-System-Free-Tier-AWS

**Simple AWS cost protection:**
1. Get email alerts when spending hits 80% of your budget
2. Get email + auto-stop EC2/RDS when spending hits 100%  
3. Sleep peacefully knowing you won't get surprise AWS bills

## **What You Get**

- **📧 Email alerts** at 80% of budget (early warning)
- **🚨 Email + auto-stop** at 100% of budget (protection)  
- **💸 Optional Slack** notifications
- **� Free tier friendly** - $0 monthly cost
- **⚡ 5-minute setup** with Terraform

## **What It Creates**

- AWS Budget ($50/month default)
- SNS topic for notifications  
- Email subscription (you confirm via email)
- Lambda function to stop EC2/RDS instances
- **Total AWS cost: $0** (within free tier)


### **Step 1: Setup**
```bash
# Install Terraform 
brew install terraform

# Configure AWS CLI (if needed)  
aws configure
```

### **Step 2: Configure**
```bash
# Copy config template
cp terraform.tfvars.example terraform.tfvars

# Edit with your email (REQUIRED)
nano terraform.tfvars
```

### **Step 3: Deploy**
```bash
# Deploy everything
terraform init
terraform apply

# Type 'yes' when prompted
# Check your email and confirm SNS subscription
```

**Success!!** ✅ You're safegaurded from surprise AWS bills.

## **Configuration Options**

Edit `terraform.tfvars`:

```hcl
notification_email = "your-email@example.com"  # REQUIRED
slack_webhook      = ""                        # Optional Slack
budget_limit       = 50                        # Monthly USD limit  
enable_automation  = true                      # Auto-stop resources?
aws_region        = "us-east-1"               # Free tier region
```

**Alert Thresholds:**
- **80%** = Email warning
- **100%** = Email + auto-stop EC2/RDS instances

## **Testing**

### **Test Email Alerts**  
1. After `terraform apply`, check your email for SNS confirmation
2. Click "Confirm subscription"  
3. ✅ You'll now get budget alerts

### **Test Budget Protection** (Optional)
```bash
# Temporarily lower budget to trigger alert
terraform apply -var="budget_limit=1"

# You should get an email within minutes
# Change it back: terraform apply -var="budget_limit=50"
```

## **Cleanup**

```bash
# Remove everything to stop all costs
terraform destroy

# Type 'yes' to confirm
# Everything is deleted, $0 ongoing cost
```

## **Troubleshooting for all Junior's :)**

**No email received?**
- Check spam folder
- Confirm email in terraform.tfvars is correct

**Want to change budget?**
```bash
terraform apply -var="budget_limit=100"
```

**Disable auto-stopping?**
```bash
terraform apply -var="enable_automation=false"
```

## **How It Works**

```
AWS Spending → Budget Alert → SNS → Email + Lambda → Stop EC2/RDS
```