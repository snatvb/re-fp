module IOResult = {
  include REFP__ResultT.MakePointed1(REFP__Task.Pointed)
  include REFP__ResultT.MakeFunctor1(REFP__Task.Functor)

  let okIO = okF
  let errorIO = errorF
  let fromIO = okIO
  let fromResult = REFP__IO.from
  let match = (ma, onOk, onError) =>
    ma->REFP__IO.Functor.map(REFP__ResultT.matchResult(onOk, onError))
}

include IOResult
