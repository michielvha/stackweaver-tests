# Azure OIDC Configuration Tests
# https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/azure_oidc_configuration

resource "tfe_azure_oidc_configuration" "test" {
  organization    = var.organization
  client_id       = "d8988acf-d261-49bc-8ae5-7e6df9ca06a1"
  subscription_id = "d4dee7d6-6053-45f0-ace0-af83e384e552"
  tenant_id       = "434b720d-f80a-4de1-aad9-d29e655c493c"
}

output "azure_oidc_configuration_id" {
  value = tfe_azure_oidc_configuration.test.id
}
