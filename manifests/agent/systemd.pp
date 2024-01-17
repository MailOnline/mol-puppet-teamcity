class teamcity::agent::systemd(
  $agent_name = $title,
  ) {

  $agent_dir = $::teamcity::agent_dir
  $agent_name = $::teamcity::agent_name

  file { "/lib/systemd/system/teamcity-agent-${agent_name}.service':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template("${module_name}/build-agent-service.erb"),
    before  => Service['build-agent.service'],
    notify  => Exec['systemd_reload'],
  }

  exec { 'systemd_reload':
    command     => '/bin/systemctl daemon-reload',
    refreshonly => true,
  }

  service { 'build-agent.service':
    ensure     => 'running',
    enable     => 'true',
    hasstatus  => true,
    hasrestart => true,
    provider   => 'systemd',
    require    => Exec['systemd_reload'],
  }

  file { '/etc/init.d/build-agent':
    ensure  => absent,
  }
}
