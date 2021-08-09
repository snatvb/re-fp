open Jest
open REFP

@val external setTimeout: (unit => unit, int) => float = "setTimeout"

let double = x => x * 2

describe("Task", () => {
  let request: Task.t<int> = () =>
    Promise.make((resolve, _) => setTimeout(() => resolve(. 30), 50)->ignore)

  testAsync("from", done => {
    let task = Task.from(5)
    task()
    ->Promise.thenResolve(a => {
      a->expect->toBe(5)
      done()
    })
    ->ignore
  })

  testAsync("map", done => {
    let task = Task.from(5)->Task.map(double)
    task()
    ->Promise.thenResolve(a => {
      a->expect->toBe(10)
      done()
    })
    ->ignore
  })

  testAsync("chain", done => {
    let task = Task.from(5)->Task.map(double)->Task.chain(a => request->Task.map(b => a + b))
    task()
    ->Promise.thenResolve(a => {
      a->expect->toBe(40)
      done()
    })
    ->ignore
  })

  testAsync("flatten", done => {
    let task =
      Task.from(5)->Task.map(double)->Task.map(a => request->Task.map(b => a + b))->Task.flatten
    task()
    ->Promise.thenResolve(a => {
      a->expect->toBe(40)
      done()
    })
    ->ignore
  })

  testAsync("ap", done => {
    let requestCb = () =>
      Promise.make((resolve, _) => setTimeout(() => resolve(.a => a + 30), 30)->ignore)
    let task = Task.from(5)->Task.map(double)->Task.ap(requestCb)

    task()
    ->Promise.thenResolve(a => {
      a->expect->toBe(40)
      done()
    })
    ->ignore
  })

  testAsync("fromIO", done => {
    let io = IO.from(5)
    let task = io->Task.fromIO->Task.map(double)
    task()
    ->Promise.thenResolve(a => {
      a->expect->toBe(10)
      done()
    })
    ->ignore
  })
})
