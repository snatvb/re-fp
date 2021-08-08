open REFP__Applicative
open REFP__Chain

module type Type1 = {
  type t<'a>

  include Applicative1 with type t<'a> := t<'a>
  include Chain1 with type t<'a> := t<'a>
}

module MakeMonad1 = (Item: Type1) => {
  include Item
}
