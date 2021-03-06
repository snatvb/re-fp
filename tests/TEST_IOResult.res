open Jest
open REFP

module IOR = IOResult
module Result = REFP__ResultT.Result

let double = x => x * 2

describe("IOResult", () => {
  let readSomething = (_, ()) => Error("not found")

  test("ok", () => {
    let io = IOR.ok(5)
    io()->Result.getWithDefault(0)->expect->toBe(5)
  })

  test("map", () => {
    let io = IOR.ok(5)->IOR.map(double)
    io()->Result.getWithDefault(0)->expect->toBe(10)
  })

  test("mapError", () => {
    let task = IOR.error("not found")->IOR.mapError(err => `Error: ${err}`)
    task()->REFP__ResultT.matchResult(
      _,
      _ => "Unreachable"->expect->toBe("Error: not found"),
      e => e->expect->toBe("Error: not found"),
    )
  })

  test("chain", () => {
    let sum = (a, ()) => Ok(a + 30)
    let io = IOR.ok(5)->IOR.map(double)->IOR.chain(sum)
    io()->Result.getWithDefault(0)->expect->toBe(40)
  })

  test("chainError", () => {
    let task = IOR.error("omg")->IOR.chainError(readSomething)->IOR.mapError(err => `Error: ${err}`)
    task()->REFP__ResultT.matchResult(
      _,
      _ => "Unreachable"->expect->toBe("Error: not found"),
      e => e->expect->toBe("Error: not found"),
    )
  })

  test("flatten", () => {
    let sum = (a, ()) => Ok(a + 30)
    let io = IOR.ok(5)->IOR.map(double)->IOR.map(sum)->IOR.flatten
    io()->Result.getWithDefault(0)->expect->toBe(40)
  })

  test("ap", () => {
    let sum = IOR.ok(x => x + 30)
    let io = IOR.ok(5)->IOR.map(double)->IOR.ap(sum)
    io()->Result.getWithDefault(0)->expect->toBe(40)
  })

  test("getOrElse Ok", () => {
    let io = IOR.ok(5)->IOR.getOrElse((_, ()) => 0)
    io()->expect->toBe(5)
  })

  test("getOrElse Error", () => {
    let io = IOR.error(5)->IOR.getOrElse((_, ()) => 0)
    io()->expect->toBe(0)
  })

  test("traverseArray", () => {
    let task = [1, 2, 3]->IOR.traverseArray(IOR.ok)->IOR.map(Belt.Array.map(_, double))
    task()->Result.getWithDefault([0])->expect->toEqual([2, 4, 6])
  })

  test("sequnceArray", () => {
    let task = [1, 2, 3]->Belt.Array.map(IOR.ok)->IOR.sequenceArray
    task()->Result.getWithDefault([0])->expect->toEqual([1, 2, 3])
  })

  test("map -> chain -> mapError", () => {
    let task = IOR.ok(5)->IOR.chain(readSomething)->IOR.mapError(err => `Error: ${err}`)
    task()->REFP__ResultT.matchResult(
      _,
      _ => "Unreachable"->expect->toBe("Error: not found"),
      e => e->expect->toBe("Error: not found"),
    )
  })
})
