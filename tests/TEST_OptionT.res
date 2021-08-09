open Jest
open REFP

@val external setTimeout: (unit => unit, int) => float = "setTimeout"

let double = x => x * 2

module OT = OptionT

describe("OptionT", () => {
  test("ap", () => {
    let data = Some(5)
    let doubleOption = Some(double)
    data->OT.ap(doubleOption)->OT.match(Functions.identity, () => 0)->expect->toBe(10)
  })
})
