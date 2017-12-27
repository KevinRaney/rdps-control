class profile::ssh {
  class { '::ssh':
    server_options => {
      'PermitRootLogin'        => 'no',
      'Port'                   => [22],
      'PrintMotd'              => 'yes',
      'PasswordAuthentication' => 'no',
    }
  }
}
