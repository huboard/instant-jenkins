ENV['VAGRANT_DEFAULT_PROVIDER'] = 'aws'

Vagrant.configure("2") do |config|
  access_key_id = File.read('.vagrant_key_id').chomp
  secret_access_key = File.read('.vagrant_secret_access_key').chomp
  keypair = File.read('.vagrant_keypair_name').chomp

  config.vm.box = 'dummy'

  config.vm.provision 'puppet' do |pp|
    pp.module_path = 'modules'
    pp.manifest_file = 'vagrant.pp'
  end

  config.vm.define(:jenkinsmaster) do |node|
    node.vm.provider :aws do |aws, override|
      aws.access_key_id = access_key_id
      aws.secret_access_key = secret_access_key
      aws.keypair_name = keypair

      # Ensuring that our machines hostname is "correct" so Puppet will apply
      # the right resources to it
      aws.user_data = "#!/bin/sh
echo 'vagrant-jenkinsmaster' > /etc/hostname;
hostname 'vagrant-jenkinsmaster';"

      aws.tags = {
        :Name => :jenkinsmaster
      }

      # Ubuntu LTS 12.04 in us-west-2 with Puppet installed from the Puppet
      # Labs apt repository
      aws.ami = 'ami-665e3756'
      aws.region = 'us-west-2'

      override.ssh.username = "ubuntu"
      override.ssh.private_key_path = File.expand_path('~/.ssh/id_rsa')
    end
  end
end

# vim: ft=ruby
