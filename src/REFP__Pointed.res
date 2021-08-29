module type Pointed1 = {
  type t<'a>

  let from: 'a => t<'a>
}

module type Pointed2 = {
  type t<'a, 'b>

  let from: 'a => t<'a, 'b>
}

module MakePointed1 = (Item: Pointed1) => {
  include Item
}

module MakePointed2 = (Item: Pointed2) => {
  include Item
}
