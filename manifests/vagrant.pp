node default {
  include stdlib
  include firewall

  notice("Hello from ${hostname}")

  firewall {
    '000 accept all icmp':
      proto   => 'icmp',
      action  => 'accept';

    '001 accept all to lo interface':
      proto   => 'all',
      iniface => 'lo',
      action  => 'accept';

    '002 accept related established rules':
      proto   => 'all',
      ctstate => ['RELATED', 'ESTABLISHED'],
      action  => 'accept';

    '100 allow ssh access':
      port   => [22],
      proto  => tcp,
      action => accept;

    '999 drop all':
      proto   => 'all',
      action  => 'drop';
  }
}

node /^.*jenkinsmaster$/ inherits default {
  apt::source { 'puppetlabs':
    location   => 'http://apt.puppetlabs.com',
               repos      => 'main',
               key        => '4BD6EC30',
               key_server => 'pgp.mit.edu',
  }
  class {
    'apt':
      always_apt_update => true;

    'jenkins':
      configure_firewall => false;
  }

  include jenkins_config::jenkins::plugin::git
  include jenkins_config::jenkins::plugin::rbenv

  jenkins::plugin {
    'copyartifact':;
    's3':;
  }

  Package {
    require => Class['apt']
  }
  $databases = ["huboard_enterprise_dev", "huboard_enterprise_test"]
  $users = ["jenkins", "ubuntu"]

  class { 'postgresql::globals':
    version             => '9.3',
    manage_package_repo => true,
    encoding            => 'UTF8',
    } ->
    class { 'postgresql::server': } ->
    class { 'postgresql::lib::devel': }

    postgresql::server::pg_hba_rule { 'local-users-get-everything':
      type        => 'local',
      database    => 'all',
      user        => 'all',
      auth_method => 'trust',
      order       => '0001',
    }
    postgresql::server::pg_hba_rule { 'local-host-connections-get-everything':
      type        => 'host',
      database    => 'all',
      user        => 'all',
      address     => '127.0.0.1/32',
      auth_method => 'trust',
      order       => '0001',
    }
    postgresql::server::database { $databases:
    }
    postgresql::server::role { $users:
      superuser     => true,
      createdb      => true,
      createrole    => true,
    }
}
