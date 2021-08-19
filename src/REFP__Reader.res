module Reader = {
  type t<'r, 'a> = 'r => 'a

  let ask: unit => t<'r, 'a> = () => REFP__Functions.identity
  let asks: ('r => 'a) => t<'r, 'a> = REFP__Functions.identity
  let from = (a): t<'r, 'a> => _ => a
  let map = (fa: t<'r, 'a>, f: 'a => 'b): t<'r, 'b> => r => f(fa(r))
  let ap = (fab: t<'r, 'a => 'b>, fa: t<'r, 'a>): t<'r, 'b> => r => fab(r)(fa(r))
  let chain = (fa: t<'r, 'a>, f: 'a => t<'r, 'b>): t<'r, 'b> => r => f(fa(r))(r)
}

include Reader
