let run f =
  let _ = try ignore (Sys.getenv "##SIG_AFL_PERSISTENT##") with Not_found -> () in
  let persist = match Sys.getenv "__AFL_PERSISTENT" with
    | _ -> true
    | exception Not_found -> false in
  if persist then
    for i = 1 to 1000 do
      f ();
      Unix.kill (Unix.getpid ()) Sys.sigstop;
    done
  else
    f ()

