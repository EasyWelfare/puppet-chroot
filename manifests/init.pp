# == Class: chroot
#
class chroot(
  $chroots = [],
) {
  # This anchor can be used as a reference point for things that need to happen *before*
  # setting up the chroots.
  anchor { 'chroot::before_setup': }
  create_resources('chroot::chroot', $chroots)
}
