module type Type = {
  type t<'a> = REFP__IO.t<Promise.t<'a>>

  let fromIO: REFP__IO.t<'a> => t<'a>
  include REFP__Functor.Functor1 with type t<'a> := t<'a>
  include REFP__Applicative.Applicative1 with type t<'a> := t<'a>
  include REFP__Chain.Chain1 with type t<'a> := t<'a>
}

module Task: Type = {
  type t<'a> = REFP__IO.t<Promise.t<'a>>

  let fromIO = (ma, ()) => ma()->Promise.resolve
  let from = (a, ()) => a->Promise.resolve
  let map = (fa, f): t<'b> => () => fa()->Promise.thenResolve(f)
  let ap = (fa, fab): t<'b> => {
    () => Promise.all2((fa(), fab()))->Promise.thenResolve(((a, f)) => f(a))
  }
  let chain = (ma, f, ()) => ma()->Promise.then(a => f(a)())
}

module Pointed = REFP__Pointed.MakePointed1(Task)
module Functor = REFP__Functor.MakeFunctor1(Task)
module Applicative = REFP__Applicative.MakeApplicative1(Task)
module Chain = REFP__Chain.MakeChain1(Task)