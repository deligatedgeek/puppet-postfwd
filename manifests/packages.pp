# @summary Install the required packages for postfwd
#
# @api private
#
class postfwd::packages {
  assert_private()

  package { 'postfwd':
    ensure => $postfwd::postfwd_ensure,
  }
}
