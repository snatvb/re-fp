module ReaderResult = {
  type t<'r, 'a, 'b> = REFP__Reader.t<'r, result<'a, 'b>>
  include REFP__ResultT.MakePointed2(REFP__Reader)
  include REFP__ResultT.MakeMapError2(REFP__Reader)
  include REFP__ResultT.MakeGetOrElse2(REFP__Reader)
  include REFP__ResultT.MakeFunctor2(REFP__Reader)
  include REFP__ResultT.MakeOrLeft2(REFP__Reader)
  include REFP__ResultT.MakeApply2(REFP__Reader)
  include REFP__ResultT.MakeChain2(REFP__Reader)
  include REFP__ResultT.MakeMatch2(REFP__Reader)

  let flatten = chain(_, REFP__Functions.identity)
  let ask: unit => t<'r, 'a, 'b> = () => REFP__Functions.identity
  let from = ok
}

include ReaderResult
