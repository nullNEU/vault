# vault

This is a collection of configuration files aimed at building hardened images of common Operating Systems.

## Background

Operating system images represent a snapshot of an operating system's state including all installed software, system settings, and other configurations. These images can be used to spin up [virtual machines](https://www.cloudflare.com/learning/cloud/what-is-a-virtual-machine/) (VMs) to be deployed or used as deemed fit.

We believe that hardening such images is crucial to meet security standards and compliance requirements. These hardned images can, at the very least, assure:
- minimized [attack surface](https://www.cloudflare.com/learning/security/what-is-an-attack-surface/) by stripping away non-essential services, packages, and/or applications
- tightened configurations by setting strict policies and settings, especially for system security and user account privacy
- regulatory [compliance](https://www.comptia.org/content/articles/what-is-cybersecurity-compliance) by adhering to well established industry standards of security

## Implementation

We are leveraging `cloud-init` to tweak services, settings, packages, and other configurations of the operating system to create a usable hardened image. 

`cloud-init` is, as per the [official docs](https://cloudinit.readthedocs.io/en/latest/index.html), the industry standard tool for configuring cloud instances during boot. Booting up the base OS image along with our `cloud-init` configuration files starts the process of hardening the OS. This will eventually lead to the hardened OS images available for use.

## Operating System(s) in scope
- **Ubuntu Server 22.04.5 LTS (Jammy Jellyfish)**
  - [Get official ISO image here](https://www.releases.ubuntu.com/22.04/)
  - [See our `cloud-init` data](./ubuntu-server-22-04-5/)

## Contributing

Take a look at the [contribution docs](./CONTRIBUTING.md) to get started!

### Contributors

*To be added...*
