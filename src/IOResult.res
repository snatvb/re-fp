module IOResult = {
  include REFP__ResultT.MakeResultT1(REFP__IO.Pointed, REFP__IO.Functor)
}

include IOResult
