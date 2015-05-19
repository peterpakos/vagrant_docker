# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

	NUM_NODES = 1
	HOSTNAME_PREFIX = "docker"
	IP_ADDR_PREFIX = "192.168.0.1"

	config.vm.box = "puppetlabs/centos-6.6-64-puppet"
	config.vm.synced_folder "../../git/foreman-environments/puppet-common", "/puppet"
  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 2
  end

  (1..NUM_NODES.to_i).each do |i|
    nodeName = HOSTNAME_PREFIX
    ipAddr = IP_ADDR_PREFIX + "#{i}"
    config.vm.define nodeName do |node|
      node.vm.hostname = nodeName
      node.vm.network "private_network", ip: ipAddr

$script = <<SCRIPT
for i in {1..#{NUM_NODES}}; do
  echo "#{IP_ADDR_PREFIX}$i #{HOSTNAME_PREFIX}$i" >> /etc/hosts
done
groupadd docker
gpasswd -a vagrant docker
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
#      node.vm.provision "puppet" do |puppet|
#        puppet.module_path    = "../../git/foreman-environments/puppet-common"
#        puppet.manifests_path = "puppet/manifests"
#        puppet.manifest_file  = "default.pp"
#        puppet.options        = "--disable_warnings deprecations"
#      end
    end
  end
end
