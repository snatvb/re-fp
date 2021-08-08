open REFP__Chain
open REFP__Pointed
open REFP__Functor
open REFP__Applicative
module Option = Belt.Option

let matchResult = (ma, onSome, onNone) =>
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
}

module MakeApply1 = (Item: Apply1) => {
  let ap = fa => fa->Item.ap
}

module MakeChain1 = (Item: Chain1) => {
  let chain = fa => fa->Item.chain
}

module MakeMatch1 = (F: REFP__Functor.Functor1) => {
  let match = (ma, onOk, onError) => ma->F.map(matchResult(onOk, onError))
}
