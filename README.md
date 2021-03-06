Puppet Supervisor
=================

Install and manage apps in supervisord


Usage
=================

Include supervisor class
```puppet
include supervisor
```

Normally you need to use %(process_num)d in the command line to show the porcess number in the process name. The code autmatically adds these, so you just specify the process as if only using a single process. Same with numbered config files, a <config>.cfg will be converted to a <congig>%(process_num)d.

TODO: make the internal renaming of commands etc more generic

Install your app using defined type supervisor::app

```puppet
supervisor::app { 'your-app-title':
  app_name     => 'your-app-group-name', # sets a group for the processes
  process_num  => 'The number of processes which should be created by the supervisor' # defaults to 1
  command      => 'The command that will be run this app', # required
  directory    => 'Path where your command will be run', # required
  user         => 'User to execute this app', # Defaults to root
  environment  => 'Hash map of environment variables to be used by your program', # Defaults to undef
  startsecs    => 'The total number of seconds which the program needs to stay running after a startup to consider the start successful', # Defaults to undef
  stopwaitsecs => 'The number of seconds to wait for the OS to return a SIGCHILD to supervisord after the program has been sent a stopsignal', # Defaults to undef
  priority     => 'The relative priority of the program in the start and shutdown ordering', # Defaults to undef
}
```
