resource_group = {
  rg1 = {
    rg_name    = "santan_rg"
    location   = "east us"
    managed_by = "azurerm_user_assigned_identity.test"  # optional
    tags = {
      environment = "dev"
      project     = "terraform-setup"
      costcenter  = "CC-1001"
    }
  }

}

virtual_network = {
  vnet1 = {
    vnet_name     = "santanVnet"
    rg_name       = "santan_rg"
    location      = "east us"
    address_space = ["10.0.0.0/16"]
    dns_servers = ["8.8.8.8", "8.8.4.4"]
    flow_timeout_in_minutes = 10
    tags = {
      environment = "dev"
      project     = "terraform-network"
      owner       = "santan"
    }
  }
}

subnet = {
  subnet1 = {
    subnet_name      = "santansubnet1"
    vnet_name        = "santanVnet"
    rg_name          = "santan_rg"
    address_prefixes = ["10.0.0.0/24"]
    service_endpoints = ["Microsoft.Storage"]
    delegation = [
      {
        name = "delegation1"
        service_delegation = {
          name    = "Microsoft.Web/serverFarms"
          actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
        }
      }
    ]
  }

  subnet2 = {
    subnet_name      = "santansubnet2"
    vnet_name        = "santanVnet"
    rg_name          = "santan_rg"
    address_prefixes = ["10.0.1.0/24"]

    private_endpoint_network_policies     = "Disabled"
    private_link_service_network_policies = "Enabled"
    
    delegation = [
      {
        name = "delegation1"
        service_delegation = {
          name    = "Microsoft.Web/serverFarms"
          actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
        }
      }
    ]
  }
}

public_ip = {
  lbpip = {
    pip_name          = "mehapip1"
    rg_name           = "santan_rg"
    location          = "east us"
    allocation_method = "Static"
    sku               = "Standard"
    idle_timeout_in_minutes = 10
    domain_name_label = "santan-lb"
    zones             = ["1", "2", "3"]
    tags = {
      environment = "dev"
      project     = "loadbalancer"
    }
  }

  bastion_pip = {
    pip_name          = "mehapip2"
    rg_name           = "santan_rg"
    location          = "east us"
    allocation_method = "Static"
    sku               = "Standard"
    domain_name_label = "santan-bastion"
  }

  # natgateway_pip = {
  #   pip_name          = "mehapip3"
  #   rg_name           = "santan_rg"
  #   location          = "east us"
  #   allocation_method = "Static"
  #   sku               = "Standard"
  #   tags = {
  #     environment = "network"
  #     owner       = "santan"
  #   }
  # }
}


network_nic = {
  nic1 = {
    nic_name        = "santannic1"
    location        = "east us"
    rg_name         = "santan_rg"
    ip_config_name  = "internal"
    private_ip_meth = "Dynamic"
    subnet_name     = "santansubent1"
    vnet_name       = "santanVnet"
    enable_accelerated_networking = true
    tags = {
      environment = "dev"
      owner       = "santan"
    }
  }

  nic2 = {
    nic_name        = "santannic2"
    location        = "east us"
    rg_name         = "santan_rg"
    ip_config_name  = "internal"
    private_ip_meth = "Dynamic"
    subnet_name     = "santansubent2"
    vnet_name       = "santanVnet"
    enable_ip_forwarding = true
  }
}


virtual_machine = {
  vm1 = {
    vm_name        = "lbvm1"
    rg_name        = "santan_rg"
    location       = "east us"
    vm_size        = "Standard_F2"
    admin_username = "Santansre"
    admin_password = "Santansre@1234"
    nic_name       = "santannic1"
  }

  vm2 = {
    vm_name        = "lbvm2"
    rg_name        = "santan_rg"
    location       = "east us"
    vm_size        = "Standard_F2"
    admin_username = "Santansre"
    admin_password = "Santansre@1234"
    nic_name       = "santannic2"
  }
}


loadbalancer = {
  lb1 = {
    lb_name           = "TestLoadBalancer"
    location          = "east us"
    rg_name           = "santan_rg"
    frontend_ip_name  = "frontendlbip"
    backend_pool_name = "BackEndAddressPool"
    lb_rule_name      = "newrule1"
    protocol          = "Tcp"
    frontend_port     = 80
    backend_port      = 80
    lb_prob_name      = "lbprob1"
    lb_prob_port      = 80
    pip_name          = "mehapip1"
  }
}

network_nsg = {
  nsg1 = {
    nsg_name = "web-nsg"
    location = "eastus"
    rg_name  = "santan_rg"

    rules = [
      {
        rule_name                  = "allow-ssh"
        priority                   = 100
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        source_port_range           = "*"
        destination_port_range      = "22"
        source_address_prefix       = "*"
        destination_address_prefix  = "*"
      },
      {
        rule_name                  = "allow-http"
        priority                   = 200
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        source_port_range           = "*"
        destination_port_range      = "80"
        source_address_prefix       = "*"
        destination_address_prefix  = "*"
      }
    ]
  }

  nsg2 = {
    nsg_name = "db-nsg"
    location = "eastus"
    rg_name  = "santan_rg"
    rules = [
      {
        rule_name                  = "allow-sql"
        priority                   = 100
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        source_port_range           = "*"
        destination_port_range      = "1433"
        source_address_prefix       = "*"
        destination_address_prefix  = "*"
      }
    ]
  }
}


azure_bastion = {
  bastion1 = {
    bastion_name        = "demo-bastion"
    location            = "eastus"
    rg_name             = "santan_rg"
    vnet_name           = "demo-vnet"
    bastion_subnetname  = "AzureBastionSubnet"
    address_prefixes    = ["10.0.3.0/27"]
    pip_name            = "demo-bastion-pip"
  }
}

sql_data_server = {

  sqldata = {

    sql_server_name = "mssqlserver"
    rg_name         = "santan_rg"
    location        = "east us"
    version         = "12.0"
    userlogin       = "Santansre"
    userpassword    = "Santansre@1234"
    minimum_version = "1.2"
    database_name = "santandb-db"

  }

}



keyvaults = {
  kv-eastus = {
    keyvault_name       = "santan-kv-eastus"
    location            = "East US"
    rg_name         = "santan_rg"
    sku_name            = "premium"
    soft_delete_retention_days = 30
    key_permissions     = ["Create", "Get", "List"]
    secret_permissions  = ["Set", "Get", "Delete", "Recover"]
  }

 
}


aks_clusters = {
  dev = {
    cluster_name       = "aks-dev"
    location           = "eastus"
    rg_name            = "santan_rg"
    dns_prefix         = "devaks"
    kubernetes_version = "1.30.0"
    identity_type      = "SystemAssigned"     

    default_node_pool = {
      name        = "systempool"
      node_count  = 1
      vm_size     = "standard_a2_v2"
    }

    network_profile = {
      network_plugin    = "azure"
      network_policy    = "calico"
      load_balancer_sku = "standard"
    }

    tags = {
      env = "dev"
    }
  }
}


