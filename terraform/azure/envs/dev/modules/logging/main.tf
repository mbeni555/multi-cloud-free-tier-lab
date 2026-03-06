locals {
  law_name = "law-${var.owner}-${var.workload}-${var.platform}-${var.environment}-${var.region}-${var.instance}"
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = local.law_name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku               = "PerGB2018"
  retention_in_days = 30

  tags = var.tags
}