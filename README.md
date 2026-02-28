# multi-cloud-free-tier-lab

A security-first, Infrastructure-as-Code (Terraform) lab that deploys **zero-cost / free-tier** learning environments across **Azure, AWS, and GCP**.

This repo is designed as a portfolio project to demonstrate:

- **Cloud architecture depth** (network segmentation, identity, logging)
- **IaC maturity** (repeatable deployments, modular structure, environment separation)
- **Security-first engineering** (baseline controls + detection notes)
- **Operational thinking** (runbooks, guardrails, cost controls)

> ⚠️ Cost note: Cloud providers change free tier offerings. This repo includes guardrails to prevent accidental spend, but you are responsible for verifying pricing before deploying.

---

## Architecture Overview

- **Network segmentation:** separate subnets for mgmt and workloads; controlled ingress/egress
- **Logging architecture:** centralized logs and audit trails per cloud
- **RBAC/IAM model:** least-privilege roles for admin vs operator vs read-only
- **Security baseline:** default-deny network rules, logging enabled, MFA assumptions

See: `docs/architecture.md`

---

## Repository Layout

- `terraform/azure` - Azure patterns (provider-agnostic where possible)
- `terraform/aws` - AWS free-tier patterns
- `terraform/gcp` - GCP always-free/free-tier patterns
- `docs/` - architecture, security, logging, RBAC, and runbooks

---

## Guardrails (Anti-Surprise-Billing)

- Budgets/alerts where available
- “Never deploy” list for known cost traps
- Naming + tagging standards
- Required variables set to free-tier sizes

See: `docs/cost-guardrails.md`

---

## Status

This is an evolving lab. Improvements are tracked via Issues and PRs.
