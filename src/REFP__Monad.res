open REFP__Applicative
open REFP__Chain

module type Type1 = {
  type t<'a>

  include Applicative1 with type t<'a> := t<'a>
  include Chain1 with type t<'a> := t<'a>
}

module type Type2 = {
  type t<'a, 'b>

  include Applicative2 with type t<'a, 'b> := t<'a, 'b>
  include Chain2 with type t<'a, 'b> := t<'a, 'b>
}

module MakeMonad1 = (Item: Type1) => {
  include Item
}
