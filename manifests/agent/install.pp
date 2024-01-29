class teamcity::agent::install
{
  $download_url = "${::teamcity::server_url}/update/buildAgent.zip"
  $download_path = "/tmp/teamcity.zip"
  $destination_path = $::teamcity::agent_dir


  file {$destination_path:
    ensure => 'directory'
  } ->
  exec{'download_agent':
    command => "/usr/bin/wget ${download_url} -O /tmp/buildAgent.zip",
    unless => "/usr/bin/test -f ${$destination_path}/bin/agent.sh"
  } ->
  exec{'descompress':
    command => "/usr/bin/unzip /tmp/buildAgent.zip",
    cwd => "${destination_path}",
    unless => "/usr/bin/test -f ${$destination_path}/bin/agent.sh",
    notify => Exec['perms']
  } ->
  file{'cleanup':
    path => "/tmp/buildAgent.zip",
    ensure => "absent"
  }->
  exec{'perms':
    command => "/usr/bin/chown ${::teamcity::agent_user}:${::teamcity::agent_group} ${destination_path} -R",
    refreshonly => true
  }
}
