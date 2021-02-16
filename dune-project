(lang dune 2.0)
(name afl-persistent)
; version field is optional
(version 1.3)

(generate_opam_files true)

(maintainers "stephen.dolan@cl.cam.ac.uk")
(source (github stedolan/ocaml-afl-persistent))
(license MIT)
(authors "Stephen Dolan")

(package
 (name afl-persistent)
 (synopsis "Use afl-fuzz in persistent mode")
 (description
"\| afl-fuzz normally works by repeatedly fork()ing the program being
"\| tested. using this package, you can run afl-fuzz in 'persistent mode',
"\| which avoids repeated forking and is much faster.
)
 (depends
  (ocaml (>= 4.00))
  base-unix))
