# == Class: chroot
#
class chroot(
  $chroots = [],
) {
  create_resources('chroot::chroot', $chroots)
}
