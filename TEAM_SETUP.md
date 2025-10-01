# Team Setup Guide - InfraCore OpenTofu Environment

## What Has Been Set Up (By Oseno)

Oseno has completed the foundational OpenTofu infrastructure setup. Here's what exists now:

###  Completed Infrastructure:
- **Azure Storage Backend**: Storage account `saprodngcmu` in resource group `rg-prod-ng-cmu`
- **State Container**: Container named `opentofu-state` for storing infrastructure state
- **OpenTofu Configuration**: All configuration files (backend.tf, variables.tf, main.tf, outputs.tf)
- **Remote State Locking**: Automatic locking prevents team members from conflicting changes
- **GitHub Repository**: Code is available at https://https://github.com/oseno/husk-systems-iac-practicum

### 📋 What You Need:
- Storage Account Name: `saprodngcmu`
- Container Name: `opentofu-state`
- Resource Group: `rg-prod-ng-cmu`
- Access Key: Get from Azure Portal (instructions below)

---

## Prerequisites - Install These First

### 1. Azure CLI
Download and install from: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli

**Test it works**:
```bash
az --version
```
You should see version information.

### 2. OpenTofu
Download and install from: https://opentofu.org/docs/intro/install/

**Test it works**:
```bash
tofu --version
```
You should see OpenTofu version information.

### 3. Git
Download and install from: https://git-scm.com/downloads

**Test it works**:
```bash
git --version
```
You should see Git version information.

---

## Step-by-Step Setup for Team

### Step 1: Login to Azure

Open your terminal/command prompt and run:
```bash
az login
```

A browser window will open. Sign in with your Husk Power Systems account (e.g., `ta_joel@huskpowersystems.com` or `ta_mark@huskpowersystems.com`).

**Verify login**:
```bash
az account show
```

You should see your subscription information with `"name": "HPS-atQor-CSP"`.

---

### Step 2: Clone the Repository

Navigate to where you want the project:
```bash
cd Wherever
```

Clone the repository:
```bash
git clone [repository-url-here]
cd husk-systems-iac-practicum
```

**Verify files exist**:
```bash
# Windows
dir

# Mac/Linux
ls
```

You should see: `backend.tf`, `variables.tf`, `main.tf`, `outputs.tf`, `backend.conf`, `.gitignore`

---

### Step 3: Get Storage Account Access Key

You need the access key to connect to the backend storage.

