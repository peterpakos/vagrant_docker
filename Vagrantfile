# -*- mode: ruby -*-
# vi: set ft=ruby :

BOX = "puppetlabs/centos-6.6-64-nocm"
IP = "192.168.33.100"
HOSTNAME = "docker"
SDB_FILE = "sdb.vdi"
SDB_SIZE = 80 * 1024
CORES = 4
RAM = 8192

Vagrant.configure(2) do |config|

  config.ssh.insert_key = false

  config.vm.define HOSTNAME do |host|
    host.vm.box = BOX
    host.vm.network "private_network", ip: IP
    host.vm.hostname = HOSTNAME
  end

  config.vm.provider "virtualbox" do |vb|
    unless File.exist?(SDB_FILE)
      vb.customize ["createhd", "--filename", SDB_FILE, "--size", SDB_SIZE]
      vb.customize ["storagectl", :id, "--name", "SATAController", "--add", "sata"]
    end
    vb.customize ["storageattach", :id, "--storagectl", "SATAController", "--port", 1, "--device", 0, "--type", "hdd", "--medium", SDB_FILE]
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
    vb.customize ["modifyvm", :id, "--cpus", CORES]
    vb.customize ["modifyvm", :id, "--memory", RAM]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end

  config.vm.provision "shell", path: "files/configure-btrfs"
  config.vm.provision "shell", path: "files/bootstrap"

end
