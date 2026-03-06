############################################
# Core Environment Inputs
#
# These variables control naming and the
# deployment context for this environment.
############################################

variable "owner" {
  description = "Personal identifier used in resource names (change this to your own handle)."
  type        = string
  default     = "mbeni"

  validation {
    condition     = can(regex("^[a-z0-9]{2,10}$", var.owner))
    error_message = "owner must be 2–10 characters: lowercase letters/numbers only."
  }
}

variable "workload" {
  description = "Short name for the workload/project."
  type        = string
  default     = "mcl"
}

variable "platform" {
  description = "Cloud/platform identifier (az/aws/gcp)."
  type        = string
  default     = "az"

  validation {
    condition     = contains(["az", "aws", "gcp"], var.platform)
    error_message = "platform must be one of: az, aws, gcp."
  }
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "test", "stage", "prod"], var.environment)
    error_message = "environment must be one of: dev, test, stage, prod."
  }
}

variable "location" {
  description = "Azure region for this environment."
  type        = string
  default     = "eastus"

  validation {
    condition     = contains(["eastus", "eastus2", "westus", "westus2", "centralus"], var.location)
    error_message = "location must be a supported region."
  }
}

variable "instance" {
  description = "Instance number used for scaling or multiple deployments of the same stack."
  type        = string
  default     = "01"

  validation {
    condition     = can(regex("^[0-9]{2}$", var.instance))
    error_message = "instance must be a 2-digit string."
  }
}

############################################
# Security Baseline Controls
#
# These variables control optional security
# features such as NSG diagnostics.
############################################

variable "enable_nsg_diagnostics" {
  description = "Enable NSG diagnostics and metrics to Log Analytics."
  type        = bool
  default     = false
}

############################################
# NSG Rule Configuration
#
# These variables control which inbound rules
# are created inside the management and
# workload Network Security Groups.
############################################

variable "admin_source_cidrs" {
  description = "List of CIDR ranges allowed to access the management subnet via SSH/RDP (example: [\"203.0.113.10/32\"])."
  type        = list(string)
  default     = []
}

variable "enable_management_ssh" {
  description = "Allow inbound SSH (22) access to the management subnet from admin_source_cidrs."
  type        = bool
  default     = false
}

variable "enable_management_rdp" {
  description = "Allow inbound RDP (3389) access to the management subnet from admin_source_cidrs."
  type        = bool
  default     = false
}

variable "enable_workload_allow_from_mgmt" {
  description = "Allow inbound traffic to the workload subnet from the management subnet."
  type        = bool
  default     = false
}

variable "workload_allowed_ports" {
  description = "Destination ports allowed from the management subnet to the workload subnet when enabled."
  type        = list(string)
  default     = ["22"]
}