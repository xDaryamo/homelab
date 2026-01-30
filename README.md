# 🏠 Homelab

**A GitOps-driven, Bare Metal Kubernetes cluster.**

This repository contains the Infrastructure as Code (IaC) and configuration for my personal homelab. It serves as a production-grade playground for exploring Cloud Native technologies, focusing on automation, security, and high availability.

## 📖 Introduction

The purpose of this homelab is twofold: continuous learning and full-stack responsibility.

As a recent Computer Science graduate passionate about Cloud Native technologies, this lab allows me to experiment with bleeding-edge tools and architectures (like eBPF with Cilium or GitOps with Flux) in a controlled environment to build deep technical expertise.

By self-hosting applications, I take ownership of the entire lifecycle—from hardware provisioning to application deployment, backup strategies, and observability.

## 🏗️ Architecture & GitOps Flow

I follow a strictly **Declarative** approach. If it's not in Git, it doesn't exist.

```mermaid
graph TD
    user[User/Developer] -->|Push Code| git[GitHub Repository]
    user -->|Provision| tf[Terraform]

    subgraph "Azure Cloud"
        tf -->|Manage| kv[Azure Key Vault]
    end

    subgraph "Bare Metal Cluster"
        flux[Flux CD] -->|Watch & Pull| git
        flux -->|Reconcile| k3s[K3s Cluster]
        k3s -->|Deploy| app[Applications]
        eso[External Secrets] -.->|Fetch Secrets| kv
        cilium[Cilium CNI] -.->|Pod Networking / eBPF| app
    end
    
    client[External Client] -->|HTTPS| cf[Cloudflare Zero Trust]
    cf -->|Tunnel| ingress[Ingress NGINX]
    ingress -->|Route| app
```

*   **Provisioning:**
    *   **Bare Metal:** I use **Ansible** to bootstrap the physical Debian nodes.
    *   **Cloud Infrastructure:** I use **Terraform** to manage Azure resources (Key Vault, Identities) as code, ensuring a reproducible hybrid environment.
*   **Orchestration:** **K3s** is my distribution of choice for its lightweight footprint.
*   **GitOps:** **Flux** monitors this repository and automatically reconciles the cluster state.

### ⚖️ Design Decisions

*   **Public vs. Private Architecture:** I utilize a multi-source GitOps strategy. This public repository manages the infrastructure and open-source stack, while a linked **Private Repository** handles sensitive workloads and personal data. Flux seamlessly reconciles both streams, allowing me to share my work publicly while keeping private data secure.
*   **Access Strategy:** I prioritize security and simplicity for service access:
    *   **Internal Access:** Services are accessible directly within the local network or remotely via **Tailscale**, which provides a secure Mesh VPN layer.
    *   **Public Access:** Specific services are exposed via **Cloudflare Zero Trust**, leveraging Cloudflare Authentication to ensure only authorized users can reach them without needing a traditional VPN.
*   **Bare Metal vs. Virtualization:** To maximize the performance of my hardware, I opted for a **Bare Metal** installation instead of using a virtualization layer like Proxmox. This avoids the overhead of an hypervisor, which is critical given the resources of my mini PCs, and ensures that the cluster remains performant for both experimentation and private services.

## 📂 Repository Structure

The repository mimics a standard enterprise monorepo structure, separating concerns between infrastructure, cluster definition, and applications.

```text
├── 📂 ansible/        # Ansible playbooks for OS provisioning and K3s installation
├── 📂 apps/           # Application manifests (Base, Staging, Production overlays)
├── 📂 clusters/       # Flux Cluster definitions (entry point for GitOps)
├── 📂 infrastructure/ # Infrastructure components (Ingress, Cert-Manager, Cilium)
└── 📂 monitoring/     # Observability stack (Prometheus, Grafana)
```

## 💻 Hardware

The cluster is composed of 3 **Dell Optiplex 7040 Micro** mini PCs. These units offer a perfect balance of performance and power efficiency for a 24/7 homelab environment.

| Node | Model | CPU | RAM | OS | Role |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **k8s-cp** | Optiplex 7040 | i5-6600T | 16GB | Debian | Control Plane |
| **k8s-wp** | Optiplex 7040 | i5-6600T | 16GB | Debian | Worker (Primary Storage) |
| **k8s-ws** | Optiplex 7040 | i5-6600T | 16GB | Debian | Worker |

## 🚀 Technology Stack

This project leverages a modern Cloud Native stack to ensure performance, security, and observability.

### Cloud & Infrastructure as Code

