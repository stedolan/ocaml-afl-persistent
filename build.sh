#!/bin/bash

set -e
set -x
cd `dirname $0`
rm -rf _build/; rm -f afl-persistent.config
mkdir _build; cd _build

ocamlc='ocamlc -g -bin-annot'
ocamlopt='ocamlopt -g -bin-annot'

echo 'print_string "hello"' > afl_check.ml

if ocamlopt -dcmm -c afl_check.ml 2>&1 | grep -q caml_afl; then
    afl_always=true
else
    afl_always=false
fi

if [ "$(ocamlopt -afl-instrument afl_check.ml -o test 2>/dev/null && ./test)" = "hello" ]; then
    ocamlopt="$ocamlopt -afl-inst-ratio 0"
    afl_available=true
elif [ "$(ocamlopt -version)" = 4.04.0+afl ]; then
    # hack for the backported 4.04+afl branch
    export AFL_INST_RATIO=0
    afl_available=true
else
    afl_available=false
fi

cat > ../afl-persistent.config <<EOF
opam-version: "1.2"
afl-available: $afl_available
afl-always: $afl_always
EOF


cp ../aflPersistent.mli .
if [ $afl_available = true ]; then
    cp ../aflPersistent.ml .
else
    cp ../aflPersistent-stub.ml aflPersistent.ml
fi

$ocamlc -c aflPersistent.mli

$ocamlc -c aflPersistent.ml
$ocamlc -a aflPersistent.cmo -o afl-persistent.cma

$ocamlopt -c aflPersistent.ml
$ocamlopt -a aflPersistent.cmx -o afl-persistent.cmxa

# test
cp ../test.ml .
ocamlc unix.cma afl-persistent.cma test.ml -o test && ./test
ocamlopt unix.cmxa afl-persistent.cmxa test.ml -o test && ./test
