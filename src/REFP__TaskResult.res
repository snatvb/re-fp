module TaskResult = {
  include REFP__ResultT.MakeMapError1(REFP__Task)
  include REFP__ResultT.MakeGetOrElse(REFP__Task)
  include REFP__ResultT.MakePointed1(REFP__Task)
  include REFP__ResultT.MakeFunctor1(REFP__Task)
  include REFP__ResultT.MakeOrLeft1(REFP__Task)
  include REFP__ResultT.MakeApply1(REFP__Task)
  include REFP__ResultT.MakeChain1(REFP__Task)
  include REFP__ResultT.MakeMatch1(REFP__Task)

  let okTask = okF
  let errorTask = errorF
  let okIO = a => a->REFP__Task.fromIO->okTask
  let fromIO = okIO
  let errorIO = a => a->REFP__Task.fromIO->errorTask
  let fromTask = okTask
  let fromResult = REFP__Task.from
  let flatten = REFP__Task.flatten
}

include TaskResult
