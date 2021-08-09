module type Type = {
  type t<'a> = REFP__IO.t<Promise.t<'a>>

  let fromIO: REFP__IO.t<'a> => t<'a>
  include REFP__Pointed.Pointed1 with type t<'a> := t<'a>
  include REFP__Functor.Functor1 with type t<'a> := t<'a>
  include REFP__Applicative.Applicative1 with type t<'a> := t<'a>
  include REFP__Chain.Chain1 with type t<'a> := t<'a>
  let flatten: t<t<'a>> => t<'a>
  let delay: (int, t<'a>) => t<'a>
}

module Task: Type = {
  open REFP__Functions
  type t<'a> = REFP__IO.t<Promise.t<'a>>

  let fromIO = (ma, ()) => ma()->Promise.resolve
  let from = (a, ()) => a->Promise.resolve
  let map = (fa, f): t<'b> => () => fa()->Promise.thenResolve(f)
  let ap = (fa, fab): t<'b> => {
    () => Promise.all2((fa(), fab()))->Promise.thenResolve(((a, f)) => f(a))
  }
  let chain = (ma, f, ()) => ma()->Promise.then(a => f(a)())
  let flatten = chain(_, identity)
  let delay = (ms, ma) => {
    () => {
      Promise.make((resolve, _) => {
        Js.Global.setTimeout(() => {
          ma()
          ->Promise.thenResolve(a => {
            resolve(. a)->ignore
          })
          ->ignore
        }, ms)->ignore
      })
    }
  }
}

include Task
include REFP__Traversable.ArrayTraversable1(Task)
