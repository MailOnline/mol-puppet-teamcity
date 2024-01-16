class teamcity::agent(
  $agent_name = $title,
  $master_url = undef,
  $port       = '9090',)
{
  if $master_url == undef {
    fail("Teamcity::Agent[${agent_name}]: Please set \$master_url")
  }
  $download_url = "${master_url}/update/buildAgent.zip"
  $download_path = "/tmp/teamcity.zip"
  $destination_path = "/opt/teamcity_agent_${agent_name}/"


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
    unless => "/usr/bin/test -f ${$destination_path}/bin/agent.sh"
  } ->
  file{'cleanup':
    path => "/tmp/buildAgent.zip",
    ensure => "absent"
  }
}
