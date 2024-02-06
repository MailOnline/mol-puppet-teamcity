class teamcity::agent::config
 {
  $agent_dir = $::teamcity::agent_dir
  $agent_name = $::teamcity::agent_name
  $server_url = $::teamcity::server_url
 # config

  exec { "create agent ${agent_name} buildAgent.dist":
    command   => 'cp buildAgent.dist.properties buildAgent.properties',
    cwd       => "${agent_dir}/conf",
    path      => '/usr/bin:/bin',
    unless    => 'test -f buildAgent.properties',
    user      => 'teamcity',
  } ->

  file_line { "agent ${agent_name} server url":
    ensure  => 'present',
    path    => "${agent_dir}/conf/buildAgent.properties",
    line    => "serverUrl=${server_url}",
    match   => '^ *#? *serverUrl *=.*',
  } ->

  file_line { "agent ${agent_name} own port":
    ensure  => 'present',
    path    => "${agent_dir}/conf/buildAgent.properties",
    line    => "ownPort=${port}",
    match   => '^ *#? *ownPort *=.*',
  } ->

  file_line { "agent ${agent_name} own name":
    ensure  => 'present',
    path    => "${agent_dir}/conf/buildAgent.properties",
    line    => "name=${agent_name}",
    match   => '^ *#? *name *=.*',
    before  => Service["teamcity-agent-${agent_name}"],
  }
}
