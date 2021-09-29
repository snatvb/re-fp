open Jest
module RR = REFP__ReaderResult

type env = [#prod | #dev | #test]

describe("Reader", () => {
  let double = n => n * 2
  let addOne = n => n + 1

  test("map", () => {
    let error = "test doesn't support"->Error
    let c = env =>
      switch env {
      | #prod => 10->Ok
      | #dev => 3->Ok
      | #test => error
      }

    let f = RR.map(c, double)->RR.map(addOne)
    #prod->f->expect->toEqual(21->Ok)
    #dev->f->expect->toEqual(7->Ok)
    #test->f->expect->toEqual(error)
  })

  test("chain", () => {
    let c = env =>
      switch env {
      | #prod => 10
      | #dev => 3
      }->Ok

    let localeEnv = (n, env) =>
      switch env {
      | #prod => `${n->Belt.Int.toString} on prod!`
      | #dev => `${n->Belt.Int.toString} on dev!`
      }->Ok
    let f = RR.map(c, double)->RR.map(addOne)->RR.chain(localeEnv)
    #prod->f->expect->toEqual("21 on prod!"->Ok)
    #dev->f->expect->toEqual("7 on dev!"->Ok)
  })

  test("ap", () => {
    let c = env =>
      switch env {
      | #prod => 10
      | #dev => 3
      }->Ok
    let f = RR.from(addOne)->RR.ap(RR.from(double)->RR.ap(c, _), _)
    #prod->f->expect->toEqual(21->Ok)
    #dev->f->expect->toEqual(7->Ok)
  })
})
