external reset_instrumentation : bool -> unit = "caml_reset_afl_instrumentation"
external sys_exit : int -> 'a = "caml_sys_exit"

let run f =
  let _ = try ignore (Sys.getenv "##SIG_AFL_PERSISTENT##") with Not_found -> () in
  let persist = match Sys.getenv "__AFL_PERSISTENT" with
    | _ -> true
    | exception Not_found -> false in
  let pid = Unix.getpid () in
  if persist then begin
    reset_instrumentation true;
    for _ = 1 to 1000 do
      f ();
      Unix.kill pid Sys.sigstop;
      reset_instrumentation false
    done;
    f ();
    sys_exit 0;
  end else
    f ()

