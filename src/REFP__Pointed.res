module type Pointed1 = {
  type t<'a>

  let from: 'a => t<'a>
}

module MakePointed1 = (Item: Pointed1) => {
  include Item
}
