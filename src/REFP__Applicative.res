module type Apply1 = {
  include REFP__Functor.Functor1
  let ap: (t<'a>, t<'a => 'b>) => t<'b>
}

module type Apply2 = {
  include REFP__Functor.Functor2
  let ap: (t<'a, 'b>, t<'a => 'c, 'b>) => t<'c, 'b>
  let ap2: (t<'a, 'b>, t<'a, 'b => 'c>) => t<'a, 'c>
}

module type Applicative1 = {
  include REFP__Pointed.Pointed1
  include Apply1 with type t<'a> := t<'a>
}

module type Applicative2 = {
  include REFP__Pointed.Pointed2
  include Apply2 with type t<'a, 'b> := t<'a, 'b>
}

module MakeApFirstSecond1 = (Item: Applicative1) => {
  let apFirst = (second: Item.t<'b>, first: Item.t<'a>) =>
    Item.ap(second, Item.map(first, (a, ()) => a))
  let apSecond = (second: Item.t<'b>, first: Item.t<'a>) =>
    Item.ap(Item.map(first, (b, ()) => b), second)
}

module MakeApply1 = (Item: Apply1) => {
  include Item
}

module MakeApply2 = (Item: Apply2) => {
  include Item
}

module MakeApplicative1 = (Item: Applicative1) => {
  include Item
}

module MakeApplicative2 = (Item: Applicative2) => {
  include Item
}
