variable "owner" { type = string }
variable "workload" { type = string }
variable "platform" { type = string }
variable "environment" { type = string }
variable "location" { type = string }
variable "region" { type = string }
variable "instance" { type = string }
variable "tags" { type = map(string) }

variable "resource_group_name" { type = string }

variable "vnet_address_space" {
  type = list(string)
}

variable "subnet_mgmt_prefixes" {
  type = list(string)
}

variable "subnet_workload_prefixes" {
  type = list(string)
}

############################################
# Security Baseline Controls
############################################

variable "enable_security_baseline" {
  description = "Create baseline security resources (NSGs)."
  type        = bool
  default     = true
}

variable "enable_nsg_diagnostics" {
  description = "Send NSG diagnostic logs/metrics to Log Analytics."
  type        = bool
  default     = false
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID used for diagnostics."
  type        = string
  default     = null
}

variable "enable_flow_logs" {
  description = "Enable NSG flow logs (not implemented yet; requires Storage Account)."
  type        = bool
  default     = false
}

############################################
# NSG Rules (Security Baseline)
############################################

variable "admin_source_cidrs" {
  description = "List of CIDR ranges allowed to access the Mgmt subnet via SSH/RDP."
  type        = list(string)
  default     = []
}

variable "enable_management_ssh" {
  description = "Allow inbound SSH (22) to the Mgmt subnet from admin_source_cidrs."
  type        = bool
  default     = false
}

variable "enable_management_rdp" {
  description = "Allow inbound RDP (3389) to the Mgmt subnet from admin_source_cidrs."
  type        = bool
  default     = false
}

variable "enable_workload_allow_from_mgmt" {
  description = "Allow inbound traffic to the Workload subnet from the Mgmt subnet for the ports in workload_allowed_ports."
  type        = bool
  default     = false
}

variable "workload_allowed_ports" {
  description = "Destination ports allowed from Mgmt subnet to Workload subnet when enable_workload_allow_from_mgmt is true."
  type        = list(string)
  default     = ["22"]
}