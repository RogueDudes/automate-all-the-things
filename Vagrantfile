VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'hashicorp/precise64'

  config.vm.boot_timeout = 3600

  config.vm.define :master do |master|
    master.vm.hostname = 'rogue-vm'
    master.vm.network :private_network, ip: '192.168.3.25'
  end

  config.vm.provider :virtualbox do |virtualbox|
    virtualbox.customize ['modifyvm', :id, '--memory', '1024', '--natdnshostresolver1', 'on']
  end

  # Enable NFS synced folders.
  config.vm.synced_folder '.', '/vagrant', type: 'nfs'

  # Use Ansible for provisioning.
  config.vm.provision :ansible do |ansible|
    ansible.inventory_path = 'provisioning/ansible/inventory/vagrant.ini'
    ansible.playbook = 'provisioning/ansible/app.yml'
    ansible.host_key_checking = false
  end

  # Provision the machine with puppet. If you need any more debug information,
  # pass `DEBUG=1` as an environmental variable to `vagrant up`.
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = 'provisioning/puppet/manifests'
    puppet.module_path    = ['provisioning/puppet/modules', 'provisioning/puppet/vendor']
    puppet.options        = '--verbose --debug' if ENV['DEBUG']
  end
end


# vi: set ft=ruby ts=2 sts=2 sw=2 :
