# 🏠 Homelab

**A GitOps-driven, Bare Metal Kubernetes cluster.**

This repository contains the Infrastructure as Code (IaC) and configuration for my personal homelab. It serves as a production-grade playground for exploring Cloud Native technologies, focusing on automation, security, and high availability.

## 📖 Introduction

The purpose of this homelab is twofold: continuous learning and full-stack responsibility.

As a recent Computer Science graduate passionate about Cloud Native technologies, this lab allows me to experiment with bleeding-edge tools and architectures (like eBPF with Cilium or GitOps with Flux) in a controlled environment to build deep technical expertise.

By self-hosting applications, I take ownership of the entire lifecycle—from hardware provisioning to application deployment, backup strategies, and observability.

## 🏗️ Architecture & Provisioning

I follow a strictly **Declarative** approach. If it's not in Git, it doesn't exist.

*   **Provisioning:** I use **Ansible** to bootstrap bare metal Debian nodes. This includes OS hardening, dependency installation, and spinning up the K3s cluster.
*   **Orchestration:** **K3s** is my distribution of choice for its lightweight footprint without compromising on standard Kubernetes features.
*   **GitOps:** **Flux** monitors this repository and automatically reconciles the cluster state. This ensures that the live cluster always matches the configuration committed to code, preventing configuration drift.

### ⚖️ Design Decisions

*   **Access Strategy:** I prioritize security and simplicity for service access:
    *   **Internal Access:** Services are accessible directly within the local network or remotely via **Tailscale**, which provides a secure Mesh VPN layer.
    *   **Public Access:** Specific services are exposed via **Cloudflare Zero Trust**, leveraging Cloudflare Authentication to ensure only authorized users can reach them without needing a traditional VPN.
*   **Bare Metal vs. Virtualization:** To maximize the performance of my hardware, I opted for a **Bare Metal** installation instead of using a virtualization layer like Proxmox. This avoids the overhead of an hypervisor, which is critical given the resources of my mini PCs, and ensures that the cluster remains performant for both experimentation and private services.

## 💻 Hardware

The cluster is composed of 3 **Dell Optiplex 7040 Micro** mini PCs. These units offer a perfect balance of performance and power efficiency for a 24/7 homelab environment.

| Node | Model | CPU | RAM | OS | Role |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **k8s-cp** | Optiplex 7040 | i5-6600T | 16GB | Debian | Control Plane |
| **k8s-wp** | Optiplex 7040 | i5-6600T | 16GB | Debian | Worker (Primary Storage) |
| **k8s-ws** | Optiplex 7040 | i5-6600T | 16GB | Debian | Worker |

## 🚀 Technology Stack

This project leverages a modern Cloud Native stack to ensure performance, security, and observability.

### Infrastructure & Networking

| Logo | Technology | Purpose |
| :---: | :--- | :--- |
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

### Secret Management

*   **SOPS (Secrets OPerationS):** All secrets in this repo are encrypted using SOPS with Age keys. They are safe to commit to public repositories and are decrypted natively inside the cluster by Flux.

## 📱 Applications

| Logo | Application | Description |
| :---: | :--- | :--- |
| <img src="https://dariomazza.net/favicon.ico" width="40"> | [**Portfolio**](https://dariomazza.net) | My personal developer portfolio and resume site. |

## 🛠️ How it Works

1.  **Code Change:** I commit a change to a manifest (e.g., upgrading an image version).
2.  **Flux Reconcile:** Flux detects the commit and pulls the changes.
3.  **Apply:** Flux applies the changes to the K3s cluster.
4.  **Drift Detection:** If someone manually changes a resource on the cluster, Flux undoes it, restoring the state defined in Git.

---

*This project is constantly evolving. Feel free to explore the code to see how I handle specific challenges!*