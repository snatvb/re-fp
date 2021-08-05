type t<'a> = unit => 'a

let from = (f: 'a): t<'a> => () => f
let map = (fa: t<'a>, f: 'a => 'b): t<'b> => () => fa()->f
let ap = (fa: t<'a>, f: t<'a => 'b>): t<'b> => () => f()(fa())
let chain = (fa: t<'a>, f: 'a => t<'b>): t<'b> => () => f(fa())()
let flatten = (fa: t<t<'a>>): t<'a> => fa->chain(x => x)

module Pointed: REFP__Pointed.Pointed1 with type t<'a> = t<'a> = {
  type t<'a> = t<'a>
  let from = from
}

module Functor: REFP__Types.Functor1 with type t<'a> = t<'a> = {
  include Pointed
  let map = map
}

module Applicative: REFP__Types.Applicative1 with type t<'a> = t<'a> = {
  include Functor
  let ap = ap
}

module Chain: REFP__Types.Chain1 with type t<'a> = t<'a> = {
  include Applicative
  let chain = chain
}
