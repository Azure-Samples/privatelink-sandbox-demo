# Sandboxes in Azure 

## Pre-requisite reading

The following links are highly recommended before reading this article to ensure that the concepts discussed are understood.

- Azure fundamentals - This is a great starting point for anyone who wants to learn about Azure. It covers the basics of Azure, including the different services and solutions available.
- Design Azure infrastructure - This article covers the best practices for designing Azure infrastructure. It discusses the different components of an Azure infrastructure, such as virtual networks, virtual machines, and storage accounts.
- Azure Landing Zones - This article covers the concept of Azure Landing Zones and why they are important. It discusses how Azure Landing Zones can help organizations to quickly and consistently deploy their workloads in a secure and compliant manner.
- Azure Network Security - This article covers the basics of network security in Azure. It discusses the different Azure security services and how they can be used to secure your network.
- Azure Network Segmentation - This article covers the concept of network segmentation in Azure. It discusses how network segmentation can be used to increase the security and scalability of your Azure infrastructure, as well as provides guidance on how to implement it.

## Development Environment vs Sandbox

Often times Sandboxes are considered a need for developers, but they're just as vital for teams managing Azure AD infrastructure and infrastructure teams managing foundational components of the cloud ESLZ (Enterprise Scale Landing Zone). Architecture teams, and engineering feature teams also need a place to evaluate new services to use within the enterprise. In many cases developers need access to environments to test new code and test application builds. Most likely this type of environment would be different type of environment than a sandbox to test new Azure features and/or services. This article focuses on the latter.  

## Design Considerations when Planning the sandbox environment

Before building a sandbox environment in Azure, it is important to identify the specific needs and requirements of the organization and plan how you will design the environment to meet those requirements. Common areas to consider are in the following table:

## Azure Tenant decision

When deciding on where to place the sandbox environment there are a few options:

1. Use and existing corporate Azure tenant with a sandbox management group. Details of this configuration are available in the Cloud Adoption Framework documentation

    This option is the most simple, and takes advantage of existing security, network, and Identity controls, without having to re-architect as much.

2. Use a new dedicated Azure tenant, built using the Cloud Adoption Framework ESLZ template, and use Azure Lighthouse to control access with the identity from the existing corporate tenant.

    While a good option, keep in mind that you must also keep a separate set of controls for a new tenant that match or are an acceptable subset of the production tenant.

    One of the biggest considerations between option 1 and option 2 is what level of Azure AD testing is required. For example, an organization that has change control processes for any new application registration in Azure AD likely doesn't want developers testing new applications, therefore a separate Tenant would allow more developer autonomy when testing new features and also allow for testing of other process like batch processing, or automation code, or management group structure changes before deploying to a production tenant. 

3. Allow users to create their own tenants within the company's enterprise agreement and self-govern the layout. (NOT RECOMMENDED)

    This option works if you want users to have full control over what they test and deploy. This requires users to set up and manage security, networking, and identity. It also presents one of the highest risks without proper controls in place. It also has high potential to allow data exfiltration.

4. Allow users to leverage MSDN and visual studio licenses to manage their own tenants.

    Like Option three above, this environment requires users to manage all aspects of the Azure environment and could potentially allow for security risks and data risks.

With the options above, often organizations will choose to use a combination depending primarily on different definitions of "sandbox" and what they're being used for. Scenarios listed below lay out common sandbox configurations.
  
Irrespective of which option is chosen above, if the major concern of an organization is around network segmentation, this can just as easily be achieved within the same tenant as it can cross tenants.

## Design Considerations - Potential risks for sandbox environments

Working through the design choices above is an imperative step to keep control over your sandbox environments. Below are a list of more serious risks that need to be considered and mitigated when deploying any form of sandbox environment.

