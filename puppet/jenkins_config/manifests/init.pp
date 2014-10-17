class jenkins_config {
  
  class jenkins::plugin::git (
    $manage_config = true,
    $git           = hiera_hash(jenkins_config::jenkins::plugin::git::git, { 
      name => "huboardci", 
      email => "huboard@huboard.com",
    }),
    $config_filename = "hudson.plugins.git.GitSCM.xml",
    $config_content = undef,
    ) {
  
    if $config_content == undef {
      $real_content = template("jenkins_config/hudson.plugins.git.GitSCM.xml.erb")
    } else {
      $real_content = $config_content
    }

    jenkins::plugin {
      'scm-api':;
      'git-client':;
    } 
    -> jenkins::plugin {'git':
      config_content => $real_content,
      config_filename => $config_filename,
      manage_config => $manage_config,
    }



    file { '/var/lib/jenkins/.ssh':
      ensure => directory,
      owner => "jenkins",
    } 
    -> file { "/var/lib/jenkins/.ssh/id_rsa":
      ensure => present,
      owner => "jenkins",
      source => "puppet:///modules/jenkins_config/instant-jenkins.pem",
    }
    -> file { "/var/lib/jenkins/.ssh/id_rsa.pub":
      ensure => present,
      owner => "jenkins",
      source => "puppet:///modules/jenkins_config/instant-jenkins.pub",
    }
    -> file { "/var/lib/jenkins/.ssh/known_hosts":
      ensure => present,
      owner => "jenkins",
      source => "puppet:///modules/jenkins_config/known_hosts",
    }

    package {
      'git': ensure => latest;
      'autoconf': ensure => latest;
      'bison': ensure => latest;
      'build-essential': ensure => latest;
      'libssl-dev': ensure => latest;
      'libyaml-dev': ensure => latest;
      'libreadline6-dev': ensure => latest;
      'zlib1g-dev': ensure => latest;
      'libncurses5-dev': ensure => latest;
    }
  }

  class jenkins::plugin::rbenv {
    jenkins::plugin {
      "ruby-runtime": ;
      "rbenv": ;

    }

  }
}
