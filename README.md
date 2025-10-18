## How to setup Synapse workspace from start to end

### Step 1: Set up OpenTofu Backend Storage

First, run the OpenTofu setup script to configure your backend storage:
```bash
bash az_cli_tf_state_backend_setup.sh
```

If you encounter line ending errors:
```bash
sudo apt-get update && sudo apt-get install dos2unix
dos2unix az_cli_tf_state_backend_setup.sh
bash az_cli_tf_state_backend_setup.sh
```

After successful execution, copy these values for later use:
- Resource Group name
- Storage account name
- Container name

### Step 2: Initialize OpenTofu

Initialize OpenTofu with your backend configuration:
```bash
tofu init \
  -backend-config="resource_group_name=rg-prod-ng-cmu" \
  -backend-config="storage_account_name=dev-synapse-sa-a272" \
  -backend-config="container_name=synapse-dev-fs" \
  -backend-config="key=dev-synapse.tfstate"
```

### Step 3: Set Environment Variables

Set your Synapse SQL password:
```bash
export SYNAPSE_SQL_PASSWORD="pass"
```

### Step 4: Run Synapse Pre-setup

Configure your Synapse environment:
```bash
bash az_cli_synapse_setup.sh
```

If you encounter line ending errors:
```bash
sudo apt-get update && sudo apt-get install dos2unix
dos2unix az_cli_synapse_setup.sh
bash az_cli_synapse_setup.sh
```

After successful execution:
1. Copy the generated Key Vault name
2. Update your `envs/dev.tfvars` file with the Key Vault name in the `key_vault_name` field

### Step 5: Plan Infrastructure

Review your infrastructure changes:
```bash
tofu plan -var-file="envs/dev.tfvars"
```

### Step 6: Apply Infrastructure

Apply your infrastructure configuration:
```bash
tofu apply -var-file="envs/dev.tfvars"
```
