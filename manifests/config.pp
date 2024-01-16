class teamcity::agent::config($master_url, $agent_name) {

  $required_properties = {
    'serverUrl' => $ServerUrl,
    'name'      => $agent_name,
  }

  # configure buildAgent.properties
  create_ini_settings(
    { '' => $required_properties },
    { 'path' => "/opt/teamcity_agent_${agent_name}/conf/buildAgent.properties" }
  )

  file { '/etc/profile.d/teamcity.sh':
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template("${module_name}/teamcity-profile.erb"),
  }
}
