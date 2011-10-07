open Bigarray

type edition =
  | GEOIP_UNKNOWN
  | GEOIP_COUNTRY_EDITION
  | GEOIP_CITY_EDITION_REV1
  | GEOIP_REGION_EDITION_REV1
  | GEOIP_ISP_EDITION
  | GEOIP_ORG_EDITION
  | GEOIP_CITY_EDITION_REV0
  | GEOIP_REGION_EDITION_REV0
  | GEOIP_PROXY_EDITION
  | GEOIP_ASNUM_EDITION
  | GEOIP_NETSPEED_EDITION
  | GEOIP_DOMAIN_EDITION
  | GEOIP_COUNTRY_EDITION_V6
  | GEOIP_LOCATIONA_EDITION
  | GEOIP_ACCURACYRADIUS_EDITION
  | GEOIP_CITYCONFIDENCE_EDITION
  | GEOIP_CITYCONFIDENCEDIST_EDITION
  | GEOIP_LARGE_COUNTRY_EDITION
  | GEOIP_LARGE_COUNTRY_EDITION_V6
  | GEOIP_CITYCONFIDENCEDIST_ISP_ORG_EDITION
  | GEOIP_CCM_COUNTRY_EDITION
  | GEOIP_ASNUM_EDITION_V6
  | GEOIP_ISP_EDITION_V6
  | GEOIP_ORG_EDITION_V6
  | GEOIP_DOMAIN_EDITION_V6
  | GEOIP_LOCATIONA_EDITION_V6
  | GEOIP_REGISTRAR_EDITION
  | GEOIP_REGISTRAR_EDITION_V6
  | GEOIP_USERTYPE_EDITION
  | GEOIP_USERTYPE_EDITION_V6
  | GEOIP_CITY_EDITION_REV1_V6
  | GEOIP_CITY_EDITION_REV0_V6
  | GEOIP_NETSPEED_EDITION_REV1
  | GEOIP_NETSPEED_EDITION_REV1_V6

type charset =
  | Charset_ISO8859_1
  | Charset_UTF8

module StringMap = Map.Make (struct type t = string let compare = compare end)

type geoip = {
  edition: edition;
  charset: charset;

  fd: Unix.file_descr;
  map: (int, int8_unsigned_elt, c_layout) Array1.t;
  size: int;
  segment_size: int;
  record_length: int;
  dyn_seg_size: int;

  timezones: string StringMap.t;
  regions: string StringMap.t;
}

type error =
  | Unsupported_edition of edition
  | Unexpected_edition of (* expected *) edition * (* found *) edition
  | Invalid_ipv4_address of string
  | Ipv6_not_supported of string

exception Geoip_error of error

let edition_info = [|
  (GEOIP_UNKNOWN, "Unknown");
  (GEOIP_COUNTRY_EDITION, "GeoIP Country Edition");
  (GEOIP_CITY_EDITION_REV1, "GeoIP City Edition, Rev 1");
  (GEOIP_REGION_EDITION_REV1, "GeoIP Region Edition, Rev 1");
  (GEOIP_ISP_EDITION, "GeoIP ISP Edition");
  (GEOIP_ORG_EDITION, "GeoIP Organization Edition");
  (GEOIP_CITY_EDITION_REV0, "GeoIP City Edition, Rev 0");
  (GEOIP_REGION_EDITION_REV0, "GeoIP Region Edition, Rev 0");
  (GEOIP_PROXY_EDITION, "GeoIP Proxy Edition");
  (GEOIP_ASNUM_EDITION, "GeoIP ASNum Edition");
  (GEOIP_NETSPEED_EDITION, "GeoIP Netspeed Edition");
  (GEOIP_DOMAIN_EDITION, "GeoIP Domain Name Edition");
  (GEOIP_COUNTRY_EDITION_V6, "GeoIP Country V6 Edition");
  (GEOIP_LOCATIONA_EDITION, "GeoIP LocationID ASCII Edition");
  (GEOIP_ACCURACYRADIUS_EDITION, "GeoIP Accuracy Radius Edition");
  (GEOIP_CITYCONFIDENCE_EDITION, "GeoIP City with Confidence Edition");
  (GEOIP_CITYCONFIDENCEDIST_EDITION, "GeoIP City with Confidence and Accuracy Edition");
  (GEOIP_LARGE_COUNTRY_EDITION, "GeoIP Large Country Edition");
  (GEOIP_LARGE_COUNTRY_EDITION_V6, "GeoIP Large Country V6 Edition");
  (GEOIP_CITYCONFIDENCEDIST_ISP_ORG_EDITION, "GeoIP City with Confidence, ISP, Organization Edition");
  (GEOIP_CCM_COUNTRY_EDITION, "GeoIP CCM Edition");
  (GEOIP_ASNUM_EDITION_V6, "GeoIP ASNum V6 Edition");
  (GEOIP_ISP_EDITION_V6, "GeoIP ISP V6 Edition");
  (GEOIP_ORG_EDITION_V6, "GeoIP Organization V6 Edition");
  (GEOIP_DOMAIN_EDITION_V6, "GeoIP Domain Name V6 Edition");
  (GEOIP_LOCATIONA_EDITION_V6, "GeoIP LocationID ASCII V6 Edition");
  (GEOIP_REGISTRAR_EDITION, "GeoIP Registrar Edition");
  (GEOIP_REGISTRAR_EDITION_V6, "GeoIP Registrar V6 Edition");
  (GEOIP_USERTYPE_EDITION, "GeoIP UserType Edition");
  (GEOIP_USERTYPE_EDITION_V6, "GeoIP UserType V6 Edition");
  (GEOIP_CITY_EDITION_REV1_V6, "GeoIP City Edition V6, Rev 1");
  (GEOIP_CITY_EDITION_REV0_V6, "GeoIP City Edition V6, Rev 0");
  (GEOIP_NETSPEED_EDITION_REV1, "GeoIP Netspeed Edition, Rev 1");
  (GEOIP_NETSPEED_EDITION_REV1_V6, "GeoIP Netspeed Edition V6, Rev1");
|]

