module TaskOption = {
  include REFP__OptionT.MakePointed1(REFP__Task)
  include REFP__OptionT.MakeFunctor1(REFP__Task)
  include REFP__OptionT.MakeApply1(REFP__Task)
  include REFP__OptionT.MakeChain1(REFP__Task)
  include REFP__OptionT.MakeMatch1(REFP__Task)
  include REFP__OptionT.MakeGetOrElse(REFP__Task)

  let someTask = someF
  let fromTask = someF
  let fromIO = ma => ma->REFP__Task.fromIO->fromTask
  let fromOption = REFP__Task.from
  let flatten = REFP__Task.flatten
}

include TaskOption
