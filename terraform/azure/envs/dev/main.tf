############################################
# Naming Strategy (Read This Before Deploying)
#
# I am following a consistent Azure-style naming pattern:
#
#   <resourceType>-<owner>-<workload>-<platform>-<env>-<region>-<instance>
#
# Example from this lab:
#   rg-mbeni-mcl-az-dev-eus-01
#
# Why this structure:
# - Resource type prefix makes it easy to filter/search in Azure.
# - Owner makes it clear who deployed it (change this to yours).
# - Workload keeps related resources grouped logically.
# - Platform makes it obvious which cloud this stack targets (az/aws/gcp).
# - Environment prevents cross-environment confusion.
# - Region + instance support scale and future growth.
#
# If you fork this repo:
# 👉 Change the "owner" variable first.
# 👉 Optionally change "workload" to match your project name.
############################################

############################################
# NOTE:
# Variables have been moved to variables.tf
# Naming + tags logic has been moved to locals.tf
#
# This keeps root configuration clean and aligned
# with Terraform best-practice file structure.
############################################

resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.location

  tags = local.tags
}

############################################
# Modules (Best Practice Layout)
#
# Root (env) owns:
#  - Naming inputs (owner/workload/env/region/instance)
#  - Shared tags
#  - Resource Group
#
# Modules own:
#  - Networking primitives (VNet/Subnets/etc.)
#  - Logging primitives (Log Analytics/etc.)
############################################

module "logging" {
  source = "./modules/logging"

  # Naming + shared metadata
  owner       = var.owner
  workload    = var.workload
  platform    = var.platform
  environment = var.environment
  location    = var.location
  region      = local.region
  instance    = var.instance
  tags        = local.tags

  # Azure placement
  resource_group_name = azurerm_resource_group.rg.name
}

module "networking" {
  source = "./modules/networking"

  # Naming + shared metadata
  owner       = var.owner
  workload    = var.workload
  platform    = var.platform
  environment = var.environment
  location    = var.location
  region      = local.region
  instance    = var.instance
  tags        = local.tags

  # Azure placement
  resource_group_name = azurerm_resource_group.rg.name

  # Addressing (keep simple for the lab; can be parameterized later)
  vnet_address_space       = ["10.10.0.0/16"]
  subnet_mgmt_prefixes     = ["10.10.1.0/24"]
  subnet_workload_prefixes = ["10.10.2.0/24"]
}