module IOResult = {
  type t<'a, 'b> = REFP__IO.t<result<'a, 'b>>

  include REFP__ResultT.MakeGetOrElse1(REFP__IO)
  include REFP__ResultT.MakeMapError1(REFP__IO)
  include REFP__ResultT.MakePointed1(REFP__IO)
  include REFP__ResultT.MakeFunctor1(REFP__IO)
  include REFP__ResultT.MakeOrLeft1(REFP__IO)
  include REFP__ResultT.MakeApply1(REFP__IO)
  include REFP__ResultT.MakeChain1(REFP__IO)
  include REFP__ResultT.MakeMatch1(REFP__IO)

  let okIO = okF
  let errorIO = errorF
  let fromIO = okIO
  let from = a => a->REFP__IO.from->okIO
  let fromResult = REFP__IO.from
  let from2 = a => a->REFP__IO.from->errorIO
  let chain2 = orError
  let flatten = chain(_, REFP__Functions.identity)
  let map2 = mapError
  let ap2 = apError
}

include IOResult
include REFP__Traversable.ArrayTraversable2(IOResult)
