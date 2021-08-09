open REFP__Chain
open REFP__Pointed
open REFP__Functor
open REFP__Applicative
module Result = Belt.Result

let matchResult = (ma, onOk, onError) =>
  switch ma {
  | Ok(a) => onOk(a)
  | Error(e) => onError(e)
  }

let mapError = (ma, f) =>
  switch ma {
  | Error(a) => Error(f(a))
  | Ok(a) => Ok(a)
  }

let chainError = (ma, f) =>
  switch ma {
  | Error(a) => f(a)
  | Ok(a) => Ok(a)
  }

let ap = (mfa, mf) =>
  switch mf {
  | Ok(f) =>
    switch mfa {
    | Ok(a) => Ok(f(a))
    | Error(e) => Error(e)
    }
  | Error(e) => Error(e)
  }

let ok = a => Ok(a)
let error = a => Error(a)

module MakePointed1 = (Item: Pointed1) => {
  let ok = (a: 'a) => a->Result.Ok->Item.from
  let error = a => a->Result.Error->Item.from
}

module MakeFunctor1 = (Item: Functor1) => {
  let map = (f, fa) => Item.map(fa, ga => Result.map(ga, f))
  let okF = fa => fa->Item.map(a => Result.Ok(a))
  let errorF = fa => fa->Item.map(a => Result.Error(a))
}

module MakeApply1 = (Item: Apply1) => {
  let ap = (fa, mf) => fa->Item.ap(Item.map(mf, (f, a) => ap(a, f)))
}

module MakeChain1 = (Item: Chain1) => {
  let chain = fa => fa->Item.chain
}

module MakeOrLeft1 = (M: REFP__Monad.Monad1) => {
  let orError = (ma, f) =>
    ma->M.chain(ra =>
      switch ra {
      | Ok(a) => a->Ok->M.from
      | Error(e) => e->f->M.map(error)
      }
    )
}

module MakeMatch1 = (F: REFP__Functor.Functor1) => {
  let match = (ma, onOk, onError) => ma->F.map(matchResult(onOk, onError))
}

module MakeMapError1 = (F: REFP__Functor.Functor1) => {
  let mapError = (a, f) => a->F.map(f->mapError(_))
}

module MakeGetOrElse = (M: REFP__Monad.Monad1) => {
  let getOrElse = (onOk, fa) => M.chain(fa, matchResult(onOk, M.from))
}
