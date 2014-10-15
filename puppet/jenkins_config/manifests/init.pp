class jenkins_config {
  $git = hiera("git")
  
  jenkins::plugin {
    'scm-api':;
    'git-client': ;
  }

  jenkins::plugin {'git':
    manage_config => true,
    config_filename => "hudson.plugins.git.GitSCM.xml",
    config_content => template("jenkins_config/hudson.plugins.git.GitSCM.xml.erb"),
  }
}
