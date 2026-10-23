# multi-cloud-free-tier-lab

A security-first, Infrastructure-as-Code (Terraform) lab for building **zero-cost / free-tier** learning environments across **Azure, AWS, and GCP**.

> **Status:** Azure foundation is built and validates. AWS and GCP stacks are on the roadmap below.

> ⚠️ Cost note: Cloud providers change free tier offerings. Verify pricing before you deploy. Log Analytics ingestion can incur cost depending on volume and retention.

---

## What's Built (Azure)

Everything lives in `terraform/azure/envs/dev`.

- **Resource group** with a consistent naming pattern: `<type>-<owner>-<workload>-<platform>-<env>-<region>-<instance>` (example: `rg-mbeni-mcl-az-dev-eus-01`)
- **Shared tags** on every resource: owner, workload, platform, environment, repo, managed_by
- **Logging module:** Log Analytics workspace (PerGB2018, 30-day retention)
- **Networking module:**
  - VNet `10.10.0.0/16` with separate **mgmt** and **workload** subnets
  - NSG per subnet, **default-deny inbound** (no allow rules unless you turn them on)
  - Optional SSH/RDP into mgmt, limited to `admin_source_cidrs`
  - Optional mgmt-to-workload ports, to control lateral movement
  - Optional NSG diagnostics shipped to the Log Analytics workspace

See [`docs/architecture.md`](docs/architecture.md) for the diagram and toggle reference.

---

## Quick Start

```bash
cd terraform/azure/envs/dev
az login
terraform init
terraform plan -var="owner=<your-initials>"
terraform apply -var="owner=<your-initials>"
```

Tear it down when you're done:

```bash
terraform destroy -var="owner=<your-initials>"
```

---

## Roadmap

- [x] Azure: resource group, naming, tagging
- [x] Azure: VNet, segmented subnets, default-deny NSGs
- [x] Azure: Log Analytics + optional NSG diagnostics
- [ ] Azure: NSG flow logs (needs Network Watcher + storage module)
- [ ] Azure: RBAC model (admin / operator / read-only)
- [ ] Azure: budget + cost alerts
- [ ] CI: `terraform fmt` / `validate` / Checkov on pull requests
- [ ] AWS free-tier stack (VPC, IAM, CloudTrail)
- [ ] GCP always-free stack (VPC, IAM, Cloud Logging)
