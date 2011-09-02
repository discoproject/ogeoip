module G  = Geoip
module GC = Geoip_city

let test_ips = Array.of_list ["24.24.24.24"; "80.24.24.80"; "200.24.24.40"; "68.24.24.46"]

let start_time = ref 0.0
let timer_start () =
  start_time := Unix.gettimeofday ()
let timer_stop () =
  let ret = Unix.gettimeofday () -. !start_time in
  start_time := 0.0;
  ret

exception Skip_test

let open_dat_file datdir filename =
  let fn = Filename.concat datdir filename in
  try G.geoip_open fn
  with Unix.Unix_error (ec, "open", _) ->
    Printf.eprintf "Unable to open %s: %s\n" fn (Unix.error_message ec);
    Printf.eprintf "Check or provide the -dat_dir option.\n";
    raise Skip_test


let show_stats edname edfile iters duration =
  Printf.printf "%s (%s): %d lookups in %f seconds (%d/sec)\n"
    edname edfile iters duration (int_of_float ((float_of_int iters) /. duration))

let test_country datdir iters =
  let g = open_dat_file datdir "GeoIP.dat" in
  let num_ips = Array.length test_ips in
  timer_start ();
  for i = 0 to iters do
    if G.country_name_by_name g test_ips.(i mod num_ips) = None then begin
      Printf.printf "Unable to lookup %s\n" test_ips.(i mod num_ips);
      exit 1
    end
  done;
  show_stats "GeoIP Country" "GeoIP.dat" iters (timer_stop ())

let test_city datdir iters filename =
  let g = open_dat_file datdir filename in
  let num_ips = Array.length test_ips in
  timer_start ();
  for i = 0 to iters do
    if GC.record_by_name g test_ips.(i mod num_ips) = None then begin
      Printf.printf "Unable to lookup %s\n" test_ips.(i mod num_ips);
      exit 1
    end
  done;
  show_stats "GeoIP City" filename iters (timer_stop ())

let _ =
  Printexc.record_backtrace true;
  let datdir = ref "" in
  let iters = ref 30000 in
  let usage = Printf.sprintf "%s [options]" Sys.argv.(0) in
  let spec = [("-dat_dir", Arg.Set_string datdir, " path to dir containing geoip data files");
              ("-num", Arg.Set_int iters, " number of iterations")] in
  Arg.parse spec (fun _ -> ()) usage;
  if !datdir = "" then begin
    Printf.eprintf "No data directory specified.\n";
    Arg.usage spec usage;
    exit 1
  end;
  (try test_country !datdir !iters with Skip_test -> ());
  (try test_city !datdir !iters "GeoLiteCity.dat" with Skip_test -> ());
  (try test_city !datdir !iters "GeoIPCity.dat" with Skip_test -> ());
