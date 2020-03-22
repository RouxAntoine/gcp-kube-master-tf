resource "google_compute_instance" "vm_instance" {
  name         = "gcp-1"
  machine_type = var.machine_type

  tags = var.kube_master_tags
  metadata_startup_script= ""

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_pub_key_file)}"
  }

  boot_disk {
    source = google_compute_disk.debian-10-30giga.self_link
  }

  network_interface {
    // A default network is created for all GCP projects
    network = data.google_compute_network.vpc_network.self_link

    // permit to obtain public external ip adress
    access_config {
      nat_ip = google_compute_address.external_address.address
    }
  }

  // subsitute regex by value into ssh_config (multiline regex)
  provisioner "local-exec" {
    command = "sed -i '/./{H;$!d} ; x ; s/${var.regex_ssh_config}/${local.value_ssh_config}/' ${var.ssh_config_path}"
  }

  // used to wait compute start
  provisioner "remote-exec" {
    inline = ["sudo apt-get -y update"]
    connection {
      type = "ssh"
      user = var.ssh_user
      host = google_compute_address.external_address.address
      private_key = file(var.ssh_private_key_file)
    }
  }

  // copy local terminfo to remote
  provisioner "local-exec" {
    command = "infocmp -x | ssh -o 'StrictHostKeyChecking=no' -i ${var.ssh_private_key_file} -t ${var.ssh_user}@${google_compute_address.external_address.address} 'cat > \"$TERM.info\" && tic -x \"$TERM.info\"'"
    environment = {
      TERM = var.term_variable
    }
  }

  // copie all script into ./provision/ folder to remote
  provisioner "file" {
    source = var.remote_scripts
    destination = "/tmp"
    connection {
      type = "ssh"
      user = var.ssh_user
      host = google_compute_address.external_address.address
      private_key = file(var.ssh_private_key_file)
    }
  }
  // execute script on remote
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setup_docker.sh",
      "/tmp/setup_docker.sh",
    ]
    connection {
      type = "ssh"
      user = var.ssh_user
      host = google_compute_address.external_address.address
      private_key = file(var.ssh_private_key_file)
    }
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/create_k3d_cluster.sh",
      "/tmp/create_k3d_cluster.sh ${var.cluster_name} ${google_compute_address.external_address.address}",
    ]
    connection {
      type = "ssh"
      user = var.ssh_user
      host = google_compute_address.external_address.address
      private_key = file(var.ssh_private_key_file)
    }
  }

  // retrieve kubectl configuration
  provisioner "local-exec" {
    command = "ssh -o 'StrictHostKeyChecking=no' ${var.ssh_user}@${google_compute_address.external_address.address} 'cat $(k3d get-kubeconfig --name='${var.cluster_name}')' | sed 's/localhost/${google_compute_address.external_address.address}/g' >> ~/.kube/config-gcp-mycluster.kubeconfig.yml"
  }
}

// display public ip adress
output "ip" {
  value = google_compute_address.external_address.address
}