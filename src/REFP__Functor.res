module type Functor1 = {
  // include REFP__Pointed.Pointed1
  type t<'a>

  let map: (t<'a>, 'a => 'b) => t<'b>
}

module MakeFunctor1 = (Item: Functor1) => {
  include Item
}