**Option A: Using Azure Portal**:
1. Go to https://portal.azure.com
2. Navigate to resource group `rg-prod-ng-cmu`
3. Click on storage account `saprodngcmu`
4. In left menu, click "Access keys"
5. Under "key1", click "Show"
6. Click "Copy" button next to the key
7. Save this key temporarily (you'll need it in Step 4)

**Option B: Using Azure CLI**:
```bash
az storage account keys list --resource-group rg-prod-ng-cmu --account-name saprodngcmu --query "[0].value" -o tsv
```

Copy the output - this is your access key.

---

### Step 4: Set Up Environment Variables

You need to tell OpenTofu how to connect to the backend storage.

#### Windows Command Prompt:
```cmd
set ARM_RESOURCE_GROUP_NAME=rg-prod-ng-cmu
set ARM_STORAGE_ACCOUNT_NAME=saprodngcmu
set ARM_CONTAINER_NAME=opentofu-state
set ARM_KEY=dev/terraform.tfstate
set ARM_ACCESS_KEY=YOUR_ACCESS_KEY_FROM_STEP_3
```

Replace `YOUR_ACCESS_KEY_FROM_STEP_3` with the actual access key you copied.

#### Windows PowerShell:
```powershell
$env:ARM_RESOURCE_GROUP_NAME="rg-prod-ng-cmu"
$env:ARM_STORAGE_ACCOUNT_NAME="saprodngcmu"
$env:ARM_CONTAINER_NAME="opentofu-state"
$env:ARM_KEY="dev/terraform.tfstate"
$env:ARM_ACCESS_KEY="YOUR_ACCESS_KEY_FROM_STEP_3"
```

#### Mac/Linux:
```bash
export ARM_RESOURCE_GROUP_NAME="rg-prod-ng-cmu"
export ARM_STORAGE_ACCOUNT_NAME="saprodngcmu"
export ARM_CONTAINER_NAME="opentofu-state"
export ARM_KEY="dev/terraform.tfstate"
export ARM_ACCESS_KEY="YOUR_ACCESS_KEY_FROM_STEP_3"
```

**Important**: Replace `YOUR_ACCESS_KEY_FROM_STEP_3` with your actual key.

---

### Step 5: Initialize OpenTofu

Run this command to connect to the shared backend:
```bash
tofu init -backend-config=backend.conf
```

**What this does**: 
- Downloads the Azure provider plugin
- Connects to the shared state storage in `saprodngcmu`
- Sets up state locking

**Success looks like**:
```
Initializing the backend...
Successfully configured the backend "azurerm"!
Initializing provider plugins...
OpenTofu has been successfully initialized!
```

**If you see errors**: Go to the Troubleshooting section at the bottom.

---

### Step 6: Verify You Can See Shared State

Run:
```bash
tofu plan
```

**What you should see**:
- If someone else already created test resources: You'll see them listed
- If no resources exist yet: `No changes. Your infrastructure matches the configuration.`
- **No errors about backend or state**

This confirms you're connected to the same backend as the team

---

### Step 7: Set Up Your Personal Development Namespace

**Why you need this**: To avoid conflicts while learning and testing, each team member should work in their own "namespace" (separate state file).

#### For Joel - Create Personal Namespace:
```bash
# Windows Command Prompt
set ARM_KEY=dev/joel/terraform.tfstate

# Windows PowerShell
$env:ARM_KEY="dev/joel/terraform.tfstate"

# Mac/Linux
export ARM_KEY="dev/joel/terraform.tfstate"
```

Then reinitialize:
```bash
tofu init -reconfigure -backend-config=backend.conf
```

#### For Mark - Create Personal Namespace:
```bash
# Windows Command Prompt
set ARM_KEY=dev/mark/terraform.tfstate

# Windows PowerShell
$env:ARM_KEY="dev/mark/terraform.tfstate"

# Mac/Linux
export ARM_KEY="dev/mark/terraform.tfstate"
```

Then reinitialize:
```bash
tofu init -reconfigure -backend-config=backend.conf
```

**What this does**: 
- Creates your own state file at `dev/joel/terraform.tfstate` or `dev/mark/terraform.tfstate`
- You can now test and learn without affecting shared state
- Your changes won't conflict with other team members

---

### Step 8: Test Your Personal Namespace(Optional)

Create a test file named `test-yourname.tf` (replace `yourname` with your actual name):

**For Joel** - Create `test-joel.tf`:
```hcl
resource "azurerm_storage_account" "test_joel" {
  name                     = "sadevjoeltest${formatdate("MMDD", timestamp())}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    Environment = "development"
    Project     = "InfraCore"
    Owner       = "Joel"
    Purpose     = "Testing personal namespace"
  }

  lifecycle {
    ignore_changes = [name]
  }
}

output "joel_test_storage_name" {
  value = azurerm_storage_account.test_joel.name
}
```

**For Mark** - Create `test-mark.tf`:
```hcl
resource "azurerm_storage_account" "test_mark" {
  name                     = "sadevmarktest${formatdate("MMDD", timestamp())}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    Environment = "development"
    Project     = "InfraCore"
    Owner       = "Mark"
    Purpose     = "Testing personal namespace"
  }

  lifecycle {
    ignore_changes = [name]
  }
}

output "mark_test_storage_name" {
  value = azurerm_storage_account.test_mark.name
}
```

Now run:
```bash
tofu plan
tofu apply
```

Type `yes` when prompted.

**Verify in Azure Portal**:
1. Go to resource group `rg-prod-ng-cmu`
2. You should see your test storage account (e.g., `sadevjoeltest1001`)

**Clean up your test**:
```bash
tofu destroy
```

Type `yes` when prompted.

**Delete your test file**:
```bash
# Windows
del test-yourname.tf

# Mac/Linux
rm test-yourname.tf
```

---

## Understanding Environment Strategy

### The Flow

The gist of it is that we will all be working on the same Azure environment so it is better for is to follow this flow:

**Example - Developing Synapse parameterization**:
```bash
# Set his personal namespace
export ARM_KEY="dev/mark/terraform.tfstate"
tofu init -reconfigure -backend-config=backend.conf

# Create synapse-params.tf and tests
tofu plan
tofu apply
```
Synapse networking, firewall rules, and compute pool parameters can all be tested without affecting any other persons work. Work in your namespace then switch to shared dev

**Once working, switch to shared dev**:
```bash
export ARM_KEY="dev/terraform.tfstate"
tofu init -reconfigure -backend-config=backend.conf
```

5. **Announce and deploy to shared**:
- Message in team chat: "Deploying Synapse workspace to shared dev"
- Run: `tofu apply`


####  Shared Development (`dev/terraform.tfstate`)
**Use when**:
- Your code is tested and ready
- Integrating with team's work
- Creating resources everyone needs
- Coordinating with team (announce in chat first)

####  Staging (`stg/terraform.tfstate`)
**Use when**:
- Testing before production
- Client review and feedback
- Integration testing
- Final validation

####  Production (`prod/terraform.tfstate`)
**Use when**:
- Deploying to production
- Client has approved
- Team coordination required
- Let's be very careful with this

---

## Daily Workflow Best Practices

### Starting Your Day:
```bash
# 1. Get latest code
git pull

# 2. Set your personal namespace
export ARM_KEY="dev/yourname/terraform.tfstate"

# 3. Initialize (if needed)
tofu init -reconfigure -backend-config=backend.conf

# 4. See current state
tofu plan
```

### Working on Your Task:
```bash
# 1. Make changes to .tf files
# 2. Test changes
tofu plan

# 3. Apply if looks good
tofu apply
```

### Sharing Your Work:
```bash
# 1. Test thoroughly in personal namespace
tofu apply   # in personal namespace
# Test the resources work

# 2. Commit your code
git add .
git commit -m "Add Synapse workspace configuration"
git push

# 3. Announce to team
# "Deploying Synapse to shared dev in 5 minutes"

# 4. Switch to shared namespace
export ARM_KEY="dev/terraform.tfstate"
tofu init -reconfigure -backend-config=backend.conf

# 5. Deploy to shared
tofu apply
```

### End of Day:
```bash
# 1. Save your work
git add .
git commit -m "Work in progress: Synapse parameterization"
git push

# 2. Optional: Clean up test resources
tofu destroy  # in your personal namespace
```
---

## Quick Reference Commands

### Initialization:
```bash
tofu init -backend-config=backend.conf
tofu init -reconfigure -backend-config=backend.conf  # If backend changed
```

### Planning & Applying:
```bash
tofu plan           # See what will change
tofu apply          # Apply changes
tofu apply -auto-approve  # Apply without confirmation (be careful!)
tofu destroy        # Remove all resources
```

### State Management:
```bash
tofu state list     # List all resources in current state
tofu state show [resource]  # Show details of a resource
tofu refresh        # Update state from Azure
```

### Git Commands:
```bash
git pull            # Get latest changes
git status          # See what changed
git add .           # Stage all changes
git commit -m "message"  # Commit changes
git push            # Push to GitHub
```

---