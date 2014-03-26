node default {
  exec { '/usr/bin/apt-get update': }

  include apt
  class { 'uwsgi':
    wsgi_file => '/vagrant/src/app.py'
  }
  include nginx

  # You can use the arrow operator on resource references too. Those aren't
  # parser dependant.
  Exec['/usr/bin/apt-get update'] -> Class['apt']

}
