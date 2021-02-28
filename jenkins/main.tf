# this file is used to call the jenkins install script

data "terraform_remote_state" "c_i_c_d" {
  backend = "remote"
  config = {
    organization = "c-i-c-d"
    workspaces = {
      name = "azure"
    }
  }
}

resource "null_resource" "jenkins_configure" {

  # move bash script to Jenkins
  provisioner "file" {
    source      = "scripts/0.0.1.jenkins_install.sh"
    destination = "~/0.0.1.jenkins_install.sh"

    connection {
      type     = "ssh"
      user     = "bobouser"
      private_key = var.ssh_private_key
      host     = data.terraform_remote_state.c_i_c_d.outputs.jenkins_ip
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
      host     = data.terraform_remote_state.c_i_c_d.outputs.jenkins_ip
    }
  }
}