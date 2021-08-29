module Reader = {
  type t<'a, 'r> = 'r => 'a

  let ask: unit => t<'a, 'r> = () => REFP__Functions.identity
  let asks: ('r => 'a) => t<'a, 'r> = REFP__Functions.identity
  let from = (a): t<'a, 'r> => _ => a
  let map = (fa: t<'a, 'r>, f: 'a => 'b): t<'b, 'r> => r => f(fa(r))
  let ap = (fa: t<'a, 'r>, fab: t<'a => 'b, 'r>): t<'b, 'r> => r => fab(r)(fa(r))
  let chain = (fa: t<'a, 'r>, f: 'a => t<'b, 'r>): t<'b, 'r> => r => f(fa(r))(r)
}

include Reader
