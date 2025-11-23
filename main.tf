terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# 1. DATA BLOCK: Look up your EXISTING Resource Group
data "azurerm_resource_group" "existing_rg" {
  name = "RG1"
}

# 2. DATA BLOCK: Look up your EXISTING App Service Plan
data "azurerm_service_plan" "existing_plan" {
  name                = "ASP-RG1-84b7"
  resource_group_name = data.azurerm_resource_group.existing_rg.name
}

# 3. RESOURCE BLOCK: Create the NEW Web App
resource "azurerm_windows_web_app" "test_app" {
  # CHANGE THIS NAME to something unique (e.g., add your name + numbers)
  name                = "webapp-test-sathish-002" 
  
  # Use properties from the existing resources found above
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  location            = data.azurerm_service_plan.existing_plan.location
  service_plan_id     = data.azurerm_service_plan.existing_plan.id

  site_config {
    always_on = false
    
    application_stack {
      current_stack  = "dotnet"
      dotnet_version = "v6.0" # Adjust version if needed (e.g., v4.0)
    }
  }

  app_settings = {
    "Environment" = "Test"
    "CreatedBy"   = "Terraform"
  }

  tags = {
    Lab = "Azure app services"
  }
}