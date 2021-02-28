# this file is used to call the jenkins install script

resource "null_resource" "example1" {

  # move bash script to Jenkins
  provisioner "file" {
    source      = "scripts/0.0.1.jenkins_install.sh"
    destination = "~/0.0.1.jenkins_install.sh"

    connection {
      type     = "ssh"
      user     = "bobouser"
      #private_key = file("path_to_privatekey")
      private_key = var.ssh_private_key
      host     = var.host_ip
    }
  }

  # execute bash script to configure Jenkins
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/*sh",
      "sudo chmod +x ~/0.0.1.jenkins_install.sh",
      "sudo /bin/sh ~/0.0.1.jenkins_install.sh",
    ]
    connection {
      type     = "ssh"
      user     = "bobouser"
      private_key = var.ssh_private_key
      host     = var.host_ip
    }
  }
}