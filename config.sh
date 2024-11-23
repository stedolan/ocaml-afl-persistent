#!/bin/sh

set -e
tmpdir="$(mktemp -d 2>/dev/null || mktemp -d -t 'mytmpdir')"
curdir="$(pwd)"
output="$(pwd)/afl-persistent.config"
cd "$tmpdir"
echo 'print_string "Hello"' > test.ml
if ocamlopt -dcmm -c test.ml 2>&1 | grep -q caml_afl; then
    afl_always=true
else
    afl_always=false
fi
rm test.*
cd "$curdir"
rmdir "$tmpdir"

cat > "$output" <<EOF
opam-version: "1.2"
afl-available: true
afl-always: $afl_always
EOF
