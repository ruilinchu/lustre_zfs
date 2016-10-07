# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  (1..3).each do |i|
    config.vm.define "server#{i}" do |node|
      node.vm.box = "geerlingguy/centos7"
      node.vm.hostname = "server#{i}"
      node.vm.network :private_network, ip: "10.0.15.1#{i}"
      node.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
        vb.customize ["storagectl", :id, "--add", "sata", "--name", "SATA" , "--portcount", 4, "--hostiocache", "on"]
        (0..2).each do |d|
          vb.customize ['createhd',
                        '--filename', "osd-disk-#{i}-#{d}",
                        '--size', '4096']
          # Controller names are dependent on the VM being built.
          # It is set when the base box is made in our case box-cutter/centos71.
          # Be careful while changing the box.

          vb.customize ['storageattach', :id,
                        '--storagectl', 'SATA',
                        '--port', d,
                        '--device', 0,
                        '--type', 'hdd',
                        '--medium', "osd-disk-#{i}-#{d}.vdi"]
        end
        
      end
    end
  end

  (1..2).each do |i|
    config.vm.define "client#{i}" do |node|
      node.vm.box = "geerlingguy/centos7"
      node.vm.hostname = "client#{i}"
      node.vm.network :private_network, ip: "10.0.15.2#{i}"
      node.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
        vb.customize ["storagectl", :id, "--add", "sata", "--name", "SATA" , "--portcount", 4, "--hostiocache", "on"]
      end
    end
  end

end
