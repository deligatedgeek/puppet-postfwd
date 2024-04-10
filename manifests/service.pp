# @summary Manage service resources for postfwd
#
# @api private
#
class postfwd::service {
  service { 'postfwd':
    ensure => $postfwd::service_ensure,
    enable => $postfwd::service_enabled,
  }
}
