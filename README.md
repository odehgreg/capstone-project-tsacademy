# TaskApp Capstone Deployment (AWS + kOps + Terraform)

## Project Overview
This repository contains my capstone solution for deploying a cloud-native TaskApp (Frontend, Backend, PostgreSQL) to a production-style AWS Kubernetes environment using **kOps** for cluster lifecycle and **Terraform** for infrastructure provisioning.

## Live Endpoints
- Frontend: **https://taskapp.taskapp-james-greg.xyz**
- Backend API: **https://api.taskapp-james-greg.xyz**

## Architecture Summary
- Region: `eu-west-1`
- Kubernetes: kOps-managed cluster
- High Availability:
  - 3 control-plane nodes (across 3 AZs)
  - 3 worker nodes (across 3 AZs)
- Networking:
  - Private node topology
  - Route53 DNS
- Ingress + TLS:
  - NGINX Ingress Controller
  - cert-manager + Let’s Encrypt certificate
- Storage:
  - PostgreSQL on Kubernetes with EBS-backed PVC

## Repository Structure
- `terraform/` – AWS infrastructure IaC
- `kops/` – cluster configuration
- `k8s/` – Kubernetes manifests
- `taskapp_frontend/` – frontend source + Dockerfile
- `taskapp_backend/` – backend source + Dockerfile
- `docs/` – architecture, runbook, cost analysis
- `scripts/` – automation scripts (validation/deploy/cleanup)

## Deployment Workflow
1. Provision infrastructure with Terraform.
2. Create/update cluster with kOps.
3. Deploy ingress and TLS components.
4. Deploy TaskApp manifests (frontend, backend, postgres, ingress).
5. Validate cluster and application health.

## Validation Evidence (summary)
- `kops validate cluster` succeeded.
- All nodes Ready (`3 control-plane + 3 workers`).
- All app pods Running in `taskapp` namespace.
- TLS certificate is Ready and HTTPS is active.
- API login returns JWT token.
- Authenticated `/api/tasks` returns task data.
- PostgreSQL PVC is Bound and persistence verified.

## Security Highlights
- HTTPS enforced via Ingress TLS.
- Private cluster node topology.
- Kubernetes Secrets used for sensitive config.
- JWT-based API authentication.

## Cost Management
To minimize costs, infrastructure is deployed only during implementation/demo windows and destroyed immediately after use.

## Cleanup
```bash
kops delete cluster --name cluster.taskapp-james-greg.xyz --state $KOPS_STATE_STORE --yes
cd terraform
terraform destroy -auto-approve