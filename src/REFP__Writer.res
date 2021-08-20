module Writer = {
  type t<'a, 'w> = unit => ('a, 'w)

  let listen = (fa, ()) => {
    let (a, w) = fa()
    ((a, w), w)
  }

  let pass = (fa, ()) => {
    let ((a, f), w) = fa()
    (a, f(w))
  }

  let listens = (f, fa, ()) => {
    let (a, w) = fa()
    ((a, f(w)), w)
  }

  let consor = (f, fa, ()) => {
    let (a, w) = fa()
    (a, f(w))
  }

  let map = (f, fa, ()) => {
    let (a, w) = fa()
    (f(a), w)
  }
}
