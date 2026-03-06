############################################
# Networking Module
#
# Creates:
# - VNet + (mgmt, workload) subnets
# - Optional baseline security (NSGs + associations)
# - Optional NSG diagnostics to Log Analytics
#
# Secure-by-default:
# - No inbound rules are created unless explicitly enabled.
############################################

############################################
# Naming
############################################

locals {
  vnet_name = "vnet-${var.owner}-${var.workload}-${var.platform}-${var.environment}-${var.region}-${var.instance}"

  snet_mgmt_name     = "snet-mgmt-${var.environment}-${var.region}-${var.instance}"
  snet_workload_name = "snet-workload-${var.environment}-${var.region}-${var.instance}"
}

############################################
# Virtual Network + Subnets
############################################

resource "azurerm_virtual_network" "vnet" {
  name                = local.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space

  tags = var.tags
}

resource "azurerm_subnet" "mgmt" {
  name                 = local.snet_mgmt_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_mgmt_prefixes
}

resource "azurerm_subnet" "workload" {
  name                 = local.snet_workload_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_workload_prefixes
}

############################################
# Security Baseline: NSGs (Mgmt + Workload)
############################################

resource "azurerm_network_security_group" "mgmt" {
  count               = var.enable_security_baseline ? 1 : 0
  name                = "nsg-mgmt-${var.environment}-${var.region}-${var.instance}"
  location            = var.location
  resource_group_name = var.resource_group_name

  # Optional inbound SSH from admin CIDRs
  dynamic "security_rule" {
    for_each = var.enable_management_ssh ? [1] : []
    content {
      name                       = "allow-ssh-from-admin"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefixes    = var.admin_source_cidrs
      destination_address_prefix = "*"
    }
  }

  # Optional inbound RDP from admin CIDRs
  dynamic "security_rule" {
    for_each = var.enable_management_rdp ? [1] : []
    content {
      name                       = "allow-rdp-from-admin"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "3389"
      source_address_prefixes    = var.admin_source_cidrs
      destination_address_prefix = "*"
    }
  }

  tags = var.tags
}

resource "azurerm_network_security_group" "workload" {
  count               = var.enable_security_baseline ? 1 : 0
  name                = "nsg-workload-${var.environment}-${var.region}-${var.instance}"
  location            = var.location
  resource_group_name = var.resource_group_name

  # Optional inbound ports from the Mgmt subnet (lateral movement control)
  dynamic "security_rule" {
    for_each = var.enable_workload_allow_from_mgmt ? toset(var.workload_allowed_ports) : toset([])
    content {
      name                       = "allow-${security_rule.value}-from-mgmt"
      priority                   = 200 + index(var.workload_allowed_ports, security_rule.value)
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value
      source_address_prefix      = azurerm_subnet.mgmt.address_prefixes[0]
      destination_address_prefix = "*"
    }
  }

  tags = var.tags
}

# Associate NSGs to subnets
resource "azurerm_subnet_network_security_group_association" "mgmt" {
  count                     = var.enable_security_baseline ? 1 : 0
  subnet_id                 = azurerm_subnet.mgmt.id
  network_security_group_id = azurerm_network_security_group.mgmt[0].id
}

resource "azurerm_subnet_network_security_group_association" "workload" {
  count                     = var.enable_security_baseline ? 1 : 0
  subnet_id                 = azurerm_subnet.workload.id
  network_security_group_id = azurerm_network_security_group.workload[0].id
}

############################################
# Diagnostics: NSG logs/metrics -> Log Analytics
#
# Notes:
# - Optional and OFF by default.
# - Log Analytics ingestion may incur cost depending on volume/retention.
############################################

resource "azurerm_monitor_diagnostic_setting" "nsg_mgmt" {
  count = (
    var.enable_security_baseline &&
    var.enable_nsg_diagnostics &&
    var.log_analytics_workspace_id != null &&
    var.log_analytics_workspace_id != ""
  ) ? 1 : 0

  name                       = "diag-nsg-mgmt-${var.environment}-${var.region}-${var.instance}"
  target_resource_id         = azurerm_network_security_group.mgmt[0].id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "NetworkSecurityGroupEvent"
  }

  enabled_log {
    category = "NetworkSecurityGroupRuleCounter"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

resource "azurerm_monitor_diagnostic_setting" "nsg_workload" {
  count = (
    var.enable_security_baseline &&
    var.enable_nsg_diagnostics &&
    var.log_analytics_workspace_id != null &&
    var.log_analytics_workspace_id != ""
  ) ? 1 : 0

  name                       = "diag-nsg-workload-${var.environment}-${var.region}-${var.instance}"
  target_resource_id         = azurerm_network_security_group.workload[0].id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "NetworkSecurityGroupEvent"
  }

  enabled_log {
    category = "NetworkSecurityGroupRuleCounter"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

############################################
# Flow Logs (Not Implemented Yet)
#
# NSG Flow Logs require a Network Watcher + Storage Account.
# We keep the variable to show intent and enterprise posture,
# but we do not deploy it until we add a dedicated storage module.
############################################