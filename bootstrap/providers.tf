terraform {
  required_version = ">= 1.9"
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.70"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "d4dee7d6-6053-45f0-ace0-af83e384e552"
}

provider "azuread" {
}

provider "tfe" {
  # Authentication via terraform login
}