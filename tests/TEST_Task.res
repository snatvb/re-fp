open Jest
open REFP

@val external setTimeout: (unit => unit, int) => float = "setTimeout"

let double = x => x * 2

describe("Task", () => {
  let request: Task.t<int> = () =>
    Promise.make((resolve, _) => setTimeout(() => resolve(. 30), 50)->ignore)

  testAsync("from", done => {
    let task = Task.from(5)
    task()->awaitThen(done, a => a->expect->toBe(5))
  })

  testAsync("map", done => {
    let task = Task.from(5)->Task.map(double)
    task()->awaitThen(done, a => a->expect->toBe(10))
  })

  testAsync("chain", done => {
    let task = Task.from(5)->Task.map(double)->Task.chain(a => request->Task.map(b => a + b))
    task()->awaitThen(done, a => a->expect->toBe(40))
  })

  testAsync("flatten", done => {
    let task =
      Task.from(5)->Task.map(double)->Task.map(a => request->Task.map(b => a + b))->Task.flatten
    task()->awaitThen(done, a => a->expect->toBe(40))
  })

  testAsync("ap", done => {
    let requestCb = () =>
      Promise.make((resolve, _) => setTimeout(() => resolve(.a => a + 30), 30)->ignore)
    let task = Task.from(5)->Task.map(double)->Task.ap(requestCb)

    task()->awaitThen(done, a => a->expect->toBe(40))
  })

  testAsync("fromIO", done => {
    let io = IO.from(5)
    let task = io->Task.fromIO->Task.map(double)
    task()->awaitThen(done, a => a->expect->toBe(10))
  })

  testAsync("traverseArray", done => {
    let task = [1, 2, 3]->Task.traverseArray(Task.from)->Task.map(a => a->Belt.Array.map(double))
    task()->awaitThen(done, a => a->expect->toEqual([2, 4, 6]))
  })

  testAsync("sequnceArray", done => {
    let task =
      [1, 2, 3]
      ->Belt.Array.map(Task.from)
      ->Task.sequenceArray
      ->Task.map(a => a->Belt.Array.map(double))
    task()->awaitThen(done, a => a->expect->toEqual([2, 4, 6]))
  })
})
