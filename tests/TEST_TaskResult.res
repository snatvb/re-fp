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

  testAsync("mapError", done => {
    let task = TR.error("not found")->TR.mapError(err => `Error: ${err}`)
    task()->awaitThen(
      done,
      REFP__ResultT.matchResult(
        _,
        _ => "Unreachable"->expect->toBe("Error: not found"),
        e => e->expect->toBe("Error: not found"),
      ),
    )
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

  testAsync("traverseArray", done => {
    let task = [1, 2, 3]->TR.traverseArray(TR.ok)->TR.map(Belt.Array.map(_, double))
    task()->awaitThen(done, a => a->Result.getWithDefault([0])->expect->toEqual([2, 4, 6]))
  })

  testAsync("sequnceArray", done => {
    let task = [1, 2, 3]->Belt.Array.map(TR.ok)->TR.sequenceArray
    task()->awaitThen(done, a => a->Result.getWithDefault([0])->expect->toEqual([1, 2, 3]))
  })
})
