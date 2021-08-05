module type Functor1 = {
  include REFP__Pointed.Pointed1

  let map: (t<'a>, 'a => 'b) => t<'b>
}
