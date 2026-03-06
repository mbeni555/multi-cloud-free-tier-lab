output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "subnet_mgmt_id" {
  value = azurerm_subnet.mgmt.id
}

output "subnet_workload_id" {
  value = azurerm_subnet.workload.id
}

############################################
# Security Baseline Outputs
############################################

output "nsg_mgmt_id" {
  value       = var.enable_security_baseline ? azurerm_network_security_group.mgmt[0].id : null
  description = "Mgmt NSG resource ID (null if baseline disabled)."
}

output "nsg_workload_id" {
  value       = var.enable_security_baseline ? azurerm_network_security_group.workload[0].id : null
  description = "Workload NSG resource ID (null if baseline disabled)."
}

output "nsg_mgmt_name" {
  value       = var.enable_security_baseline ? azurerm_network_security_group.mgmt[0].name : null
  description = "Mgmt NSG name (null if baseline disabled)."
}

output "nsg_workload_name" {
  value       = var.enable_security_baseline ? azurerm_network_security_group.workload[0].name : null
  description = "Workload NSG name (null if baseline disabled)."
}