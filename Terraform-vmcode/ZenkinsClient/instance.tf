# demo instance

resource "azurerm_network_interface" "demo-instance" {
  name                = "${var.prefix}-instance1"
  location            = var.location
  resource_group_name = azurerm_resource_group.demo.name


  ip_configuration {
    name                          = "instance1"
    subnet_id                     = azurerm_subnet.demo-internal-1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.demo-instance.id
  }
}

resource "azurerm_public_ip" "demo-instance" {
  name                = "instance1-public-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.demo.name
  allocation_method   = "Static"
}
resource "azurerm_virtual_machine" "demo-instance" {
  name                  = "${var.prefix}-vm"
  location              = var.location
  resource_group_name   = azurerm_resource_group.demo.name
  network_interface_ids = [azurerm_network_interface.demo-instance.id]
  vm_size               = "Standard_B2s"
  tags                  = var.tags


  # this is a demo instance, so we can delete all data on termination
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk2"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "vmclient"
    admin_username = "vmadmin"
    admin_password = "September@2016"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  provisioner "remote-exec" {
    connection {
      host     = azurerm_public_ip.demo-instance.ip_address
      user     = "vmadmin"
      type     = "ssh"
      password = "September@2016"
    }
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y tree",
      "sudo apt-get install -y python-pip",
      "sudo apt-get install -y maven",
      "sudo apt-get install -y docker*",
      "sudo apt-get install -y apt-transport-https gnupg2 curl",
      "sudo apt-get install openjdk-8-jdk openjdk-8-jre -y",
      "curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -",
      "echo deb https://apt.kubernetes.io/ kubernetes-xenial main | sudo tee -a /etc/apt/sources.list.d/kubernetes.list",
      "sudo apt-get install -y kubectl",
      "sudo apt install -y gnupg2 pass",
      "sudo apt-get install software-properties-common",
      "sudo apt-add-repository ppa:ansible/ansible -y",
      "sudo apt-get update",
      "sudo apt-get install ansible -y",#install Ansible
      "sudo chown -R vmadmin:vmadmin /etc/ansible/",#chnage permissions
      "sudo pip install ansible[azure]",                     #install azure modules 
      "curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash", # for to install Azure CLI
    ]
  }
}

  
