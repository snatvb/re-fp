module type Apply1 = {
  include REFP__Functor.Functor1
  let ap: (t<'a>, t<'a => 'b>) => t<'b>
}

module type Apply2 = {
  include REFP__Functor.Functor2
  let ap: (t<'a, 'b>, t<'a => 'c, 'b>) => t<'c, 'b>
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

module CompositeApply1 = (F: Apply1, G: Apply1) => {
  let ap = (fa, fab) => F.ap(F.map(fab, (gab, ga) => G.ap(gab, ga)), fa)
}
