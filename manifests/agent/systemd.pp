class teamcity::agent::systemd{

  $agent_dir = $::teamcity::agent_dir
  $agent_name = $::teamcity::agent_name

  $start_command        = "${use_agent_path}/bin/agent.sh run"
  $stop_command         = "${use_agent_path}/bin/agent.sh stop"
  $kill_command         = "${use_agent_path}/bin/agent.sh stop force"
  $service_description  = "Teamcity build agent '${agent_name}'"


  file { "/lib/systemd/system/teamcity-agent-${agent_name}.service":
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template("${module_name}/build-agent-service.erb"),
    notify  => Exec['systemd_reload'],
  }->
  exec { 'systemd_reload':
    command     => '/bin/systemctl daemon-reload',
    refreshonly => true,
  }->
  file { '/etc/init.d/build-agent':
    ensure  => absent,
  }->
  # This script is intended to be run manually after the installation
  file { "${agent_dir}/first-run.sh":
    ensure  => 'file',
    owner   => 'teamcity',
    group   => 'teamcity',
    mode    => '0755',
    content => template("${module_name}/teamcity-first-run.erb")
  }->
  exec {'first-run':
    command => "${agent_dir}/first-run.sh",
    unless => "/usr/bin/test -f ${agent_dir}/first-run.lock"
  }->
  service { "teamcity-agent-${agent_name}":
    name       => "teamcity-agent-${agent_name}.service",
    ensure     => 'running',
    enable     => 'true',
    hasstatus  => true,
    hasrestart => true,
    provider   => 'systemd',
    require    => Exec['systemd_reload'],
  }

}
