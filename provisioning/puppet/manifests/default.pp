node default {
  exec { '/usr/bin/apt-get update': } -> class { 'apt': always_apt_update => true }

  class { 'uwsgi':
    wsgi_file => '/vagrant/src/app.py'
  }

  include nginx
}
