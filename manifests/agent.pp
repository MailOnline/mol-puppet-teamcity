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
  $destination_path = "/opt/teamcity-agent"

  Archive {
    provider => 'wget',
    require => Package['wget']
  }
  file {$destination_path:
    ensure => 'directory'
  }

  archive { $download_path:
    ensure => present,
    source => $download_url,
    extract         => true,
    extract_path    => $destination_path,
    cleanup         => true,
  }

}
