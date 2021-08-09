module type Comparable1 = {
  type t<'a>

  let eq: (t<'a>, t<'a>) => bool
}
