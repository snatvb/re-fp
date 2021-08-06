module type Chain1 = {
  include REFP__Applicative.Applicative1

  let chain: (t<'a>, 'a => t<'b>) => t<'b>
}

module MakeChain1 = (Item: Chain1) => {
  include Item
}
