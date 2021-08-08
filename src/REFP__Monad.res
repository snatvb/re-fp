module type Type1 = {
  type t<'a>

  include REFP__Applicative.Applicative1 with type t<'a> := t<'a>
  include REFP__Chain.Chain1 with type t<'a> := t<'a>
}