let sTRUCTURE_INFO_MAX_SIZE = 20

let sEGMENT_RECORD_LENGTH = 3
let lARGE_SEGMENT_RECORD_LENGTH = 4
let sTANDARD_RECORD_LENGTH = 3
let oRG_RECORD_LENGTH = 4
let mAX_RECORD_LENGTH = 4

let cOUNTRY_BEGIN = 16776960
let lARGE_COUNTRY_BEGIN = 16515072
let sTATE_BEGIN_REV0 = 16700000
let sTATE_BEGIN_REV1 = 16000000
let sTRUCTURE_INFO_MAX_SIZE = 20

let is_valid_edition int =
  (* 0 is not a known edition *)
  int > 0 && int < Array.length edition_info

let edition_of int =
  if int < 0 && int > Array.length edition_info then None
  else Some (fst edition_info.(int))

let edition_name_of int =
  if int < 0 && int > Array.length edition_info then "Unknown"
  else snd edition_info.(int)

let edition_name ed =
  try List.assoc ed (Array.to_list edition_info)
  with Not_found -> "Unknown"

let string_of_error = function
  | Unsupported_edition edition ->
    Printf.sprintf "edition '%s' is not supported" (edition_name edition)
  | Unexpected_edition (exp, found) ->
    Printf.sprintf "expecting edition '%s', found edition '%s'" (edition_name exp) (edition_name found)
  | Invalid_ipv4_address addr ->
    Printf.sprintf "invalid IPv4 address: %s" addr
  | Ipv6_not_supported addr ->
    Printf.sprintf "unsupported IPv6 address: %s" addr

(*
let verbose = ref false
let dbg fmt =
  let logger s = if !verbose then Printf.eprintf "%s\n%!" s
  in Printf.ksprintf logger fmt
*)

let int_from_bytes map ofs len =
  if len = 3 then
    map.{ofs + 0} lsl (0*8) + map.{ofs + 1} lsl (1*8) + map.{ofs + 2} lsl (2*8)
  else begin
    let sz = ref 0 in
    for j = 0 to len - 1 do
      sz := !sz + map.{ofs + j} lsl (j * 8)
    done;
    !sz
  end

let string_from_bytes map ofs =
  let len = ref 0 in
  while map.{ofs + !len} <> 0 do len := !len + 1 done;
  let s = String.create !len in
  for i = 0 to !len - 1 do
    s.[i] <- Char.chr map.{ofs + i}
  done;
  s

