module IOResult = {
  include REFP__ResultT.MakeGetOrElse(REFP__IO)
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
  let fromResult = REFP__IO.from
  let map2 = mapError
  let chain2 = orError
  let flatten = REFP__IO.flatten
}

include IOResult
