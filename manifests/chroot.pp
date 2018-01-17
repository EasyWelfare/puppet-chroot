# == Define: chroot
#
define chroot::chroot (
  $path           = undef,
  $ensure         = present,
  $copy           = [],
  $binaries       = [],
  $always_rebuild = false,
) {

  file { "/usr/bin/${title}-setup.sh":
    ensure  => $ensure,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content => template('chroot/usr/bin/setup_chroot.sh.erb'),
  }

  if $ensure == 'present' {
    ensure_packages(['rsync'], {'ensure' => present})

    exec { "build_${title}_chroot":
      command     => "/usr/bin/${title}-setup.sh",
      path        => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
      refreshonly => $always_rebuild ? {
        true    => false,
        default => true
      },
      require     => [
        Package['rsync']
      ],
      subscribe   => File["/usr/bin/${title}-setup.sh"],
    }
  }

}