let geoip_open fname =
  let fd = Unix.openfile fname [Unix.O_RDONLY] 0 in
  let st = Unix.fstat fd in
  let size = st.Unix.st_size in
  let map = (Array1.map_file fd int8_unsigned c_layout
               (* shared *) false (-1)) in
  (* let _ = dbg "starting scan at offset %d" size in *)
  let rec setup_segments i : (edition
                              * (* segment_size *) int
                              * (* record_length *) int
                              * (* dynamic_segment_size *) int) =
    if i >= sTRUCTURE_INFO_MAX_SIZE then begin
      (GEOIP_COUNTRY_EDITION, cOUNTRY_BEGIN, sTANDARD_RECORD_LENGTH, 0)
    end else begin
      let ofs = size - 3 - i in
      (* dbg " read 3 bytes at offset %d: [%d] [%d] [%d]" ofs map.{ofs} map.{ofs + 1} map.{ofs + 2}; *)
      if map.{ofs} == 255 && map.{ofs + 1} == 255 && map.{ofs + 2} == 255 then begin
        let ed = map.{ofs + 3} in
        let ed = if ed >= 106 then ed - 105 else ed in
        match edition_of ed with
          | None ->
            (* dbg "  no edition found matching code %d, rewinding ..." ed; *)
            setup_segments (i + 1)
          | Some edition ->
            (match edition with
              | GEOIP_REGION_EDITION_REV0 ->
                (edition, sTATE_BEGIN_REV0, sTANDARD_RECORD_LENGTH, 0)
              | GEOIP_REGION_EDITION_REV1 ->
                (edition, sTATE_BEGIN_REV1, sTANDARD_RECORD_LENGTH, 0)
              | GEOIP_COUNTRY_EDITION
              | GEOIP_PROXY_EDITION
              | GEOIP_NETSPEED_EDITION
              | GEOIP_COUNTRY_EDITION_V6 ->
                (edition, cOUNTRY_BEGIN, sTANDARD_RECORD_LENGTH, 0)
              | GEOIP_LARGE_COUNTRY_EDITION
              | GEOIP_LARGE_COUNTRY_EDITION_V6 ->
                (edition, lARGE_COUNTRY_BEGIN, sTANDARD_RECORD_LENGTH, 0)
              | GEOIP_CITY_EDITION_REV0
              | GEOIP_CITY_EDITION_REV1
              | GEOIP_ORG_EDITION
              | GEOIP_ORG_EDITION_V6
              | GEOIP_DOMAIN_EDITION
              | GEOIP_DOMAIN_EDITION_V6
              | GEOIP_ISP_EDITION
              | GEOIP_ISP_EDITION_V6
              | GEOIP_REGISTRAR_EDITION
              | GEOIP_REGISTRAR_EDITION_V6
              | GEOIP_USERTYPE_EDITION
              | GEOIP_USERTYPE_EDITION_V6
              | GEOIP_ASNUM_EDITION
              | GEOIP_ASNUM_EDITION_V6
              | GEOIP_NETSPEED_EDITION_REV1
              | GEOIP_NETSPEED_EDITION_REV1_V6
              | GEOIP_LOCATIONA_EDITION
              | GEOIP_ACCURACYRADIUS_EDITION
              | GEOIP_CITYCONFIDENCE_EDITION
              | GEOIP_CITYCONFIDENCEDIST_EDITION
              | GEOIP_CITY_EDITION_REV0_V6
              | GEOIP_CITY_EDITION_REV1_V6 ->
                let segment_record_length =
                  if edition == GEOIP_CITYCONFIDENCEDIST_EDITION
                  then lARGE_SEGMENT_RECORD_LENGTH
                  else sEGMENT_RECORD_LENGTH in
                let segment_size = int_from_bytes map (ofs + 4) segment_record_length in
                (* dbg " read %d bytes at offset %d to get segment size of %d (edition %s)"
                   segment_record_length (ofs + 4) segment_size (edition_name_of ed); *)
                (match edition with
                  | GEOIP_ORG_EDITION
                  | GEOIP_ORG_EDITION_V6
                  | GEOIP_DOMAIN_EDITION
                  | GEOIP_DOMAIN_EDITION_V6
                  | GEOIP_ISP_EDITION
                  | GEOIP_ISP_EDITION_V6
                  | GEOIP_CITYCONFIDENCE_EDITION
                  | GEOIP_CITYCONFIDENCEDIST_EDITION ->
                    let record_length = oRG_RECORD_LENGTH in
                    (if edition = GEOIP_CITYCONFIDENCE_EDITION or edition = GEOIP_CITYCONFIDENCEDIST_EDITION
                     then
                        let dyn_size_ofs = segment_size * 2 * record_length in
                        (edition, segment_size, record_length, (int_from_bytes map dyn_size_ofs record_length))
                     else
                        (edition, segment_size, oRG_RECORD_LENGTH, 0)
                    )
                  | _ -> (edition, segment_size, sTANDARD_RECORD_LENGTH, 0)
                )
              | _ -> raise (Geoip_error (Unsupported_edition edition))
            )
      end else
        setup_segments (i + 1)
    end in
  let edition, segment_size, record_length, dyn_seg_size = setup_segments 0 in
  let timezones = List.fold_left (fun m (k, v) -> StringMap.add k v m) StringMap.empty Geoip_timezones.table in
  let regions   = List.fold_left (fun m (k, v) -> StringMap.add k v m) StringMap.empty Geoip_regions.table in
  {edition = edition; charset = Charset_ISO8859_1;
   fd; map; size; segment_size; record_length; dyn_seg_size;
   timezones; regions}

