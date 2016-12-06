#!/usr/bin/env ocaml
#use "topfind"
#require "topkg"
open Topkg

let () = Pkg.describe "afl-persistent" (fun c ->
  Ok [Pkg.mllib "src/afl-persistent.mllib"])
