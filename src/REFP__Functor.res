module type Functor1 = {
  type t<'a>

  let map: (t<'a>, 'a => 'b) => t<'b>
}

module type Functor2 = {
  type t<'a, 'b>

  let map: (t<'a, 'b>, 'a => 'c) => t<'c, 'b>
  let map2: (t<'a, 'b>, 'b => 'c) => t<'a, 'c>
}

module MakeFunctor1 = (Item: Functor1) => {
  include Item
}
