module type Applicative1 = {
  open REFP__Functor
  include Functor1

  let ap: (t<'a>, t<'a => 'b>) => t<'b>
}