| Category  |  Consideration |  Example response |
|---|---|---|
| Connectivity  | Will you allow connections to internal data sources, or ingest data into the sandbox ?  | |
| Governance | What is the intent of these sandbox environment?  | Lower Environments, Parallel Governance Environment, New Feature Testing, All of the Above? |
| Governance | Do you have to plan for budgetary constraints for the sandbox environment?  | |
| Governance | Will the sandbox environments be timebound or limited in services scope? | |
| Governance | Are sandboxes deployed centrally with automation or will you allow users to deploy services? | All Services, or a pre-defined set of Services |
| Governance | How will security be controlled in the environment? ||
| Governance | What type of auditing do you need? ||
| Governance | What data classification will be allowed in the sandbox? | Non-PCI, Non-PII, Non-Masked | 
| Governance | How will data be controlled in the environment? | |
| Governance | Are there any Data Sovereignty rules to follow? | Yes, North America Regions only |
| Governance | Are there any regulatory requirements for the sandbox? | No, out of scope of PCI and ISO assessments |
| Governance | Who will own and control the environments? | |
| Governance | What Azure regions and/or Geos will be used? | |
| Governance | How will environment lifecycle be managed? | |
| Governance | What services will not be permitted? | |
| Tooling | What systems will developers use to write code | Azure Dev Box, GitHub CodeSpaces, Hosted VMs | |
| Tooling | What tools are needed for a development environment? | Azure DevOps, GitHub, Artifact repository, Code Scanning | |
| Tooling | How will you create environment(s) – automated or manual | Developer landing zones will be provisioned through Terraform |
| Tooling | Will there be shared services between sandbox environments? | Active Directory, Networking, security, proxy|
| Use | Will the sandbox environment be used for code development or learning how to use Azure resources? | |
| Use | What type of Azure resources can or will be used? | virtual machines, serverless, data functions, SQL, PaaS/IaaS services |
| Use | How will public endpoints be locked down ||
| Use | Do you have specific performance characteristics that need to be met? | |
| Use | Will your users be allowed to build the environment from scratch? | |
| Use | How will users request a sandbox, and how will it be approved? | Service Now, Backstage.io, Azure Deployment Environments |
| Use | Will this environment be used for security team testing or simulating outages? | Blue/Purple/Red Team Penetration testing, Chaos Engineering, Ransomware modeling. |
| User Access | Who can use the sandbox environment? | |
| User Access | Where will users access to the sandbox environment? | from a corporate managed network, home network |
| User Access | What type of device will the user use to access the environment? | corporate managed devices or personal,  personal devices, virtual desktops |
| User Access | What Identity source, if any, will you use? | |

### Azure Services – Policy and Security

**Overview**: In general, many sandboxes will not have the same level of controls to block deployment of specific Azure services. Users need to be able to test new features, and new configurations without being limited in their execution. Organizations also need to keep control to prevent misconfigurations, and security breaches, or cyber attacks.

**Mitigation**: The nature of a sandbox environment is to play with new services and components. Implementing production level controls can be detrimental to the user’s ability to test. When designing policies, ensure that processes exist to allow new services to be approved and deployed in a timely manner, and also allow for exceptions to production rules. A one size fits all approach will likely not work and cause the environments to be unusable. If services are only whitelisted at the top level of the management group hierarchy, this could lead to teams getting access to services which they either haven't been researched or out of scope for their application. Too little access will not allow for full testing.

### Data Exfiltration

**Overview**: Developers may accidentally or intentionally share sensitive data from the sandbox environment with unauthorized parties. It’s important for sandbox environments to have a high level of control to block and control data leaving the environment. This is just as true for public facing services like storage, app services, and SQL as it is for internal facing services with sensitive data.

**Mitigation**: Traditionally Data Loss Prevention (DLP) techniques have been implemented in the enterprise at the edge of an organization, using tools such as SSL-decrypted proxies. The challenge with this architecture when it comes to sandbox environments, is that it limits the network integration so as to ensure existing DLP technologies continue to function. Moving (or layering) DLP technologies to the device, allows for detection of data exfiltration to not require a "choke point". Using a tool like Microsoft 365 DLP for Endpoint Learn about Endpoint data loss prevention - Microsoft Purview (compliance) | Microsoft Learn it is possible to detect and prevent the upload.

### Cost

**Overview**: Running a sandbox environment in the cloud can be expensive, especially if it is not properly managed and resources are left running when not in use.

**Mitigation**: When running any cloud environment (Production or Sandbox) cost controls should always be put in place at the start of the environment build. Tools that can be used for cost protection include:

- Azure Cost Management allows for visibility into ongoing cloud costs, as well as automation in notifying users/groups of spend alerts Optimize your cloud investment with Cost Management - Microsoft Cost Management | Microsoft Learn
- Native tools for Start/Stop VMs exist within Azure. This can be useful for both workload running within sandbox, as well as jump boxes in Production (should that access model be chosen) Start/Stop VMs v2 overview | Microsoft Learn
- When creating RGs it's possible to define tags that contain an "expiration date", using this, along with automation in LogicApps/Azure Automation resources can be cleaned up using Delete resource group and resources - Azure Resource Manager | Microsoft Learn

### Environment mismatch

**Overview**: Developers may assume that the sandbox environment is a perfect replica of the production environment, leading to issues when the code is deployed in production.

**Mitigation**: An organization can mitigate the risk of this by deploying a mirror of the production environment into sandbox for centralized services, such as centralized firewalls and Azure policies. Whilst the technology can be the same, organizations should ensure they don’t impede flexibility of the sandbox environment with controls that can either prevent reasonable functionality, or in the event a developer needs to test a previously unused feature, the process to enabling that feature should not be as rigorous as Production. 

### Misconfigured resources

