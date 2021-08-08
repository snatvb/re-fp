open REFP__Chain
open REFP__Pointed
open REFP__Functor
open REFP__Applicative
module Result = Belt.Result

module MakePointed1 = (Item: Pointed1) => {
  let ok = (a: 'a) => a->Result.Ok->Item.from
  let error = a => a->Result.Error->Item.from
}

module MakeFunctor1 = (Item: Functor1) => {
  let okF = fa => fa->Item.map(a => Result.Ok(a))
  let errorF = fa => fa->Item.map(a => Result.Error(a))
}

module MakeApply1 = (Item: Apply1) => {
  let ap = fa => fa->Item.ap
}

module MakeChain1 = (Item: Chain1) => {
  let ap = fa => fa->Item.chain
}

let matchResult = (onOk, onError, ma) =>
  switch ma {
  | Ok(a) => onOk(a)
  | Error(e) => onError(e)
  }
