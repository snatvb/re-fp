open REFP__Monad
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

let apError = (mfa, mf) =>
  switch mf {
  | Ok(f) => Ok(f)
  | Error(fe) =>
    switch mfa {
    | Ok(a) => Ok(a)
    | Error(e) => Error(fe(e))
    }
  }

let ok = a => Ok(a)
let error = a => Error(a)

module MakePointed1 = (Item: Pointed1) => {
  let ok = (a: 'a) => a->Result.Ok->Item.from
  let error = a => a->Result.Error->Item.from
}
module MakePointed2 = (Item: Pointed2) => {
  let ok = (a: 'a) => a->Result.Ok->Item.from
  let error = a => a->Result.Error->Item.from
}

module MakeFunctor1 = (Item: Functor1) => {
  let map = (fa, f) => Item.map(fa, ga => Result.map(ga, f))
  let okF = fa => fa->Item.map(a => Result.Ok(a))
  let errorF = fa => fa->Item.map(a => Result.Error(a))
}
module MakeFunctor2 = (Item: Functor2) => {
  let map = (fa, f) => Item.map(fa, ga => Result.map(ga, f))
  let okF = fa => fa->Item.map(a => Result.Ok(a))
  let errorF = fa => fa->Item.map(a => Result.Error(a))
}

module MakeApply1 = (Item: Apply1) => {
  let ap = (fa, mf) => fa->Item.ap(Item.map(mf, (f, a) => ap(a, f)))
  let apError = (fa, mf) => fa->Item.ap(Item.map(mf, (f, a) => apError(a, f)))
}
module MakeApply2 = (Item: Apply2) => {
  let ap = (fa, mf) => fa->Item.ap(Item.map(mf, (f, a) => ap(a, f)))
  let apError = (fa, mf) => fa->Item.ap(Item.map(mf, (f, a) => apError(a, f)))
}

module MakeChain1 = (Item: Monad1) => {
  let chain = (fa, f) =>
    fa->Item.chain(ma =>
      switch ma {
      | Ok(a) => f(a)
      | Error(e) => Item.from(Error(e))
      }
    )
  let chainError = (fa, f) =>
    fa->Item.chain(ma =>
      switch ma {
      | Ok(a) => Ok(a)->Item.from
      | Error(e) => f(e)
      }
    )
}
module MakeChain2 = (Item: Monad2) => {
  let chain = (fa, f) =>
    fa->Item.chain(ma =>
      switch ma {
      | Ok(a) => f(a)
      | Error(e) => Item.from(Error(e))
      }
    )
  let chainError = (fa, f) =>
    fa->Item.chain(ma =>
      switch ma {
      | Ok(a) => Ok(a)->Item.from
      | Error(e) => f(e)
      }
    )
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
module MakeOrLeft2 = (M: REFP__Monad.Monad2) => {
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
module MakeMatch2 = (F: REFP__Functor.Functor2) => {
  let match = (ma, onOk, onError) => ma->F.map(matchResult(onOk, onError))
}

module MakeMapError1 = (F: REFP__Functor.Functor1) => {
  let mapError = (ma, f) => ma->F.map(mapError(_, f))
}
module MakeMapError2 = (F: REFP__Functor.Functor2) => {
  let mapError = (ma, f) => ma->F.map(mapError(_, f))
}

module MakeGetOrElse1 = (M: REFP__Monad.Monad1) => {
  let getOrElse = (fa, onError) => M.chain(fa, matchResult(_, M.from, onError))
}
module MakeGetOrElse2 = (M: REFP__Monad.Monad2) => {
  let getOrElse = (fa, onError) => M.chain(fa, matchResult(_, M.from, onError))
}
