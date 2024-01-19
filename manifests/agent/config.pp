class teamcity::agent::config
 {
  $agent_dir = $::teamcity::agent_dir

  $required_properties = {
    'serverUrl' => $::teamcity::server_url,
    'name'      => $::teamcity::agent_name,
  }

  $custom_properties = $::teamcity::custom_properties

  # configure buildAgent.properties
  $merged_params = merge($required_properties, $custom_properties)
  create_ini_settings(
    { '' => $merged_params },
    { 'path' => "${agent_dir}/conf/buildAgent.properties" }
  )

  # configure launcher/conf/wrapper.conf
  create_ini_settings(
    { '' => $::teamcity::launcher_wrapper_conf },
    { 'path' => "${agent_dir}/launcher/conf/wrapper.conf" }
  )

  file { '/etc/profile.d/teamcity.sh':
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template("${module_name}/teamcity-profile.erb"),
  }
  exec{'perms_after_config':
    command => "/usr/bin/chown ${::teamcity::agent_user}:${::teamcity::agent_group} ${agent_dir} -R"
  }

  # This script is intended to be run manually after the installation
  file { "${agent_dir}/first-run.sh":
    ensure  => 'file',
    owner   => 'teamcity',
    group   => 'teamcity',
    mode    => '0755',
    content => template("${module_name}/teamcity-first-run.erb")
  }
}
