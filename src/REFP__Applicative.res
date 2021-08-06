module type Applicative1 = {
  open REFP__Functor
  include Functor1

  let ap: (t<'a>, t<'a => 'b>) => t<'b>
}

module Apply1 = (Item: Applicative1) => {
  let apFirst = (second: Item.t<'b>, first: Item.t<'a>) =>
    Item.ap(second, Item.map(first, (a, ()) => a))
  let apSecond = (second: Item.t<'b>, first: Item.t<'a>) =>
    Item.ap(Item.map(first, (b, ()) => b), second)
}

module MakeApplicative1 = (Item: Applicative1) => {
  include Item
}
