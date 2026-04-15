module "rg" {
  source  = "Azure/avm-res-resources-resourcegroup/azurerm"
  version = "~> 0.2.0"

  name     = var.resource_group_name
  location = var.location
}

module "vnet" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "~> 0.7.0"

  name                = var.vnet_name
  location            = var.location
  resource_group_name = module.rg.name

  address_space = ["10.0.0.0/16"]

  subnets = {
    subnet1 = {
      name           = var.subnet_name
      address_prefix = "10.0.1.0/24"
    }
  }
}

module "nsg" {
  source  = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version = "~> 0.3.0"

  name                = "automation-nsg"
  location            = var.location
  resource_group_name = module.rg.name

  security_rules = {
    ssh = {
      name                       = "Allow-SSH"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  subnet_id                 = module.vnet.subnets["subnet1"].resource_id
  network_security_group_id = module.nsg.resource_id
}

module "vm" {
  source  = "Azure/avm-res-compute-virtualmachine/azurerm"
  version = "~> 0.20.0"

  name                = var.vm_name
  location            = var.location
  resource_group_name = module.rg.name
  os_type             = "Linux"
  sku_size            = "Standard_B1s"
  zone                = null

  account_credentials = {
    admin_credentials = {
      username                           = var.admin_username
      # When an SSH public key is supplied use key auth; otherwise fall back to
      # auto-generated password auth. Password auth avoids azurerm 4.x
      # plan-time SSH-key format validation on the module-internal tls_private_key
      # (whose value is "known after apply" on first plan).
      ssh_keys                           = var.ssh_public_key != null ? [var.ssh_public_key] : []
      generate_admin_password_or_ssh_key = var.ssh_public_key == null
    }
    password_authentication_disabled = var.ssh_public_key != null
  }

  network_interfaces = {
    network_interface_1 = {
      name = "automation-nic"
      ip_configurations = {
        ip_configuration_1 = {
          name                          = "automation-nic-ipconfig1"
          private_ip_subnet_resource_id = module.vnet.subnets["subnet1"].resource_id
        }
      }
    }
  }

  os_disk = {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
