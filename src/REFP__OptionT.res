open REFP__Chain
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

module MakePointed1 = (Item: Pointed1) => {
  let some = (a: 'a) => a->Some->Item.from
  let none = () => None->Item.from
}

module MakeFunctor1 = (Item: Functor1) => {
  let someF = fa => fa->Item.map(a => Some(a))
  let map = (f, fa) => Item.map(fa, ga => Option.map(ga, f))
}

module MakeApply1 = (Item: Apply1) => {
  let ap = fa => fa->Item.ap
}

module MakeChain1 = (Item: Chain1) => {
  let chain = fa => fa->Item.chain
}

module MakeMatch1 = (F: REFP__Functor.Functor1) => {
  let match = (ma, onSome, onNone) => ma->F.map(match(onSome, onNone))
}

module MakeGetOrElse = (M: REFP__Monad.Type1) => {
  let getOrElse = (onNone, fa) => M.chain(fa, match(onNone, M.from))
}