**Overview**: Developers might accidentally misconfigure resources in the sandbox environment, leading to issues that could have been avoided if the configuration had been done correctly in the first place.

**Mitigation**: Azure Policy should be deployed from the outset to govern the use of the Sandbox environment. Policies can be used to govern financial, operational and security misconfigurations. Putting in automation practices in place to provide a fundamental foundation environment can also reduce risk of misconfiguration.

### Audit Logging

**Overview**:  It is important from a security perspective to ensure audit logging from any sandbox environment is retained.

**Mitigation**:  An Azure policy is deployed that sets a diagnostic setting on all subscriptions in the innovation sandbox management group to send all diagnostic logs to a Log Analytics Workspace. This Log Analytics Workspace is dedicated to all sandbox environments.

## Sandbox Architectural Scenarios

The following scenarios can be applied to most enterprises. Additional controls may be necessary for scenarios in highly regulated industries, government deployments, sovereign cloud deployments, or other similar scenarios.

In many cases you will want to isolate sandboxes into a management group structure.  Following the Cloud Adoption framework management group structure, this solution could look something like this:

insert image

### Scenario: Sandbox with strict requirements for public network egress

#### Customer Profile

Given that regulated industries typically have strict requirements regarding public network egress, the reference architecture below denotes a backhaul of all traffic from any of the sandbox subscriptions to on-premises, where network inspection and filtering can be performed.

The isolation boundary between the user (or any production corporate asset) is defined as the points at which users (or services from production) can communicate with a resource in any of the sandbox subscriptions. In this architecture, users can interact with resources deployed in the sandbox subscriptions through private endpoints instantiated on the production side of the isolation boundary, connected to a given resource in any of the sandbox subscriptions. This design ensures that users have controlled access while minimizing the fallout to production if an event occurs in any of the sandbox subscriptions.

Name resolution for the sandbox resources is managed by Azure DNS deployed in the Sandbox Hub and is expected to coordinate with production name resolution through the Sandbox Express Route. This connection provides shared services (e.g., name resolution, identity management, security and audit logging, etc.) in Sandbox the ability to coordinate with production resources on-premises or in Azure. Peering from the application Sandbox subscriptions to the Sandbox hub facilitates observability of security events from the subscriptions.

To ensure isolation between production and sandbox resources, users are provided access to the subscription resources through Azure Virtual Desktops or Jump Hosts deployed in a designated subscription located on the production side of the isolation boundary. Network and Role-Based Access controls can be configured at the subscription level to ensure least privilege access. An additional option in this scenario is to deploy jump boxes in each sandbox to control access to the sandbox services.  Special consideration would need to be taken to make sure data cannot be pulled from the environment directly through the jump host connection (For Example RDP copy/paste or printing, or local drive mapping).  

Data ingress would typically be controlled by inbound only Private Endpoints to a private storage account, or other service. 

This scenario also allows for shared sandbox services such as firewalls, internet egress for things like AKS Images, proxy services, domain controllers, etc. Special care needs to be taken in routing, and FW access rules.  

#### Architectural Components

#### Considerations

The architecture design below is a starting solution that can be modified based on customer need or access philosophy. For example, the jump hosts could be windows / Linux host, or Azure Virtual Desktop hosts, or Private Endpoints that connect directly to a jump host in the sandbox. Customers may also choose to provide a separate network path (ER or VPN) for connections to on-premises resources.  

### Scenario: Sandbox Network Egress over Existing Production Networks

#### Customer Profile

Like the scenario above, access to and from the environment is controlled through jump boxes, or VMs jump boxes within each sandbox environment. However, in this scenario, sandbox access can be given to internal resources and locked down.

Name resolution for the sandbox resources is managed by Azure DNS deployed in the Sandbox Hub and is expected to coordinate with production name resolution through the Sandbox Express Route. This connection provides shared services (e.g., name resolution, identity management, security, and audit logging, etc.) in Sandbox the ability to coordinate with production resources on-premises or in Azure. Peering from the application Sandbox subscriptions to the Sandbox hub facilitates observability of security events from the subscriptions.

To ensure isolation between production and sandbox resources, users are provided access to the subscription resources through Azure Virtual Desktops or Jump Hosts deployed in a designated subscription located on the production side of the isolation boundary. Network and Role-Based Access controls can be configured at the subscription level to ensure least privilege access. An additional option in this scenario is to deploy jump boxes in each sandbox to control access to the sandbox services.  Special consideration would need to be taken to make sure data cannot be pulled from the environment directly through the jump host connection (For Example RDP copy/paste or printing, or local drive mapping).  

#### Architectural Components

#### Considerations

Data ingress would typically be controlled by inbound only Private Endpoints to a private storage account, or other service. However, in this scenario you can also provide network egress to on-prem resources. Special consideration should be taken to control egress to the internet from these environments.
