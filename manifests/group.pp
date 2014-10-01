define supervisor::group (
    $process_group,
    $programms,
    $priority = 100,
) {
    file { "/etc/supervisor/${process_group}.conf":
        ensure  => present,
        content => template("supervisor/supervisor_group.conf.erb"),
    }
}
