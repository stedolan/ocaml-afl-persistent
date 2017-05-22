let () =
  AflPersistent.run (fun () -> exit 0);
  failwith "AflPersistent.run failed"
