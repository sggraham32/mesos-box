# -*- mode: ruby -*-
# vi: set ft=ruby :

def parse_clsuter_yml(cluster_yml)
  mesos_version = cluster_yml['mesos_version']
  cluster_name = cluster_yml['cluster_name']
  
  master_n = cluster_yml['master_n']
  master_mem = cluster_yml['master_mem']
  master_cpu = cluster_yml['master_cpu']
  master_ipbase = cluster_yml['master_ipbase']
  
  worker_n = cluster_yml['worker_n']
  worker_mem = cluster_yml['worker_mem']
  worker_cpu = cluster_yml['worker_cpu']
  worker_ipbase = cluster_yml['worker_ipbase']
  zk_ipbase = cluster_yml['zk_ipbase']
  zk_instance_type = cluster_yml['zk_instance_type']
 
  master_infos = (1..master_n).map do |i|
                   { :hostname => "master#{i}",
                     :ip => master_ipbase + "#{10+i}",
                     :mem => master_mem,
                     :cpu => master_cpu,
                   }
                 end
  worker_infos = (1..worker_n).map do |i|
                   { :hostname => "worker#{i}",
                     :ip => worker_ipbase + "#{10+i}",
                     :mem => worker_mem,
                     :cpu => worker_cpu,
                   }
                 end

  return { :master => master_infos, :worker=>worker_infos }
end