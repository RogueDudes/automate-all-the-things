class python3($version = '3.2') {
  # Install Python and the its development.
  package { ["python${version}", "python${version}-dev"]: }

  # Install PIP only if it isn't currently installed.
  -> exec { "wget -qO- https://raw.github.com/pypa/pip/master/contrib/get-pip.py | python${version}":
    path   => ['/usr/bin', '/bin'],
    unless => "which pip 2>&1 1>/dev/null"
  }
}
