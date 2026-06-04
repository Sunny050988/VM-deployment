
# Create a resource group
resource "azurerm_resource_group" "res0" {
  name     = "rg-vwan-aue"
  location = "Australia East"
}

# virtual network within the resource group
resource "azurerm_virtual_network" "res1" {
  name                = "prod-vnet"
  resource_group_name = azurerm_resource_group.res0.name
  location            = "New Zealand North"
  address_space       = ["10.1.0.0/16"]
  
}
#subnet
resource "azurerm_subnet" "res2" {
  name                 = "prod-subnet"
  resource_group_name  = azurerm_resource_group.res0.name
  virtual_network_name = azurerm_virtual_network.res1.name
  address_prefixes     = ["10.1.1.0/24"]

}
#network interface
resource "azurerm_network_interface" "res3" {
  name                = "res3-nic"
  resource_group_name = azurerm_resource_group.res0.name
  location            = azurerm_resource_group.res0.location
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.res2.id
    private_ip_address_allocation = "Dynamic"
  }
}       


#create a Virtual Machine within the resource group
resource "azurerm_windows_virtual_machine" "res4" {
    name                = "DC-01"
    resource_group_name = azurerm_resource_group.res0.name
    location            = azurerm_resource_group.res0.location
    size                = "Standard_D2s_v3 -- 2 vCPUs, 4 GB RAM"
    admin_username      = "Web"
    admin_password      = "Login@053188"
    network_interface_ids = [
        azurerm_network_interface.res3.id,
    ]

    os_disk {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS" 
        disk_size_gb         = 30  
        name                 = "DC-01-osdisk"
        

    }

    source_image_reference {
        publisher = "MicrosoftWindowsdesktop"
        offer     = "Windows-10"
        sku       = "22H2-pro"
        version   = "Standard_E4ds_v6"
    }
}   



