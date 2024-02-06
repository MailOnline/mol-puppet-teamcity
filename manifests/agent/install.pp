class teamcity::agent::install
{
  $download_url = "${::teamcity::server_url}/update/buildAgent.zip"
  $download_path = "/tmp/teamcity.zip"
  $destination_path = $::teamcity::agent_dir
  file {$destination_path:
    ensure => 'directory',
    group => 'teamcity',
    owner => 'teamcity'
   } ->
    archive { "teamcity-agent":
      ensure          => present,
      path            => "/tmp/teamcityagent.zip",
      extract         => true,
      source          => $download_url,
      extract_path    => $destination_path,
      # because we do mkdir::p before, this would not work with the directory
      creates         => "${destination_path}/bin/agent.sh",
      user            => 'teamcity',
      checksum_verify => false,
      cleanup         => true,
    }

}
