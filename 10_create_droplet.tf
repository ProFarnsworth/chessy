## Create a chess server ##
#
resource "digitalocean_droplet" "chess" {
  image  = "ubuntu-18-04-x64"
  name   = "chess-1"
  region = "nyc1"
  size   = "s-1vcpu-1gb"
  ssh_keys = ["2732250","2732251"]
  #ssh_keys = [< found from curl command >]


  provisioner "remote-exec" {
    connection {
      user = "root"
      type = "ssh"
      private_key = "${file(var.pvt_key)}"
      timeout = "1m"
      host = "${digitalocean_droplet.chess.ipv4_address}"
  }  

  inline = [
    #"export PATH=$PATH:/usr/bin",
    "export PUBFILE=\"${file(var.pub_key)}\"",
    "sed -i '0,/#Port 22/s//Port 22/' /etc/ssh/sshd_config",
    "echo 'AllowUsers root <username>' >> /etc/ssh/sshd_config",
    "sed -i '0,/.*PermitRootLogin.*/s//PermitRootLogin without-password/g' /etc/ssh/sshd_config",
    "useradd -m kumita -U",
    "usermod -a -G sudo kumita; sleep 1",
    "sudo su kumita -c 'mkdir ~/.ssh/'; sleep 1",
    "sudo su kumita -c 'touch ~/.ssh/authorized_keys'; sleep 1",
    "echo \"<username>:$PASSWORD\" | chpasswd",
    "sed -i 's/.*chpasswd.*//g' ~/.bash_history",
    "echo \"$PUBFILE\" >> /home/kumita/.ssh/authorized_keys",
    "service ssh restart",
    ]
 }
  provisioner "local-exec" {
    command     = "ansible-playbook -i ${digitalocean_droplet.chess.ipv4_address}, -u root -e 'ansible_python_interpreter=/usr/bin/python3' --private-key ${var.pvt_key} 50_main_ansible.yml"
  }
}

output "Public_ip" {
  value = digitalocean_droplet.chess.ipv4_address
}

output "Name" {
  value = digitalocean_droplet.chess.name
}

