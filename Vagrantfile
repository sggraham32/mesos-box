# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'json'
require './lib/gather_zk_ips'

base_dir = File.expand_path(File.dirname(__FILE__))
json_str = File.read(File.join(base_dir, "cluster.json"))
cluster = JSON.parse(json_str)

#prior to configuration, collect the ips of the zookeeper nodes into a comma separated string
zk_ips = gather_zk_ips(cluster)
zk_id = 1

Vagrant.configure(2) do |config|

  # If mesos-box.box does not exist, cd create-base-box and run: bash scripts/create-box.sh
  config.vm.box = "mesos-box"

  # Share an additional folder to the guest VM. 
  config.vm.synced_folder ".", "/host"
  
  cluster['masters'].each_with_index do |master, i|

    config.vm.define master['hostname'] do |cfg|
      cfg.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", master['mem'], "--cpus", master['cpus'] ]
        vb.name = 'mesos-box-' + master['hostname']
      end
      
      cfg.vm.hostname = master['hostname']
      cfg.vm.network "private_network", ip: cluster['master_ipbase']+"#{10+i}"
      
      cfg.vm.provision "shell" do |s|
        s.path = "scripts/stop_all_services.sh"
      end
      
      master['run'].each do |component|
        script_name = "scripts/configure_"+component+".sh"
        
        case component
        when "zookeeper"
          puts 'Configuring zookeeper...'
          cfg.vm.provision "shell" do |s|
            s.path = script_name
            s.args = [zk_id, zk_ips]
          end
          zk_id = zk_id + 1
        when "master"
          puts 'Configuring mesos-master...'
          cfg.vm.provision "shell" do |s|
            s.path = script_name
          end
		when "marathon"
		  puts 'Configuring marathon...'
          cfg.vm.provision "shell" do |s|
            s.path = script_name
          end
        when "chronos"
          puts 'Configuring chronos...'
          cfg.vm.provision "shell" do |s|
            s.path = script_name
          end
        else
          puts 'Ignoring component' 
        end
      end
    end
  end
end
