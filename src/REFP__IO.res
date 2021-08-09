module type Type = {
  type t<'a> = unit => 'a

  include REFP__Applicative.Applicative1 with type t<'a> := t<'a>
  include REFP__Pointed.Pointed1 with type t<'a> := t<'a>
  include REFP__Functor.Functor1 with type t<'a> := t<'a>
  include REFP__Chain.Chain1 with type t<'a> := t<'a>
  let flatten: t<t<'a>> => t<'a>
}

module IO: Type = {
  type t<'a> = unit => 'a

  let from = (f, ()) => f
  let map = (fa, f): t<'b> => () => fa()->f
  let ap = (fa, f): t<'b> => () => f()(fa())
  let chain = (fa, f): t<'b> => () => f(fa())()
  let flatten = (fa): t<'a> => fa->chain(x => x)
}

include IO
include REFP__Traversable.ArrayTraversable1(IO)
