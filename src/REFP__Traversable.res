module type Traversable1 = {
  type t<'a>
  type g<'a>

  let traverse: (module(REFP__Applicative.Applicative1), g<'a>, 'a => t<'b>) => t<g<'b>>
  let sequence: g<t<'a>> => t<g<'a>>
}

module type TraversableArray1 = {
  type t<'a>
  include Traversable1 with type t<'a> := t<'a> and type g<'a> := array<'a>
}

module ArrayTraversable1 = (A: REFP__Applicative.Applicative1) => {
  let traverseArray = (ga: array<'a>, f: 'a => A.t<'b>): A.t<array<'b>> => {
    Belt.Array.reduce(ga, A.from([]), (fbs, a) =>
      A.ap(
        f(a),
        A.map(fbs, (bs, b) => {
          bs->Js.Array2.push(b)->ignore
          bs
        }),
      )
    )
  }

  let sequenceArray = traverseArray(_, REFP__Functions.identity)
}

module ArrayTraversable2 = (A: REFP__Applicative.Applicative2) => {
  let traverseArray = (ga: array<'a>, f: 'a => A.t<'b, 'c>): A.t<array<'b>, 'c> => {
    Belt.Array.reduce(ga, A.from([]), (fbs, a) =>
      A.ap(
        f(a),
        A.map(fbs, (bs, b) => {
          bs->Js.Array2.push(b)->ignore
          bs
        }),
      )
    )
  }

  let sequenceArray = traverseArray(_, REFP__Functions.identity)
}
