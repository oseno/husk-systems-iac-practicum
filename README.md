# Husk Power Systems - Infrastructure as Code (IaC) Practicum

**Author:** Joel Maison, Oseno Ewaose-Joseph, Mark Iraguha  
**Institution:** Carnegie Mellon University Africa  
**Program:** MSIT  
**Duration:** September 2025 - December 2025
**Supervisor:** Husk Power Systems Technical Team

---

## Table of Contents
- [Project Overview](#project-overview)
- [Architecture](#architecture)
- [Deployed Resources](#deployed-resources)
- [Prerequisites](#prerequisites)
- [Deployment Guide](#deployment-guide)
- [Module Documentation](#module-documentation)
- [Troubleshooting](#troubleshooting)
- [Security Considerations](#security-considerations)
- [Cost Optimization](#cost-optimization)
- [Future Enhancements](#future-enhancements)

---

## Project Overview

This project implements Infrastructure as Code (IaC) for Husk Power Systems' data analytics infrastructure using OpenTofu (Terraform). The infrastructure supports real-time data processing, analytics, and business intelligence for renewable energy operations across distributed mini-grid installations.

### Objectives
- Deploy scalable data analytics infrastructure on Azure
- Implement security best practices and compliance measures
- Enable real-time processing of IoT telemetry data
- Provide infrastructure for business intelligence and reporting

### Technology Stack
- **IaC Tool:** OpenTofu (Terraform-compatible)
- **Cloud Provider:** Microsoft Azure
- **Region:** South India
- **Version Control:** Git/GitHub

---

## Architecture

### High-Level Architecture
```
┌─────────────────────────────────────────────────────────────┐
│                    Azure Resource Group                      │
│                    (rg-prod-in-cmu)                          │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────────┐      ┌──────────────────┐            │
│  │  Stream Analytics│      │   Databricks     │            │
│  │      Job         │──────│   Workspace      │            │
│  │                  │      │                  │            │
│  └──────────────────┘      └──────────────────┘            │
│           │                         │                        │
│           │                         │                        │
│           ▼                         ▼                        │
│  ┌──────────────────────────────────────────┐               │
│  │         Synapse Analytics                │               │
│  │  ┌────────────┐    ┌──────────────┐     │               │
│  │  │  SQL Pool  │    │  Spark Pool  │     │               │
│  │  └────────────┘    └──────────────┘     │               │
│  └──────────────────────────────────────────┘               │
│           │                                                  │
│           ▼                                                  │
│  ┌──────────────────┐      ┌──────────────────┐            │
│  │  Storage Account │      │    Key Vault     │            │
│  │  (Data Lake Gen2)│      │   (Secrets)      │            │
│  └──────────────────┘      └──────────────────┘            │
│                                                               │
│  ┌──────────────────┐      ┌──────────────────┐            │
│  │  Security (NSG)  │      │ Managed Identity │            │
│  └──────────────────┘      └──────────────────┘            │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

### Data Flow
1. IoT devices send telemetry data → Event Hub/IoT Hub (planned)
2. Stream Analytics processes real-time data
3. Processed data flows to Synapse Analytics
4. Databricks performs advanced analytics
5. Results stored in Data Lake for reporting

---

## Deployed Resources

### Current Production Resources

| Resource Type | Name | Purpose | Status |
|--------------|------|---------|--------|
| Resource Group | rg-prod-in-cmu | Container for all resources | ✅ Deployed |
| Stream Analytics Job | dev-infracore-stream | Real-time data processing | ✅ Deployed |
| Databricks Workspace | dev-synapse-databricks | Advanced analytics | ✅ Deployed |
| Synapse Workspace | dev-synapse-synapse | Data warehousing | ✅ Deployed |
| SQL Pool | dev_synapse_synapse_sqlpool | Dedicated SQL analytics | ✅ Deployed |
| Spark Pool | desparkpool | Distributed computing | ✅ Deployed |
| Storage Account | devsynapsesa* | Data Lake Gen2 | ✅ Deployed |
| Key Vault | synapse-kv-af793e90 | Secrets management | ✅ Deployed |
| Network Security Group | nsg-dev-southindia | Network security | ✅ Deployed |
| Managed Identity | id-dev-southindia | Secure authentication | ✅ Deployed |
| Log Analytics | la-dev-cmu | Monitoring and logging | ✅ Deployed |
| Application Insights | ai-dev-cmu | Application monitoring | ✅ Deployed |

---

## Prerequisites

### Required Tools
- OpenTofu v1.6+ or Terraform v1.5+
- Azure CLI v2.50+
- Git v2.30+
- Text editor (VS Code recommended)

### Azure Requirements
- Active Azure subscription
- Contributor or Owner role on subscription
- Registered resource providers:
  - Microsoft.Synapse
  - Microsoft.Databricks
  - Microsoft.StreamAnalytics
  - Microsoft.Storage
  - Microsoft.KeyVault
  - Microsoft.Network
  - Microsoft.ManagedIdentity

### Access Requirements
- Azure Active Directory account
- SSH access to development machine
- GitHub repository access

---

## Deployment Guide

### Initial Setup

1. **Clone the Repository**
```bash
git clone https://github.com/oseno/husk-systems-iac-practicum.git
cd husk-systems-iac-practicum
```

2. **Checkout the Deployment Branch**
```bash
git checkout feature/security-hardening
```

3. **Configure Azure Authentication**
```bash
az login
az account set --subscription "998c656f-d49e-4995-b689-3108f8baf8b5"
```

4. **Create terraform.tfvars**
Create a file named `terraform.tfvars` in the root directory:
```hcl
# Azure Configuration
subscription_id     = "998c656f-d49e-4995-b689-3108f8baf8b5"
resource_group_name = "rg-prod-in-cmu"
location            = "southindia"

# SQL Admin Configuration
sql_administrator_login = "sqladmin"
key_vault_name         = "synapse-kv-af793e90"

# RBAC Configuration (optional)
rbac_readers      = []
rbac_contributors = []

# Environment
environment    = "dev"
project_name   = "infracore"
```

5. **Initialize OpenTofu**
```bash
tofu init
```

### Deploying Resources

**Note:** Storage Account, Synapse Workspace, and Databricks are already deployed. Only deploy new resources.

1. **Review the Deployment Plan**
```bash
tofu plan
```

Expected output:
```
Plan: 3 to add, 0 to change, 0 to destroy
```

2. **Apply the Configuration**
```bash
tofu apply
```

Type `yes` when prompted.

3. **Verify Deployment**
```bash
# Check outputs
tofu output

# Verify in Azure Portal
az resource list --resource-group rg-prod-in-cmu --output table
```

### Post-Deployment Configuration

1. **Configure Stream Analytics Inputs/Outputs**
   - Add Event Hub or IoT Hub as input source
   - Configure Synapse SQL Pool as output destination
   - Update transformation query as needed

2. **Configure Databricks Workspace**
   - Create clusters for data processing
   - Import notebooks and workflows
   - Configure library dependencies

3. **Set up Monitoring**
   - Configure alerts in Application Insights
   - Set up Log Analytics queries
   - Create Azure Monitor dashboards

---

## Module Documentation

### Security Module (`modules/security`)

**Purpose:** Implements network security and identity management

**Resources:**
- Network Security Group with rules for HTTPS and Azure services
- User-assigned Managed Identity for secure service authentication

**Usage:**
```hcl
module "security" {
  source = "./modules/security"

  resource_group_name = "rg-prod-in-cmu"
  location            = "southindia"
  environment         = "dev"
  subscription_id     = var.subscription_id

  rbac_readers      = ["user-id-1", "user-id-2"]
  rbac_contributors = ["user-id-3"]
}
```

**Security Rules:**
- Allow HTTPS (port 443) inbound
- Allow Azure services communication
- Deny all other inbound traffic by default

### Stream Analytics Module (`modules/stream_analytics`)

**Purpose:** Real-time data stream processing

**Configuration:**
- Streaming Units: 3 (adjustable based on load)
- Compatibility Level: 1.2
- Data Locale: en-US
- Event ordering: 50-second tolerance

**Transformation Query:**
```sql
SELECT
    *
INTO
    [output]
FROM
    [input]
```

**Note:** Update the transformation query based on actual business requirements.

**Scaling Recommendations:**
- Start with 3 streaming units
- Monitor watermark delay and CPU utilization
- Scale up if processing lag exceeds 5 minutes
- Scale down during off-peak hours to reduce costs

---

## Troubleshooting

### Common Issues and Solutions

#### Issue 1: Provider Registration Error
**Error:** `MissingSubscriptionRegistration: The subscription is not registered to use namespace 'Microsoft.StreamAnalytics'`

**Solution:**
```bash
az provider register --namespace Microsoft.StreamAnalytics
az provider show --namespace Microsoft.StreamAnalytics --query "registrationState"
```

#### Issue 2: Backend Initialization Fails
**Error:** `Error retrieving keys for Storage Account`

**Solution:**
- Verify you have "Storage Blob Data Contributor" role
- Refresh Azure credentials:
```bash
az login
az account show
```

#### Issue 3: Resource Already Exists
**Error:** `A resource with the ID "/subscriptions/.../resourceGroups/..." already exists`

**Solution:**
- Import existing resource:
```bash
tofu import module.resource_name.resource_type /subscriptions/.../resourceGroups/...
```
- Or comment out the duplicate resource in `main.tf`

#### Issue 4: Terraform State Lock
**Error:** `Error locking state: Error acquiring the state lock`

**Solution:**
```bash
# Force unlock (use with caution)
tofu force-unlock <LOCK_ID>
```

#### Issue 5: Invalid Node Count with Auto-Scaling
**Error:** `only one of auto_scale,node_count can be specified`

**Solution:**
Make node_count conditional in Synapse Spark Pool:
```hcl
node_count = var.spark_pool_auto_scale_enabled ? null : var.spark_pool_node_count
```

### Debugging Commands
```bash
# Check OpenTofu version
tofu version

# Validate configuration
tofu validate

# Show detailed plan
tofu plan -out=plan.out

# Show current state
tofu show

# List all resources in state
tofu state list

# Check specific resource
tofu state show module.stream_analytics.azurerm_stream_analytics_job.this
```

### Azure Portal Verification

1. Navigate to Azure Portal: https://portal.azure.com
2. Go to Resource Groups → rg-prod-in-cmu
3. Verify all resources are listed and in "Succeeded" state
4. Check Activity Log for any failures or warnings

---

## Security Considerations

### Network Security

**Implemented:**
- Network Security Group with restrictive inbound rules
- HTTPS-only communication (port 443)
- Azure service-to-service communication allowed
- Default deny for all other traffic

**Recommendations:**
- Implement private endpoints for services
- Enable Azure Firewall for additional protection
- Configure VNet integration for Databricks
- Implement Network Watcher for traffic analysis

### Identity and Access Management

**Implemented:**
- Managed Identity for service-to-service authentication
- Azure AD authentication for user access
- Role-Based Access Control (RBAC)

**Current Roles:**
- Owner: Full access to all resources
- Contributor: Manage resources but not access
- Reader: View-only access
- Storage Blob Data Contributor: Read/write blob data

**Recommendations:**
- Implement Privileged Identity Management (PIM)
- Enable Multi-Factor Authentication (MFA)
- Regular access reviews
- Principle of least privilege

### Data Protection

**Implemented:**
- TLS 1.2 minimum for all connections
- Encryption at rest (Azure-managed keys)
- Key Vault for secrets management
- SQL authentication via Key Vault secrets

**Recommendations:**
- Implement customer-managed encryption keys
- Enable soft delete on Key Vault
- Configure backup and retention policies
- Implement data classification and tagging

### Compliance

**Considerations:**
- Data residency: South India region
- Audit logging via Log Analytics
- Activity logs for all resource changes
- Compliance with data protection regulations

---

## Cost Optimization

### Current Cost Drivers

| Resource | Estimated Monthly Cost (USD) | Optimization Opportunities |
|----------|------------------------------|---------------------------|
| Synapse SQL Pool (DW100c) | $1,200 - $1,500 | Pause when not in use |
| Synapse Spark Pool | $200 - $400 | Auto-pause after 15 min idle |
| Stream Analytics (3 SU) | $245 | Scale down to 1 SU if possible |
| Databricks Workspace | Variable | Use job clusters, not interactive |
| Storage Account (LRS) | $20 - $50 | Archive old data to cool tier |

### Cost Optimization Strategies

1. **Pause Resources When Not in Use**
```bash
# Pause Synapse SQL Pool
az synapse sql pool pause \
  --name dev_infracore_synapse_sqlpool \
  --workspace-name dev-synapse-synapse \
  --resource-group rg-prod-in-cmu

# Resume when needed
az synapse sql pool resume \
  --name dev_infracore_synapse_sqlpool \
  --workspace-name dev-synapse-synapse \
  --resource-group rg-prod-in-cmu
```

2. **Configure Auto-Scaling**
   - Synapse Spark Pool: Auto-scale between 3-10 nodes
   - Auto-pause: 15 minutes of inactivity
   - Stream Analytics: Start with 1 SU, scale based on metrics

3. **Implement Resource Tagging**
```hcl
tags = {
  Environment = "dev"
  Project     = "infracore"
  CostCenter  = "analytics"
  Owner       = "joel.maison@example.com"
}
```

4. **Set Up Cost Alerts**
   - Configure budget alerts at 50%, 75%, 90% thresholds
   - Monitor daily spending in Azure Cost Management
   - Review monthly cost reports

5. **Storage Optimization**
   - Move infrequently accessed data to cool tier
   - Implement lifecycle management policies
   - Delete unnecessary snapshots and backups

### Monitoring Costs
```bash
# View current month costs
az consumption usage list \
  --start-date $(date -d "1 month ago" +%Y-%m-%d) \
  --end-date $(date +%Y-%m-%d) \
  --query "[?contains(instanceName, 'rg-prod-in-cmu')]"
```

---

## Future Enhancements

### Short-term (1-3 months)

1. **Complete Security Hardening**
   - Implement private endpoints for all services
   - Configure Azure Policy for compliance
   - Set up Azure Sentinel for security monitoring

2. **Backup and Disaster Recovery**
   - Configure Azure Backup for SQL pools
   - Implement geo-redundant storage
   - Create disaster recovery runbooks
   - Test recovery procedures

3. **Monitoring and Alerting**
   - Create comprehensive dashboards
   - Set up proactive alerts for:
     - Resource utilization
     - Performance degradation
     - Security events
     - Cost anomalies

4. **Stream Analytics Enhancement**
   - Configure actual input sources (Event Hub/IoT Hub)
   - Implement real transformation logic
   - Add multiple outputs (SQL, Data Lake, Power BI)
   - Test with production data

### Medium-term (3-6 months)

1. **Infrastructure Improvements**
   - Implement Azure Front Door for global distribution
   - Set up Azure CDN for static content
   - Configure Traffic Manager for failover

2. **Data Pipeline Development**
   - Build end-to-end data pipelines in Synapse
   - Implement data quality checks
   - Create automated ETL workflows
   - Develop data catalog

3. **Advanced Analytics**
   - Deploy machine learning models in Databricks
   - Implement predictive maintenance algorithms
   - Create anomaly detection systems
   - Build recommendation engines

4. **DevOps Integration**
   - Set up CI/CD pipelines for infrastructure
   - Implement automated testing
   - Configure blue-green deployments
   - Create infrastructure documentation automation

### Long-term (6-12 months)

1. **Multi-region Deployment**
   - Deploy infrastructure in secondary region
   - Implement geo-replication
   - Configure global load balancing
   - Test disaster recovery scenarios

2. **Advanced Security**
   - Implement Zero Trust architecture
   - Deploy Azure Defender for Cloud
   - Set up Just-In-Time VM access
   - Configure Conditional Access policies

3. **Performance Optimization**
   - Implement caching strategies
   - Optimize query performance
   - Configure auto-scaling rules
   - Implement performance baselines

4. **Cost Management**
   - Implement FinOps practices
   - Create cost allocation dashboards
   - Automate resource cleanup
   - Optimize resource sizing

---

## Team Contributions

### Joel Maison (Technical Associate)
- **Month 1, Week 3:** Key Vault configuration
- **Month 1, Week 4:** Monitoring and alerting setup
- **Month 2, Week 1:** Stream Analytics analysis and module development
- **Month 2, Week 4:** Stream Analytics deployment
- **Bonus:** Security hardening implementation (NSG, Managed Identity)

### Mark (Team Member)
- Synapse Analytics workspace design and deployment
- SQL Pool and Spark Pool configuration
- Network security parameterization

### Oseno (Team Member)
- Databricks workspace deployment
- Stream Analytics templates
- SQL Server configurations

---

## References

### Documentation
- [OpenTofu Documentation](https://opentofu.org/docs/)
- [Azure Stream Analytics](https://learn.microsoft.com/en-us/azure/stream-analytics/)
- [Azure Synapse Analytics](https://learn.microsoft.com/en-us/azure/synapse-analytics/)
- [Azure Databricks](https://learn.microsoft.com/en-us/azure/databricks/)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

### Tutorials
- [IaC Best Practices](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/infrastructure-as-code)
- [Azure Security Best Practices](https://learn.microsoft.com/en-us/azure/security/fundamentals/best-practices-and-patterns)
- [Stream Analytics Query Language](https://learn.microsoft.com/en-us/stream-analytics-query/stream-analytics-query-language-reference)

### Related Projects
- [Husk Power Systems](https://www.huskpowersystems.com/)
- [CMU Africa MSIT Program](https://www.cmu.edu/africa/)

---

## Contact

**Author:** Joel Maison  
**Email:** joel.maison@example.com  
**Institution:** Carnegie Mellon University Africa  
**GitHub:** [Project Repository](https://github.com/oseno/husk-systems-iac-practicum)

---

## License

This project is developed as part of the CMU Africa MSIT practicum program in collaboration with Husk Power Systems.

---

**Last Updated:** November 29, 2024  
**Version:** 1.0  
**Status:** Production Deployment Complete
