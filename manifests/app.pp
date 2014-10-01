define supervisor::app (
  $app_name,
  $command,
  $process_group = '',
  $process_num = 1,
  $processes_start = 1,
  $autostart = false,
  $autorestart = false,
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
  
  if $process_num {
      
      $template_command = regsubst($command, '\.cfg', '%(process_num)d.cfg')
      
      if !($process_name =~ /%(process_num)d/) { 
          $process_name = "${app_name}%(process_num)d"
      } else {
          $process_name = $app_name
      }
  
  } else {
      $process_name = $app_name
      $template_name = $command
      notify { $process_name: }
      notify { $template_name: }
  }
  
  file { $conf_file:
    path    => "/etc/supervisor/conf.d/${title}.conf",
    ensure  => present,
    content => template('supervisor/supervisor.conf.erb'),
    #require => Package['supervisor'],
    #notify  => Service['supervisord'],
  }

  service { $service_name:
    path       =>  ['/usr/bin'],
    start      => "supervisorctl start ${process_group}:*",
    restart    => "supervisorctl restart ${process_group}:*",
    stop       => "supervisorctl stop ${process_group}:*",
    subscribe  => File[$conf_file], 
    hasrestart => true, 
    hasstatus  => false,
    provider   => base
  }
}
