module type Pointed1 = {
  type t<'a>

  let from: 'a => t<'a>
}