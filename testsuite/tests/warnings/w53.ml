(* TEST_BELOW
(* Blank lines added here to preserve locations. *)







*)

let h x = x [@inline] (* rejected *)
let h x = x [@ocaml.inline] (* rejected *)

let i x = x [@inlined] (* rejected *)
let j x = x [@ocaml.inlined] (* rejected *)
let k x = (h [@inlined]) x (* accepted *)
let k' x = (h [@ocaml.inlined]) x (* accepted *)
let l x = h x [@inlined] (* rejected *)

let m x = x [@tailcall] (* rejected *)
let n x = x [@ocaml.tailcall] (* rejected *)
let o x = (h [@tailcall]) x (* accepted *)
let p x = (h [@ocaml.tailcall]) x (* accepted *)
let q x = h x [@tailcall] (* rejected *)

module type E = sig end

module A(E:E) = struct end [@@inline] (* accepted *)
module A'(E:E) = struct end [@@ocaml.inline] (* accepted *)
module B = ((functor (E:E) -> struct end) [@inline]) (* accepted *)
module B' = ((functor (E:E) -> struct end) [@ocaml.inline]) (* accepted *)
module C = struct end [@@inline] (* rejected *)
module C' = struct end [@@ocaml.inline] (* rejected *)
module D = struct end [@@inlined] (* rejected *)
module D' = struct end [@@ocaml.inlined] (* rejected *)

module F = (A [@inlined])(struct end) (* accepted *)
module F' = (A [@ocaml.inlined])(struct end) (* accepted *)
module G = (A [@inline])(struct end) (* rejected *)
module G' = (A [@ocaml.inline])(struct end) (* rejected *)

module H = Set.Make [@inlined] (Int32) (* GPR#1808 *)

module I = Set.Make [@inlined]
module I' = Set.Make [@ocaml.inlined]

module J = Set.Make [@@inlined]
module J' = Set.Make [@@ocaml.inlined]

(* TEST
 flags = "-w +A-60-70";
 setup-ocamlc.byte-build-env;
 compile_only = "true";
 ocamlc.byte;
 check-ocamlc.byte-output;
*)
