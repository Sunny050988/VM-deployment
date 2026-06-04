
# refrence the existing resource group  

data "azurerm_resource_group" "rg" {
  name     = "rg-vwan-aue"
}

# refrence the existing virtual network

data "azurerm_virtual_network" "vnet" {
  name                = "prod-vnet"
  resource_group_name = data.azurerm_resource_group.rg.name
  
}
# create a subnet within the existing virtual network

resource "azurerm_subnet" "vm_subnet" {
  name                 = "VM-subnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.1.4.0/24"]

}
#network interface for the virtual machine
resource "azurerm_network_interface" "nic" {
  name                = "dc01"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm_subnet.id
    private_ip_address_allocation ="Dynamic"
  }
}       


#create a Virtual Machine within the resource group
resource "azurerm_windows_virtual_machine" "vm" {
    name                = "DC-01"
    computer_name       = "DC-01"
    resource_group_name = data.azurerm_resource_group.rg.name
    location            = data.azurerm_resource_group.rg.location
    size                = "Standard_D2s_v3"
    admin_username      = "Web"
    admin_password      = "Login@053188"
    network_interface_ids = [
      azurerm_network_interface.nic.id,
    ]

    os_disk {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS" 
        disk_size_gb         = 128 
        name                 = "DC-01-osdisk"
        

    }

    source_image_reference {
        publisher = "MicrosoftWindowsdesktop"
        offer     = "windows-11"
        sku       = "win11-23h2-ent"
        version   = "22631.6649.260207"
    }
}   



