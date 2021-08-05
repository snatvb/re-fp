module type Functor1 = {
  open REFP__Ponted
  include Pointed1

  let map: (t<'a>, 'a => 'b) => t<'b>
}