(* We can't use Unix.inet_addr_of_string since we need an integer, and
   Unix.inet_addr is an abstract type. *)
let ipv4_addr_to_num s =
  let octet = ref 0 in
  let ipnum = ref 0 in
  let dots = ref 3 in
  let exc = Geoip_error (Invalid_ipv4_address s) in
  let len = String.length s - 1 in
  if s.[0] = '.' || s.[len] = '.' then raise exc;
  for i = 0 to len do
    if s.[i] = '.' then begin
      if !octet > 255 then raise exc;
      ipnum := (!ipnum lsl 8) + !octet;
      dots := !dots - 1;
      octet := 0;
    end else begin
      let dig = Char.code(s.[i]) - Char.code('0') in
      if dig > 9 then raise exc;
      octet := (!octet lsl 3) + !octet + !octet + dig;
    end
  done;
  if !octet > 255 || !dots <> 0 then raise exc;
  (!ipnum lsl 8) + !octet

let host_to_num s =
  match (try Some (Unix.gethostbyname s) with Not_found -> None) with
    | None -> None
    | Some hent when hent.Unix.h_addrtype <> Unix.PF_INET -> None
    | Some hent -> Some (ipv4_addr_to_num (Unix.string_of_inet_addr hent.Unix.h_addr_list.(0)))

exception Found of int
let _seek_record gi ipnum =
  let offset = ref 0 in
  for depth = 31 downto 0 do
    let x =
      if ipnum land (1 lsl depth) <> 0 then begin
        (* dbg "seek offset at depth %d is %d: taking right branch" depth !offset; *)
        int_from_bytes gi.map (gi.record_length * (2 * !offset + 1)) gi.record_length
      end else begin
        (* dbg "seek offset at depth %d is %d: taking left branch" depth !offset; *)
        int_from_bytes gi.map (gi.record_length * 2 * !offset) gi.record_length
      end
    in
    if x >= gi.segment_size then raise (Found x)
    else offset := x
  done;
  None

let seek_record gi ipnum =
  (* dbg "\nSeeking for %d:" ipnum; *)
  try _seek_record gi ipnum with Found recofs -> Some recofs

let proc_opt f = function
  | None -> None
  | Some v -> f v

let id_by_name gi name =
  proc_opt (fun ofs -> Some (ofs - gi.segment_size)) (proc_opt (seek_record gi) (host_to_num name))

let country_code_by_name gi name =
  proc_opt Geoip_tables.country_code_of (id_by_name gi name)

let country_code3_by_name gi name =
  proc_opt Geoip_tables.country_code3_of (id_by_name gi name)

let country_name_by_name gi name =
  proc_opt (Geoip_tables.country_name_of gi) (id_by_name gi name)

let country_continent_by_name gi name =
  proc_opt Geoip_tables.country_continent_of (id_by_name gi name)

let timezone_by_country_and_region gi opt_cc region =
  proc_opt
    (fun cc ->
      try Some (StringMap.find (Printf.sprintf "%s/%s" cc region) gi.timezones)
      with Not_found -> None) opt_cc

let region_name_by_code gi opt_cc region =
  proc_opt
    (fun cc ->
      try Some (StringMap.find (Printf.sprintf "%s/%s" cc region) gi.regions)
      with Not_found -> None) opt_cc


(* API for City editions. *)

type geoip_record = {
  (* no charset for now *)
  continent_code: string option;
  country_code: string option;
  country_code3: string option;
  country_name: string option;
  region: string;
  region_name: string option;
  city: string;
  postal_code: string;
  latitude: float;
  longitude: float;

  metro_code: int option;
  area_code: int option;
  timezone: string option;

  (* confidence factors *)
  country_conf: char option;
  region_conf: char option;
  city_conf: char option;
  postal_conf: char option;
  accuracy_radius: int option;
}

