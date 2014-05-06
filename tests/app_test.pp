class app_test {
    include supervisor

    supervisor::app { 'multiple_dummies':
        app_name        => 'dummies',
        process_num     => 2,
        processes_start => 2,
        command         => "python dummy.py -D -c dummy.cfg",
        directory       => "/dummy",
        redirect_stderr => 'true',
        stdout_logfile  => "/dummy.err",
        environment     => "PYTHONPATH=\$PYTHONPATH:dummy_dir",
        autostart       => false,
    }

    supervisor::app { 'single_dummy':
        app_name        => 'dummy',
        process_num     => 1,
        processes_start => 1,
        command         => "python dummy.py -D -c dummy.cfg",
        directory       => "/dummy",
        redirect_stderr => 'true',
        stdout_logfile  => "/dummy.err",
        environment     => "PYTHONPATH=\$PYTHONPATH:dummy_dir",
        autostart       => false,
    }
}

include app_test
