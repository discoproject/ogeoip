module G  = Geoip
module GC = Geoip_city

let dump_city_record host r rest =
  Printf.printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%f\t%f\t%d\t%d\t%s\t[%s]\n"
    host
    (match r.GC.continent_code with None -> "(none)" | Some cc -> cc)
    (match r.GC.country_code with None -> "(none)" | Some cc -> cc)
    r.GC.region
    (match r.GC.region_name with None -> "(none)" | Some rn -> rn)
    r.GC.city
    r.GC.postal_code
    r.GC.latitude
    r.GC.longitude
    (match r.GC.metro_code with Some d -> d | None -> (-1))
    (match r.GC.area_code with Some d -> d | None -> (-1))
    (match r.GC.timezone with Some s -> s | None -> "")
    rest

let open_test_file testdir filename =
  let tfn = Filename.concat testdir filename in
  try open_in tfn
  with Sys_error msg ->
    Printf.eprintf "Unable to open %s\n" msg;
    Printf.eprintf "Check or provide the -test_dir option.\n";
    exit 1

let run_test test =
  try test ()
  with
    | Scanf.Scan_failure s
    | Failure s ->
      Printf.printf "Unable to parse: %s\n" s
    | End_of_file ->
      ()

let country_test g testdir =
  let test_f = open_test_file testdir "country_test.txt" in
  let rec check_lines () =
    Scanf.fscanf test_f "%s %s %s\n"
      (fun ip ecc ecc3 ->
        let cc = (match G.country_code_by_name g ip with None -> "" | Some cc -> cc) in
        let cc3 = (match G.country_code3_by_name g ip with None -> "" | Some cc -> cc) in
        if cc <> ecc || cc3 <> ecc3 then
          Printf.printf "failed lookup for ip %s: cc = %s (expected %s) cc3 = %s (expected %s)\n"
            ip cc ecc cc3 ecc3
      );
    check_lines ()
  in check_lines

let city_test g testdir =
  let test_f = open_test_file testdir "city_test.txt" in
  let rec check_lines () =
    Scanf.fscanf test_f "%s # %s@\n"
      (fun addr rest ->
        match GC.record_by_name g addr with
          | None -> Printf.eprintf "lookup for ip %s failed (%s)\n" addr rest
          | Some r -> dump_city_record addr r rest
      );
    check_lines ()
  in check_lines

let test show_info datfile testdir =
  let did_test = ref false in
  let g = G.geoip_open datfile in
  if show_info then begin
    Printf.printf "GeoIP initialized:\nedition: %s\n" (G.edition_name g.G.edition);
    Printf.printf "segment_size: %d\nrecord_length: %d\n" g.G.segment_size g.G.record_length;
    Printf.printf "dyn_seg_size: %d%!\n" g.G.dyn_seg_size
  end;
  if (g.G.edition = G.GEOIP_COUNTRY_EDITION || g.G.edition = G.GEOIP_LARGE_COUNTRY_EDITION
      || g.G.edition = G.GEOIP_PROXY_EDITION || g.G.edition = G.GEOIP_NETSPEED_EDITION)
  then (did_test := true; run_test (country_test g testdir));
  if (g.G.edition = G.GEOIP_CITY_EDITION_REV0 || g.G.edition = G.GEOIP_CITY_EDITION_REV1
      || g.G.edition = G.GEOIP_CITYCONFIDENCE_EDITION || g.G.edition = G.GEOIP_CITYCONFIDENCEDIST_EDITION)
  then (did_test := true; run_test (city_test g testdir));
  if not !did_test then
    Printf.printf "tests not yet supported for %s\n" (G.edition_name g.G.edition)

let _ =
  Printexc.record_backtrace true;
  let datfile = ref "" in
  let testdir = ref "./" in
  let info = ref false in
  let usage = Printf.sprintf "%s [options]" Sys.argv.(0) in
  let spec = [("-dat", Arg.Set_string datfile, " path to geoip data file");
              ("-info", Arg.Set info, " show db file info");
              ("-test_dir", Arg.Set_string testdir, " path to dir with test data")] in
  Arg.parse spec (fun _ -> ()) usage;
  if !datfile = "" then begin
    Printf.eprintf "No dat file specified.\n";
    Arg.usage spec usage;
    exit 1
  end;
  try test !info !datfile !testdir
  with e ->
    Printf.eprintf "Uncaught exception: %s\n" (Printexc.to_string e);
    Printf.eprintf "%s\n" (Printexc.get_backtrace ());
    (match e with
      | G.Geoip_error e ->
        Printf.eprintf "exception: %s\n" (G.string_of_error e)
      | _ -> ()
    )
