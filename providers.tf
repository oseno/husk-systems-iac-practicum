provider "azurerm" {
  features {} # enables modern azure api endpoints
  # tells open how to authenticate 
  # (defaults to using credentials from 'az login')
}
