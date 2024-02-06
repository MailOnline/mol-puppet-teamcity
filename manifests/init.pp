class teamcity (
  $agent_name = $teamcity::params::agent_name,
  $agent_user = $teamcity::params::agent_user,
  $agent_user_home = $teamcity::params::agent_user_home,
  $agent_group = $teamcity::params::agent_group,
  $server_url              = $teamcity::params::server_url,
  $agent_dir               = $teamcity::params::agent_dir,
  $service_ensure          = $teamcity::params::service_ensure,


  $service_enable          = $teamcity::params::service_enable,


  $teamcity_agent_mem_opts = $teamcity::params::teamcity_agent_mem_opts,
  $launcher_wrapper_conf   = $teamcity::params::launcher_wrapper_conf,
  $custom_properties       = $teamcity::params::custom_properties,
) inherits ::teamcity::params{


 class {'teamcity::agent::install':} ->
 class {'teamcity::agent::config':} ->
 class {'teamcity::agent::systemd':}
}
