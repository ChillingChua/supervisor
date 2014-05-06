define supervisor::app (
  $app_name,
  $command,
  $process_group = $title,
  $process_num = 1,
  $processes_start = 1,
  $autostart = false,
  $redirect_stderr = false,
  $stdout_logfile = undef,
  $directory = undef,
  $user = 'root',
  $startsecs = undef,
  $stopwaitsecs = undef,
  $priority = undef,
  $environment = undef,
) {

  $conf_file = "supervisor_${app_name}"
  $service_name = $conf_file
  
  if $processes_num > 0 {
      
      $template_command = regsubst($command, '\.cfg', '%(process_num)d.cfg')
      
      if !($process_name =~ /%(process_num)d/) { 
          $process_name = "${app_name}%(process_num)d"
      } else {
          $process_name = $app_name
      }
  
  } else {
      $process_name = $app_name
  }
  
  file { $conf_file:
    path    => "/etc/supervisor/conf.d/${process_group}.conf",
    ensure  => present,
    content => template('supervisor/supervisor.conf.erb'),
    require => Package['supervisor'],
    notify  => Service['supervisord'],
  }

  service { $service_name:
    ensure     => running,
    path       =>  ['/usr/bin'],
    start      => "supervisorctl start ${process_group}:*",
    restart    => "supervisorctl restart ${process_group}:*",
    stop       => "supervisorctl stop ${process_group}:*",
    #status     => "supervisorctl status | awk '/^${process_name}[: ]/{print \$2}' | grep '^RUNNING$'",
    subscribe  => File[$conf_file], 
    hasrestart => true, 
    hasstatus  => false,
    provider   => base
  }
}
