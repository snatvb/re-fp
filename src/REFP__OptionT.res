open REFP__Monad
open REFP__Pointed
open REFP__Functor
open REFP__Applicative
module Option = Belt.Option

let match = (ma, onSome, onNone) =>
  switch ma {
  | Some(a) => onSome(a)
  | None => onNone()
  }

let some = a => Some(a)
let none = () => None
let ap = (mfa, mf) =>
  switch mf {
  | Some(f) =>
    switch mfa {
    | Some(a) => Some(f(a))
    | None => None
    }
  | None => None
  }

module MakePointed1 = (Item: Pointed1) => {
  let some = (a: 'a) => a->Some->Item.from
  let none = () => None->Item.from
}

module MakeFunctor1 = (Item: Functor1) => {
  let someF = fa => fa->Item.map(a => Some(a))
  let map = (fa, f) => Item.map(fa, ga => Option.map(ga, f))
}

module MakeApply1 = (Item: Apply1) => {
  let ap = (fa, mf) => fa->Item.ap(Item.map(mf, (f, a) => ap(a, f)))
}

module MakeChain1 = (Item: Monad1) => {
  let chain = (fa, f) =>
    fa->Item.chain(ma =>
      switch ma {
      | Some(a) => f(a)
      | None => Item.from(None)
      }
    )
}

module MakeMatch1 = (F: REFP__Functor.Functor1) => {
  let match = (ma, onSome, onNone) => ma->F.map(match(onSome, onNone))
}

module MakeGetOrElse = (M: REFP__Monad.Monad1) => {
  let getOrElse = (onNone, fa) => M.chain(fa, match(onNone, M.from))
}
