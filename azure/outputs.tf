output "jenkins_ip" {
  value = azurerm_public_ip.bobo-pip[0].ip_address
}
