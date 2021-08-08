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

module MakeResultT1 = (Poined: Pointed1, Functor: Functor1) => {
  include MakePointed1(Poined)
  include MakeFunctor1(Functor)

  let okTask = okF
  let errorTask = errorF
  let okIO = a => a->Functor.from->okTask
  let fromIO = okIO
  let errorIO = a => a->Functor.from->errorTask
  let fromTask = okTask
  let fromResult = Poined.from
}
