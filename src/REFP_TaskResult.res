module TaskResult = {
  include REFP__ResultT.MakeResultT1(REFP__Task.Pointed, REFP__Task.Functor)
}

include TaskResult
