@val external describe: (string, @uncurry (unit => unit)) => unit = "describe"
@val external test: (string, @uncurry (unit => unit)) => unit = "test"
type done = @uncurry (unit => unit)
type errorableDone<'a> = @uncurry (exn => Promise.t<'a>)
@val external testAsync: (string, @uncurry (done => unit)) => unit = "test"
external toErrorable: done => errorableDone<'a> = "%identity"

type e
@val external expect: 'a => e = "expect"
@send external toBe: (e, 'a) => unit = "toBe"
@send external toEqual: (e, 'a) => unit = "toEqual"

let awaitThen = (pa, done, f) =>
  pa
  ->Promise.thenResolve(a => {
    f(a)
    done()
  })
  ->Promise.catch(done->toErrorable)
  ->ignore
