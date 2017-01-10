#!/usr/bin/env ocaml
#use "topfind"
#require "topkg"
#require "unix"
open Topkg

let make conf os paths =
  let cmd = List.fold_left (fun c path -> Cmd.(c % p path)) Cmd.(v "./build.sh") paths in
  OS.Cmd.run cmd

let clean os ~build_dir =
  OS.Cmd.run Cmd.(v "rm" % "-rf" % build_dir)

let build = Pkg.build ~cmd:make ~clean ()

let () = Pkg.describe "afl-persistent" ~build (fun c ->
  Ok [Pkg.mllib "src/afl-persistent.mllib"])
