module type Comparable = {
  type t

  let eq: (t, t) => bool
}

include REFP__Pointed
include REFP__Functor
include REFP__Applicative
include REFP__Chain
