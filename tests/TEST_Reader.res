open Jest
module R = REFP__Reader

type i18n = {
  yes: string,
  no: string,
}

type dependencies = {i18n: i18n}
type env = [#prod | #dev]

describe("Reader", () => {
  let deps = {i18n: {yes: "Yep", no: "Nope"}}
  let double = n => n * 2
  let addOne = n => n + 1

  test("an example", () => {
    let localeBool = (deps, b) => b ? deps.i18n.yes : deps.i18n.no
    let greaterThan = (deps, n, gt) => deps->localeBool(n > gt)
    deps->greaterThan(10, 30)->expect->toBe("Nope")
  })

  test("map", () => {
    let c = env =>
      switch env {
      | #prod => 10
      | #dev => 3
      }

    let f = R.map(c, double)->R.map(addOne)
    #prod->f->expect->toBe(21)
    #dev->f->expect->toBe(7)
  })

  test("chain", () => {
    let c = env =>
      switch env {
      | #prod => 10
      | #dev => 3
      }

    let localeEnv = n =>
      R.asks(env =>
        switch env {
        | #prod => `${n->Belt.Int.toString} on prod!`
        | #dev => `${n->Belt.Int.toString} on dev!`
        }
      )
    let f = R.map(c, double)->R.map(addOne)->R.chain(localeEnv)
    #prod->f->expect->toBe("21 on prod!")
    #dev->f->expect->toBe("7 on dev!")
  })

  test("ap", () => {
    let c = env =>
      switch env {
      | #prod => 10
      | #dev => 3
      }
    let f = R.from(addOne)->R.ap(R.from(double)->R.ap(c, _), _)
    #prod->f->expect->toBe(21)
    #dev->f->expect->toBe(7)
  })
})
