# @summary create individual postfwd rules
#
# Creates each postfwd rules in the postfwd confifuration file
#
# @example A single rule to match unknown client and do nothing
#   postfwd::rule { 'rule_test':
#     order  => 1,
#     id     => 'RULE01',
#     items  => { client_name => '==unknown' },
#     action => 'dunno',
# }
# @param id
#   A string defining the id of the rule 
#
# @param items
#   List of items that must match for the rule to fire.
#   Can be a string containing a correctly formatted item line, 
#   a hash of items, or undefined for match all.
#
# @param action
#   A string containing the action required when the rule fires.
#
# @param order
#   An integer which defines the priority of this rule in the list
#
define postfwd::rule (
  String                     $id     = undef,
  Variant[String,Hash,Undef] $items  = undef,
  String                     $action = undef,
  Optional[Integer]          $order  = undef,
) {
  # Ensure rule items are string or hash
  case String(type($items, 'generalized')) {
    /Hash.*/: {
      $item_string = $items.reduce('') |$memo, $value| {
        $item = "${memo} ${value[0]}${value[1]} ;"
        $item
      }
    }
    'String': {
      $item_string = $items
    }
    'Undef': {
      $item_string = ''
    }
    default: {
      fail( 'Items must be a string or a hash or undef')
    }
  }

  if $action == undef {
    fail( 'Action must be specified')
  }

  concat::fragment { "postfwd-${title}":
    target  => 'postfwd-rules',
    content => "id=${id} ;  ${item_string}\n               action=${action}\n",
    order   => $order,
  }
}