| Logo | Technology | Purpose |
| :---: | :--- | :--- |
| <img src="https://cdn.simpleicons.org/terraform" width="40"> | [**Terraform**](https://www.terraform.io/) | **Infrastructure as Code.** Provisions and manages Azure resources (Key Vault, IAM) to ensure a reproducible cloud environment. |
| <img src="https://avatars.githubusercontent.com/u/6844498?s=200&v=4" width="40"> | [**Microsoft Azure**](https://azure.microsoft.com/) | **Cloud Provider.** Hosts the Key Vault for secret management, integrating enterprise-grade security into the homelab. |
| <img src="https://cdn.simpleicons.org/ansible" width="40"> | [**Ansible**](https://www.ansible.com/) | **Configuration Management.** Automates the provisioning and hardening of the bare metal Debian servers. |

### Infrastructure & Networking

| Logo | Technology | Purpose |
| :---: | :--- | :--- |
| <img src="https://raw.githubusercontent.com/external-secrets/external-secrets/main/assets/eso-logo-large.png" width="40"> | [**External Secrets**](https://external-secrets.io/) | **Secret Management.** Bridges the gap between Azure Key Vault and Kubernetes, syncing cloud secrets into the cluster securely. |
| <img src="https://cdn.simpleicons.org/cilium" width="40"> | [**Cilium**](https://cilium.io/) | **CNI & Security.** Uses eBPF for high-performance networking and L2 announcements. |
| <img src="https://cdn.simpleicons.org/flux" width="40"> | [**Flux**](https://fluxcd.io/) | **GitOps.** Automates deployment and lifecycle management. |
| <img src="https://cdn.simpleicons.org/nginx" width="40"> | [**Ingress NGINX**](https://kubernetes.github.io/ingress-nginx/) | **Ingress Controller.** Handles internal HTTP/HTTPS routing. |
| <img src="https://cdn.simpleicons.org/cloudflare" width="40"> | [**Cloudflare Zero Trust**](https://www.cloudflare.com/products/zero-trust/) | **Security & Access.** Provides secure access to internal applications and the cluster without a VPN. |
| <img src="https://raw.githubusercontent.com/cert-manager/cert-manager/master/logo/logo-small.png" width="40"> | [**Cert-Manager**](https://cert-manager.io/) | **Security.** Automates issuance and renewal of Let's Encrypt SSL certificates. |
| <img src="https://cdn.simpleicons.org/kubernetes" width="40"> | [**ExternalDNS**](https://github.com/kubernetes-sigs/external-dns) | **DNS Automation.** Synchronizes exposed Kubernetes services and ingresses with DNS providers. |
| <img src="https://cdn.simpleicons.org/pihole" width="40"> | [**Pi-hole**](https://pi-hole.net/) | **Network DNS.** Runs in a Docker container outside K3s to ensure home internet stability during cluster maintenance. |

### Storage & Observability

| Logo | Technology | Purpose |
| :---: | :--- | :--- |
| <img src="https://avatars.githubusercontent.com/u/51335366?s=200&v=4" width="40"> | [**Longhorn**](https://longhorn.io/) | **Distributed Block Storage.** Provides highly available persistent storage for stateful workloads. |
| <img src="https://cdn.simpleicons.org/prometheus" width="40"> | [**Prometheus**](https://prometheus.io/) | **Metrics.** Scrapes and stores metrics from all cluster components. |
| <img src="https://cdn.simpleicons.org/grafana" width="40"> | [**Grafana**](https://grafana.com/) | **Visualization.** Dashboards for monitoring cluster health and performance. |
| <img src="https://avatars.githubusercontent.com/u/38656520?s=200&v=4" width="40"> | [**Renovate**](https://renovatebot.com/) | **Automation.** Automatically creates Pull Requests to update dependencies. |

## 📱 Applications

| Logo | Application | Description |
| :---: | :--- | :--- |
| <img src="https://dariomazza.net/favicon.ico" width="40"> | [**Portfolio**](https://dariomazza.net) | My personal developer portfolio and resume site. |
| <img src="https://avatars.githubusercontent.com/u/122929872" width="40"> | **Homepage** | A modern, highly customizable dashboard for my homelab. |
| <img src="https://docs.vocard.xyz/2.7.2/assets/logo.png" width="40"> | [**Vocard**](https://github.com/ChocoMeow/Vocard-Dashboard) | A feature-rich Discord music bot. Its microservices stack includes **Lavalink** for audio processing and **MongoDB** for data persistence. |

## ⚡ Bootstrap & Disaster Recovery

This cluster is designed to be fully reproducible. In case of a catastrophic failure, it can be rebuilt from scratch using the following steps.

1.  **Provision Hardware & K3s:**
    Using the Ansible playbooks located in `ansible/`, we install dependencies, harden the OS, and install K3s.
    ```bash
    ansible-galaxy install -r ansible/requirements.yml
    ansible-playbook -i ansible/inventory.ini ansible/site.yml
    ```

2.  **Bootstrap Flux:**
    Flux is installed on the cluster and pointed to this repository.
    ```bash
    flux bootstrap github \
      --owner=$GITHUB_USER \
      --repository=homelab \
      --path=clusters/main \
      --personal
    ```

3.  **Configure Secret Access:**
    The Azure Service Principal credentials must be manually added to the cluster to allow the External Secrets Operator to authenticate with Azure Key Vault.
    ```bash
    kubectl create secret generic azure-secret-sp \
      --namespace external-secrets \
      --from-literal=client-id=$AZURE_CLIENT_ID \
      --from-literal=client-secret=$AZURE_CLIENT_SECRET
    ```

---

*This project is constantly evolving. Feel free to explore the code to see how I handle specific challenges!*
