# Gemini Code Butler Context

## Project Overview

This project is a GitOps-driven Bare Metal Kubernetes Homelab. It uses a combination of technologies to manage and deploy applications on a Kubernetes cluster.

- **Orchestration:** Kubernetes (K3s)
- **GitOps:** Flux
- **Infrastructure as Code:** Ansible
- **Operating System:** Debian
- **Networking:** Cilium (CNI)
- **Ingress:** ingress-nginx
- **Certificate Management:** cert-manager
- **Storage:** Longhorn
- **CI/CD:** Renovate

The repository is structured to separate concerns, with a clear distinction between infrastructure, applications, and cluster configuration.

## Directory Structure

-   `ansible/`: Contains Ansible playbooks for provisioning and configuring the servers. The main playbook is `site.yml`.
-   `clusters/`: Defines the Flux Kustomizations for deploying applications and infrastructure controllers. The `main` cluster is configured here.
-   `apps/`: Contains the Kubernetes manifests for the applications deployed on the cluster. It's divided into `base`, `production`, and `staging` environments.
-   `infrastructure/`: Defines the infrastructure controllers and their configurations. This includes `ingress-nginx`, `cert-manager`, `longhorn`, and others.
-   `monitoring/`: Holds the monitoring stack configurations, including `kube-prometheus-stack`.

## Building and Running

This project uses Ansible to provision the Kubernetes cluster and Flux to deploy applications.

### Ansible

To provision the cluster, you will need to have Ansible installed and configured. The main playbook is `ansible/site.yml`.

1.  **Install Ansible Dependencies:**

    ```bash
    ansible-galaxy install -r ansible/requirements.yml
    ```

2.  **Run the Playbook:**

    ```bash
    ansible-playbook -i ansible/inventory.ini ansible/site.yml
    ```

    **Note:** You will need to have a properly configured `ansible/inventory.ini` file that defines the hosts for your cluster.

### Flux

Flux is configured to watch the `clusters/main` directory. Any changes to the Kubernetes manifests in this directory will be automatically applied to the cluster.

The main Flux configuration is in `clusters/main/flux-system/gotk-sync.yaml`. This file defines the GitRepository source and the Kustomization to apply.

## Development Conventions

-   **GitOps:** All changes to the cluster should be made through Git. Direct changes to the cluster using `kubectl` should be avoided.
-   **Kustomize:** Kustomize is used to manage the Kubernetes manifests. Each application and environment has its own Kustomization file.
-   **SOPS:** Sensitive information, such as secrets, is encrypted using SOPS. These files are identifiable by the `.sops.yaml` extension. To decrypt or edit these files, you will need to have the `sops` CLI installed and configured with the appropriate age key.
pplications deployed on the cluster.
- `infrastructure/`: Defines the infrastructure controllers and their configurations.
- `monitoring/`: Holds the monitoring stack configurations.
