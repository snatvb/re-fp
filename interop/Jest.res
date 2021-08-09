@val external describe: (string, @uncurry (unit => unit)) => unit = "describe"
@val external test: (string, @uncurry (unit => unit)) => unit = "test"

type e
@val external expect: 'a => e = "expect"
@send external toBe: (e, 'a) => unit = "toBe"
@send external toEqual: (e, 'a) => unit = "toEqual"
