# Deploy an Azure resource group and virtual network using public git modules.
# Sources pin to main branch as no tags/releases are published yet.

data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

module "resource_group" {
  source      = "github.com/michielvha/terraform-azurerm-resource-group?ref=main"
  project     = "landingzone"
  location    = "westeurope"
  environment = "production"
}

module "networking" {
  source = "github.com/michielvha/terraform-azurerm-networking?ref=main"

  resource_group = module.resource_group.resource_group
  environment    = module.resource_group.environment
  address_space  = ["10.224.0.0/12"]

  subnets = {
    kubernetes = {
      address_prefixes  = ["10.224.0.0/16"]
      service_endpoints = ["Microsoft.Storage", "Microsoft.ContainerRegistry", "Microsoft.KeyVault"]

      nsg_rules = {
        allow_ssh = {
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "22"
          source_address_prefix      = "10.224.0.0/16"
          destination_address_prefix = "*"
        }

        allow_k8s_api = {
          priority                   = 110
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "6443"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        }

        allow_http = {
          priority                   = 120
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "80"
          source_address_prefix      = "Internet"
          destination_address_prefix = "*"
        }

        allow_https = {
          priority                   = 130
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "443"
          source_address_prefix      = "Internet"
          destination_address_prefix = "*"
        }

        allow_kubelet = {
          priority                   = 140
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "10250"
          source_address_prefix      = "10.224.0.0/16"
          destination_address_prefix = "*"
        }

        allow_nodeports = {
          priority                   = 150
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_ranges    = ["30000-32767"]
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        }

        allow_outbound = {
          priority                   = 100
          direction                  = "Outbound"
          access                     = "Allow"
          protocol                   = "*"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        }
      }
    }
  }

  custom_tags = {
    workload = "kubernetes"
  }
}
