module type Chain1 = {
  include REFP__Applicative.Apply1

  let chain: (t<'a>, 'a => t<'b>) => t<'b>
}

module type Chain2 = {
  include REFP__Applicative.Apply2

  let chain: (t<'a, 'b>, 'a => t<'c, 'b>) => t<'c, 'b>
}

module MakeChain1 = (Item: Chain1) => {
  include Item
}

module MakeChain2 = (Item: Chain2) => {
  include Item
}
