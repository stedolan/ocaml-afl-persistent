#!/bin/sh

set -e
set -x
cd `dirname $0`
rm -rf _build/
mkdir _build


OCAMLC='ocamlc -g -bin-annot'
OCAMLOPT='ocamlopt -g -bin-annot -afl-inst-ratio 0'

cd _build

mkdir src; cd src
cp ../../src/aflPersistent.ml ../../src/aflPersistent.mli .
$OCAMLC -c aflPersistent.mli

$OCAMLC -c aflPersistent.ml
$OCAMLC -a aflPersistent.cmo -o afl-persistent.cma

$OCAMLOPT -c aflPersistent.ml
$OCAMLOPT -a aflPersistent.cmx -o afl-persistent.cmxa

touch afl-persistent.cmxs # FIXME
cd ..


for target in "$@"; do
    if [ ! -e "$target" ]; then
        if [ -e ../"$target" ]; then
            mkdir -p `dirname "$target"`
            cp ../"$target" "$target"
        fi
        if [ ! -e "$target" ]; then
            echo "Can't build $target" > /dev/stderr
            exit 2
        fi
    fi
done
