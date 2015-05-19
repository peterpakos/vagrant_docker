# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

	HOST_NAME = "docker"
	IP_ADDR = "192.168.0.11"

	config.vm.box = "puppetlabs/centos-6.6-64-puppet"
	config.vm.synced_folder "../../git/foreman-environments/puppet-common", "/puppet"
  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 2
  end
  config.vm.define HOST_NAME do |node|
    node.vm.hostname = HOST_NAME
    node.vm.network "private_network", ip: IP_ADDR

$script = <<SCRIPT
echo "#{IP_ADDR} #{HOST_NAME}" >> /etc/hosts
groupadd docker
gpasswd -a vagrant docker
cp /vagrant/files/.ssh/id_rsa* /vagrant/files/.ssh/config /home/vagrant/.ssh/
chmod 0600 /home/vagrant/.ssh/*
chown vagrant:vagrant /home/vagrant/.ssh/*
cp -r /vagrant/files/.ssh /root/
chmod 700 /root/.ssh
chmod 600 /root/.ssh/*
rpm -qa | grep -q epel || rpm -i http://epel.check-update.co.uk/6/i386/epel-release-6-8.noarch.rpm
yum -y install htop nmap rsync augeas docker-io bash-completion
yum -y remove postfix
yum -y update
augtool -s set /files/etc/puppet/puppet.conf/main/disable_warnings deprecations
augtool -s set /files/etc/ssh/sshd_config/AddressFamily inet && service sshd restart
for i in rpcbind nfslock; do service $i stop; chkconfig $i off; done
service docker start
test -f /vagrant/Dockerfile && docker build -t centos:mine /vagrant/
SCRIPT

    node.vm.provision "shell", inline: $script
#    node.vm.provision "puppet" do |puppet|
#      puppet.module_path    = "../../git/foreman-environments/puppet-common"
#      puppet.manifests_path = "puppet/manifests"
#      puppet.manifest_file  = "default.pp"
#      puppet.options        = "--disable_warnings deprecations"
#    end
  end
end
