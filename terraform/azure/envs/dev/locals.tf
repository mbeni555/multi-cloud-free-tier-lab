locals {
  location_short = {
    eastus    = "eus"
    eastus2   = "eus2"
    westus    = "wus"
    westus2   = "wus2"
    centralus = "cus"
  }

  region = lookup(local.location_short, var.location, "unk")

  rg_name = "rg-${var.owner}-${var.workload}-${var.platform}-${var.environment}-${local.region}-${var.instance}"

  tags = {
    owner       = var.owner
    workload    = var.workload
    platform    = var.platform
    environment = var.environment
    repo        = "multi-cloud-free-tier-lab"
    managed_by  = "terraform"
  }
}