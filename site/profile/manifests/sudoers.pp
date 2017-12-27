class profile::sudoers {
  include sudo

  sudo::conf { 'kevin':
    ensure  => 'present',
    content => 'kevin ALL=(ALL) NOPASSWD: ALL',
  }
}
