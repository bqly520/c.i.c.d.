# this file is used to call the jenkins install script

resource "null_resource" "example1" {

  # move bash script to Jenkins
  provisioner "file" {
    source      = "scripts/0.0.0.beta_test.sh"
    destination = ""

    connection {
      type     = "ssh"
      user     = "Administrator"
      private_key = ""
    }
  }

  # execute bash script to configure Jenkins
  # provisioner "remote-exec" {
  #   inline = [
  #     "chmod +x /tmp/*sh",
  #     "sudo /tmp/system_setup.sh",
  #     "sudo /tmp/install_docker.sh",
  #     "sudo /tmp/install_kubernetes_packages.sh",
  #     "sudo /tmp/kubeadm_init.sh",
  #     "tail -n2 /tmp/kubeadm_init_output.txt | head -n 1",
  #   ]
  #   connection {
  #     type        = ""
  #     user        = ""
  #     private_key = ""
  #   }
  # }
}