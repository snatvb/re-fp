module TaskResult = {
  include REFP__ResultT.MakePointed1(REFP__Task.Pointed)
  include REFP__ResultT.MakeFunctor1(REFP__Task.Functor)

  let okTask = okF
  let errorTask = errorF
  let okIO = a => a->REFP__Task.fromIO->okTask
  let fromIO = okIO
  let errorIO = a => a->REFP__Task.fromIO->errorTask
  let fromTask = okTask
  let fromResult = REFP__Task.from
  // let match = (ma, onOk, onError) => ma->Functor.map(matchResult(onOk, onError))
}

include TaskResult
