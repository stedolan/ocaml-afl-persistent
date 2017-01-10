#!/bin/sh

set -e
set -x
cd `dirname $0`
rm -rf _build/
mkdir _build

OCAMLC='ocamlc -g -bin-annot'
OCAMLOPT='ocamlopt -g -bin-annot -afl-inst-ratio 0'

cd _build
cp ../aflPersistent.{ml,mli} .

$OCAMLC -c aflPersistent.mli

$OCAMLC -c aflPersistent.ml
$OCAMLC -a aflPersistent.cmo -o afl-persistent.cma

$OCAMLOPT -c aflPersistent.ml
$OCAMLOPT -a aflPersistent.cmx -o afl-persistent.cmxa
