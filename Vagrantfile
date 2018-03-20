# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'
settings = YAML.load_file File.dirname(__FILE__) + '/settings.yml'

Vagrant.configure("2") do |config|
  config.vm.box = "tb7"
  config.vm.box_url = "\\\\172.17.15.173\\share\\tb7.box"
  config.vm.box_check_update = false
  config.vm.hostname = "etu6.org"
  config.vm.define "etu6.org" do |tb|
  end
  config.vm.network "private_network", ip: "192.168.88.88"

  if settings["public"]
      config.vm.network "public_network"
  end

  config.vm.synced_folder settings["workspace"], "/tb",
      create:true, owner: "www", group: "www"

  config.vm.synced_folder ".", "/vagrant",
      create:true, owner: "vagrant", group: "vagrant"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "768"
    vb.cpus = "2"
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
  end

  config.ssh.username = "vagrant"
  config.ssh.password = "vagrant"
  config.ssh.insert_key = false

  config.vm.provision "fpm", type: "shell",
      inline: "/etc/init.d/php-fpm restart", run:"always"
  config.vm.provision "reloadphp", type: "shell",
      inline: "/etc/init.d/php-fpm reload", run:"never"
  config.vm.provision "reloadnginx", type: "shell",
      inline: "/home/vagrant/dotfiles/bin/reload.sh", run:"never"
  config.vm.provision "nginx", type: "shell", inline: <<SHELL
      cp -f /vagrant/nginx.conf /usr/local/nginx/conf/nginx.conf
      /home/vagrant/dotfiles/bin/reload.sh
SHELL

end
