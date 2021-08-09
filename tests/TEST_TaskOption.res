open Jest
open REFP

@val external setTimeout: (unit => unit, int) => float = "setTimeout"

let double = x => x * 2

module TO = TaskOption

describe("TaskOption", () => {
  let request: Task.t<int> = () =>
    Promise.make((resolve, _) => setTimeout(() => resolve(. 30), 50)->ignore)

  testAsync("fromOption", done => {
    let task = TO.fromOption(Some(5))
    task()
    ->Promise.thenResolve(a => {
      a->expect->toBe(5)
      done()
    })
    ->ignore
  })

  testAsync("fromIO", done => {
    let task = IO.from(5)->TO.fromIO
    task()
    ->Promise.thenResolve(a => {
      a->expect->toBe(5)
      done()
    })
    ->ignore
  })

  testAsync("fromTask", done => {
    let task = Task.from(5)->TO.fromTask
    task()
    ->Promise.thenResolve(a => {
      a->expect->toBe(5)
      done()
    })
    ->ignore
  })

  testAsync("map", done => {
    let task = TO.some(5)->TO.map(double)
    task()->awaitThen(done, a => a->expect->toBe(10))
  })

  testAsync("chain", done => {
    let task = TO.some(5)->TO.map(double)->TO.chain(a => request->TO.fromTask->TO.map(b => a + b))
    task()->awaitThen(done, a => a->expect->toBe(40))
  })

  testAsync("flatten", done => {
    let task =
      TO.some(5)->TO.map(double)->TO.map(a => request->TO.fromTask->TO.map(b => a + b))->TO.flatten
    task()->awaitThen(done, a => a->expect->toBe(40))
  })

  testAsync("ap", done => {
    let requestCb = () =>
      Promise.make((resolve, _) => setTimeout(() => resolve(.a => a + 30), 30)->ignore)
    let task = TO.some(5)->TO.ap(requestCb->TO.fromTask)

    task()->awaitThen(done, a => a->expect->toBe(35))
  })
})
