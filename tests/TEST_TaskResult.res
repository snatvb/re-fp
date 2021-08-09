open Jest
open REFP

@val external setTimeout: (unit => unit, int) => float = "setTimeout"

let double = x => x * 2

module TR = TaskResult
module Result = REFP__ResultT.Result

describe("TaskOption", () => {
  let request: Task.t<int> = () =>
    Promise.make((resolve, _) => setTimeout(() => resolve(. 30), 50)->ignore)

  testAsync("fromResult", done => {
    let task = TR.fromResult(Ok(5))
    task()->awaitThen(done, a => a->Result.getWithDefault(0)->expect->toBe(5))
  })

  testAsync("fromIO", done => {
    let task = IO.from(5)->TR.fromIO
    task()->awaitThen(done, a => a->Result.getWithDefault(0)->expect->toBe(5))
  })

  testAsync("fromTask", done => {
    let task = Task.from(5)->TR.fromTask
    task()->awaitThen(done, a => a->Result.getWithDefault(0)->expect->toBe(5))
  })

  testAsync("map", done => {
    let task = TR.ok(5)->TR.map(double)
    task()->awaitThen(done, a => a->Result.getWithDefault(0)->expect->toBe(10))
  })

  testAsync("chain", done => {
    let task = TR.ok(5)->TR.map(double)->TR.chain(a => request->TR.fromTask->TR.map(b => a + b))
    task()->awaitThen(done, a => a->Result.getWithDefault(0)->expect->toBe(40))
  })

  testAsync("flatten", done => {
    let task =
      TR.ok(5)->TR.map(double)->TR.map(a => request->TR.fromTask->TR.map(b => a + b))->TR.flatten
    task()->awaitThen(done, a => a->Result.getWithDefault(0)->expect->toBe(40))
  })

  testAsync("ap", done => {
    let requestCb = () =>
      Promise.make((resolve, _) => setTimeout(() => resolve(.a => a + 30), 30)->ignore)
    let task = TR.ok(5)->TR.ap(requestCb->TR.fromTask)

    task()->awaitThen(done, a => a->Result.getWithDefault(0)->expect->toBe(35))
  })
})
