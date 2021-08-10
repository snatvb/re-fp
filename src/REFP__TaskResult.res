module TaskResult = {
  type t<'a, 'b> = REFP__Task.t<result<'a, 'b>>
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
  let from = a => a->REFP__Task.from->okTask
  let okIO = a => a->REFP__Task.fromIO->okTask
  let fromIO = okIO
  let errorIO = a => a->REFP__Task.fromIO->errorTask
  let from2 = a => a->REFP__Task.from->errorTask
  let fromTask = okTask
  let fromResult = REFP__Task.from
  let flatten = chain(_, REFP__Functions.identity)
  let map2 = mapError
  let ap2 = apError
}

include TaskResult
include REFP__Traversable.ArrayTraversable2(TaskResult)
