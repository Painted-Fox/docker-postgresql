# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version.
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "phusion/ubuntu-14.04-amd64"

  config.vm.provision "docker", images: ["paintedfox/postgresql"] do |d|
    d.run "paintedfox/postgresql",
          args: "--name=postgresql -v /vagrant/path/to/your/folder:/var/lib/postgresql -p 5432:5432 ",
          daemonize: true
  end

  config.vm.network "forwarded_port", guest: 5432, host: 5432
end
