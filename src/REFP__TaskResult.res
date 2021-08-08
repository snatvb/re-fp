module TaskResult = {
  include REFP__ResultT.MakePointed1(REFP__Task.Pointed)
  include REFP__ResultT.MakeFunctor1(REFP__Task.Functor)
  include REFP__ResultT.MakeApply1(REFP__Task.Apply)
  include REFP__ResultT.MakeChain1(REFP__Task.Chain)

  let okTask = okF
  let errorTask = errorF
  let okIO = a => a->REFP__Task.fromIO->okTask
  let fromIO = okIO
  let errorIO = a => a->REFP__Task.fromIO->errorTask
  let fromTask = okTask
  let fromResult = REFP__Task.from
  let match = (ma, onOk, onError) =>
    ma->REFP__Task.Functor.map(REFP__ResultT.matchResult(onOk, onError))
}

include TaskResult
