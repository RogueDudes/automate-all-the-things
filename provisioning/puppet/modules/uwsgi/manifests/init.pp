class uwsgi(
  $wsgi_file,
  $socket      = '127.0.0.1:3031',
  $vassal_name = 'app'
) {
  require python3

  # The build-essential is a pretty common package. If it is already declared
  # by another 3rd party package, don't redeclare it. It will fail Puppet.
  if ! defined(Package['build-essential']) {
    package { 'build-essential': }
  }

  # Install the uwsgi package through the PIP package provider. Every Puppet
  # type can be backed by multiple providers.
  package { 'uwsgi':
    provider => 'pip',
    require  => Package['build-essential']
  }

  file {
    # Install Upstart script for uWSGI Emperor.
    '/etc/init/uwsgi.conf':
      source => 'puppet:///modules/uwsgi/uwsgi.conf';

    ['/etc/uwsgi', '/etc/uwsgi/vassals']:
      ensure => directory;

    # Create vassal configuration.
    "/etc/uwsgi/vassals/${vassal_name}.ini":
      content => template('uwsgi/vassal.ini.erb'),
      notify  => Service['uwsgi'];
  }

  service { 'uwsgi':
    ensure  => running,
    enable  => true,
    require => [Package['uwsgi'], File['/etc/init/uwsgi.conf']]
  }
}
