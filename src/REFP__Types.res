module type Comparable = {
  type t

  let eq: (t, t) => bool
}

module type Pointed1 = {
  type t<'a>

  let from: 'a => t<'a>
}

module type Functor1 = {
  include Pointed1

  let map: (t<'a>, 'a => 'b) => t<'b>
}

module type Applicative1 = {
  include Functor1

  let ap: (t<'a>, t<'a => 'b>) => t<'b>
}

module type Chain1 = {
  include Applicative1

  let chain: (t<'a>, 'a => t<'b>) => t<'b>
}
