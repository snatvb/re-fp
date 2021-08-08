module type Apply1 = {
  type t<'a>
  let ap: (t<'a>, t<'a => 'b>) => t<'b>
}

module type Apply2 = {
  type t<'a, 'b>
  let ap: (t<'a, 'b>, t<'a => 'c, 'b>) => t<'c, 'b>
}

module type Applicative1 = {
  include REFP__Functor.Functor1
  include Apply1 with type t<'a> := t<'a>
}

module type Applicative2 = {
  include REFP__Functor.Functor2
  include Apply2 with type t<'a, 'b> := t<'a, 'b>
}

module MakeApply1 = (Item: Applicative1) => {
  let apFirst = (second: Item.t<'b>, first: Item.t<'a>) =>
    Item.ap(second, Item.map(first, (a, ()) => a))
  let apSecond = (second: Item.t<'b>, first: Item.t<'a>) =>
    Item.ap(Item.map(first, (b, ()) => b), second)
}

module MakeApplicative1 = (Item: Applicative1) => {
  include Item
}

module MakeApplicative2 = (Item: Applicative2) => {
  include Item
}
