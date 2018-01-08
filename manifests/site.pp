case $::osfamily {
  'FreeBSD': {
    $package_provider = 'pkgng'
  }
  default: {
    $package_provider = undef
  }
}

Package {
  allow_virtual => true,
  provider      => $package_provider,
}
