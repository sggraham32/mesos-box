# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
require './lib/parse_cluster_yml'

base_dir = File.expand_path(File.dirname(__FILE__))
cluster = YAML.load_file(File.join(base_dir, "cluster.yml"))
nodes = parse_clsuter_yml(cluster)

Vagrant.configure(2) do |config|

  # If mesos-box.box does not exist, cd create-base-box and run: bash scripts/create-box.sh
  config.vm.box = "mesos-box"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder ".", "/host"

  end
end