let fULL_RECORD_LENGTH = 50

let _extract_city_record gi seek_record =
  (* TODO: handle CITYCONFIDENCE_EDITION and CITYCONFIDENCEDIST_EDITION editions *)
  let country_conf, region_conf, city_conf, postal_conf, accuracy_radius =
    None, None, None, None, None in
  if seek_record = gi.segment_size then None
  else begin
    let record_pointer = ref (seek_record + (2 * gi.record_length - 1) * gi.segment_size) in
    (* let begin_record = ref (!record_pointer) in *)

    (* dbg "  reading record at offset: %d = %d + (2 * %d - 1) * %dn"
       !record_pointer seek_record gi.record_length gi.segment_size; *)

    (* country *)
    (* dbg "  using country_code of %d ..." gi.map.{!record_pointer}; *)

    let continent_code = Geoip_tables.country_continent_of gi.map.{!record_pointer} in
    let country_code   = Geoip_tables.country_code_of gi.map.{!record_pointer} in
    let country_code3  = Geoip_tables.country_code3_of gi.map.{!record_pointer} in
    let country_name   = Geoip_tables.country_name_of gi gi.map.{!record_pointer} in
    incr record_pointer;

    (* region *)
    let region = string_from_bytes gi.map !record_pointer in
    (* dbg "  reading region of %d bytes at record_offset %d: %s"
       (String.length region) (!record_pointer - !begin_record) region; *)
    record_pointer := !record_pointer + String.length region + 1;

    (* city *)
    let city = string_from_bytes gi.map !record_pointer in
    (* dbg "  reading city of %d bytes at record_offset %d: %s"
       (String.length city) (!record_pointer - !begin_record) city; *)
    record_pointer := !record_pointer + String.length city + 1;

    (* postal code *)
    let postal_code = string_from_bytes gi.map !record_pointer in
    (* dbg "  reading postal code of %d bytes at record_offset %d: %s"
       (String.length postal_code) (!record_pointer - !begin_record) postal_code; *)
    record_pointer := !record_pointer + String.length postal_code + 1;

    (* latitude/longitude *)
    let latitude  = float_of_int (int_from_bytes gi.map !record_pointer 3) /. 10000.0 -. 180.0 in
    (* dbg "  reading latitude of %d bytes at record_offset %d: %f"
       3 (!record_pointer - !begin_record) latitude; *)
    record_pointer := !record_pointer + 3;
    let longitude = float_of_int (int_from_bytes gi.map !record_pointer 3) /. 10000.0 -. 180.0 in
    (* dbg "  reading longitude of %d bytes at record_offset %d: %f"
       3 (!record_pointer - !begin_record) longitude; *)
    record_pointer := !record_pointer + 3;

    (* get area code and metro code for post April 2002 databases and
       for US locations *)
    let metro_code, area_code =
      if (gi.edition = GEOIP_CITY_EDITION_REV1 || gi.edition = GEOIP_CITYCONFIDENCE_EDITION)
        && country_code = Some "US"
      then begin
        let combo = int_from_bytes gi.map !record_pointer 3 in
        (* dbg "  reading metroarea_code of %d bytes at record_offset %d: %d"
           3 (!record_pointer - !begin_record) combo; *)
        Some (combo / 1000), Some (combo mod 1000)
      end else
        None, None in
    let timezone = timezone_by_country_and_region gi country_code region in
    let region_name = region_name_by_code gi country_code region in
    Some {continent_code = continent_code;
          country_code; country_code3; country_name; region; region_name; city; postal_code;
          latitude; longitude; metro_code; area_code; timezone;
          country_conf; region_conf; city_conf; postal_conf; accuracy_radius}
  end

let extract_city_record gi recofs =
  match gi.edition with
    | GEOIP_CITY_EDITION_REV0
    | GEOIP_CITY_EDITION_REV1 ->
      _extract_city_record gi recofs
    (* TODO: city confidence edition handling *)
    | GEOIP_CITYCONFIDENCE_EDITION
    | GEOIP_CITYCONFIDENCEDIST_EDITION
    | _ ->
      raise (Geoip_error (Unexpected_edition (GEOIP_CITY_EDITION_REV1, gi.edition)))

let record_by_name gi name =
  proc_opt (extract_city_record gi) (proc_opt (seek_record gi) (host_to_num name))
