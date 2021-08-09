open Jest
open REFP

let double = x => x * 2

describe("IO", () => {
  test("from", () => {
    let io = IO.from(5)
    io()->expect->toBe(5)
  })

  test("map", () => {
    let io = IO.from(5)->IO.map(double)
    io()->expect->toBe(10)
  })

  test("chain", () => {
    let sum = (a, ()) => a + 30
    let io = IO.from(5)->IO.map(double)->IO.chain(sum)
    io()->expect->toBe(40)
  })

  test("flatten", () => {
    let sum = (a, ()) => a + 30
    let io = IO.from(5)->IO.map(double)->IO.map(sum)->IO.flatten
    io()->expect->toBe(40)
  })

  test("ap", () => {
    let sum = IO.from(x => x + 30)
    let io = IO.from(5)->IO.map(double)->IO.ap(sum)
    io()->expect->toBe(40)
  })
})
