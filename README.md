---
services: aks,eventhub,cosmos,privatelink-service
platforms: dotnet
author: briandenicola
---

# Overview

This repository is a demonstration of how to build a locked sandbox environment in Azure leveraging Private Link Scope. This [article](./Background.md) goes into depth on the design decisions running Sandboxes in Azure. 

# Architecture Diagram
![overview](./assets/environment.png)

# Infrastructure Standup Instructions 
* Please follow these [build](./Infrastructure.md) instructions to setup this demostration in your Azure Subscription.

# Application Deployment
* This [article](./ApplicationLifecycle.md) covers ideas around application deployment and management in the isolated environment. 

# LICENSE
See [LICENSE](LICENSE).