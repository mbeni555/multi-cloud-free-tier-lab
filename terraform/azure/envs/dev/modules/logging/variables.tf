variable "owner" { type = string }
variable "workload" { type = string }
variable "platform" { type = string }
variable "environment" { type = string }
variable "location" { type = string }
variable "region" { type = string }
variable "instance" { type = string }
variable "tags" { type = map(string) }

variable "resource_group_name" {
  type = string
}