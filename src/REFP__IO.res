module type Interface = {
  type t<'a> = unit => 'a
  let from: 'a => t<'a>
  let map: (t<'a>, 'a => 'b) => t<'b>
  let ap: (t<'a>, t<'a => 'b>) => t<'b>
  let chain: (t<'a>, 'a => t<'b>) => t<'b>
  let flatten: t<t<'a>> => t<'a>
}

module IO: Interface = {
  type t<'a> = unit => 'a
  let from = (f, ()) => f
  let map = (fa, f): t<'b> => () => fa()->f
  let ap = (fa, f): t<'b> => () => f()(fa())
  let chain = (fa, f): t<'b> => () => f(fa())()
  let flatten = (fa): t<'a> => fa->chain(x => x)
}

module Pointed: REFP__Pointed.Pointed1 with type t<'a> = IO.t<'a> = {
  type t<'a> = IO.t<'a>
  let from = IO.from
}

module Functor: REFP__Types.Functor1 with type t<'a> = IO.t<'a> = {
  include Pointed
  let map = IO.map
}

module Applicative: REFP__Types.Applicative1 with type t<'a> = IO.t<'a> = {
  include Functor
  let ap = IO.ap
}

module Chain: REFP__Types.Chain1 with type t<'a> = IO.t<'a> = {
  include Applicative
  let chain = IO.chain
}
