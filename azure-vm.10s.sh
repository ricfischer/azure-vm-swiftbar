#!/bin/bash

# <xbar.title>Azure VM Manager</xbar.title>
# <xbar.version>v1.0</xbar.version>
# <xbar.author>Ric Fischer</xbar.author>
# <xbar.author.github>ricfischer</xbar.author.github>
# <xbar.desc>Manage Azure VM from menu bar</xbar.desc>
# <xbar.dependencies>azure-cli</xbar.dependencies>
# <xbar.abouturl>https://github.com/ricfischer/azure-vm-swiftbar</xbar.abouturl>

# Configuration - Update these values
RESOURCE_GROUP="your-resource-group"
VM_NAME="your-vm-name"

# Set PATH to include common locations for az command
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo "❌ Azure CLI not found"
    echo "---"
    echo "Install Azure CLI | href=https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
    exit 1
fi

# Check if logged in
if ! az account show &> /dev/null; then
    echo "🔐 Not logged in"
    echo "---"
    echo "Login to Azure | bash='az login' terminal=true"
    exit 1
fi

# Get VM status
VM_STATUS=$(az vm show -d -g "$RESOURCE_GROUP" -n "$VM_NAME" --query powerState -o tsv 2>/dev/null)

if [ $? -ne 0 ]; then
    echo "❌ Error"
    echo "---"
    echo "Check resource group and VM name in script"
    exit 1
fi

# Display status in menu bar
case $VM_STATUS in
    "VM running")
        echo "🟢"
        ;;
    "VM stopped"|"VM deallocated")
        echo "🔴"
        ;;
    "VM starting")
        echo "🟡"
        ;;
    "VM stopping"|"VM deallocating")
        echo "🟡"
        ;;
    *)
        echo "⚫"
        ;;
esac

# Menu items
echo "---"
echo "VM: $VM_NAME"
echo "Status: $VM_STATUS"
echo "---"

case $VM_STATUS in
    "VM running")
        echo "Stop VM | bash='az vm deallocate -g \"$RESOURCE_GROUP\" -n \"$VM_NAME\"' terminal=false refresh=true"
        echo "Restart VM | bash='az vm restart -g \"$RESOURCE_GROUP\" -n \"$VM_NAME\"' terminal=false refresh=true"
        ;;
    "VM stopped"|"VM deallocated")
        echo "Start VM | bash='az vm start -g \"$RESOURCE_GROUP\" -n \"$VM_NAME\"' terminal=false refresh=true"
        ;;
    *)
        echo "Please wait..."
        ;;
esac

echo "---"
echo "Refresh | refresh=true"
echo "Open Azure Portal | href=https://portal.azure.com"