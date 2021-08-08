open REFP__Pointed
open REFP__Functor
module Result = Belt.Result

module MakePointed1 = (Item: Pointed1) => {
  let ok = (a: 'a) => a->Result.Ok->Item.from
  let error = a => a->Result.Error->Item.from
}

module MakeFunctor1 = (Item: Functor1) => {
  let okF = fa => fa->Item.map(a => Result.Ok(a))
  let errorF = fa => fa->Item.map(a => Result.Error(a))
}

let matchResult = (onOk, onError, ma) =>
  switch ma {
  | Ok(a) => onOk(a)
  | Error(e) => onError(e)
  }
