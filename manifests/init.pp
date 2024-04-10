# @summary The top-level class, to install and configure Postfwd
#
# This class provides a basic setup of Postfwd listening on localhost
#
# @example
#   include postfwd
# @param postfwd_ensure
#   The ensure value of the postfix package
#
# @param service_enabled
#   Defines if the service 'postfix' is enabled on the system
#
# @param service_ensure
#   Defines the service state of 'postfix' service
#
# @param postfwd_rules
#   The rule set hash
#
class postfwd (
  Boolean        $service_enabled = true,
  String         $service_ensure  = running,
  String         $postfwd_ensure  = 'present',
  Optional[Hash] $postfwd_rules   = undef,
) {
  contain 'postfwd::packages'
  contain 'postfwd::service'

  Class['postfwd::packages']
  ~> Class['postfwd::service']

  concat { 'postfwd-rules':
    ensure    => present,
    path      => '/etc/postfix/postfwd.cf',
    owner     => 'root',
    group     => 'root',
    mode      => '0664',
    show_diff => true,
  }
  if $postfwd_rules {
    create_resources(profiles::postfwd::rule, $postfwd_rules)
  }
}
