module G = Geoip

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
  if seek_record = gi.G.segment_size then None
  else begin
    let record_pointer = ref (seek_record + (2 * gi.G.record_length - 1) * gi.G.segment_size) in
    (* let begin_record = ref (!record_pointer) in *)

    (* G.dbg "  reading record at offset: %d = %d + (2 * %d - 1) * %dn"
       !record_pointer seek_record gi.G.record_length gi.G.segment_size; *)

    (* country *)
    (* G.dbg "  using country_code of %d ..." gi.G.map.{!record_pointer}; *)

    let continent_code = Geoip_tables.country_continent_of gi.G.map.{!record_pointer} in
    let country_code   = Geoip_tables.country_code_of gi.G.map.{!record_pointer} in
    let country_code3  = Geoip_tables.country_code3_of gi.G.map.{!record_pointer} in
    let country_name   = Geoip_tables.country_name_of gi gi.G.map.{!record_pointer} in
    incr record_pointer;

    (* region *)
    let region = G.string_from_bytes gi.G.map !record_pointer in
    (* G.dbg "  reading region of %d bytes at record_offset %d: %s"
       (String.length region) (!record_pointer - !begin_record) region; *)
    record_pointer := !record_pointer + String.length region + 1;

    (* city *)
    let city = G.string_from_bytes gi.G.map !record_pointer in
    (* G.dbg "  reading city of %d bytes at record_offset %d: %s"
       (String.length city) (!record_pointer - !begin_record) city; *)
    record_pointer := !record_pointer + String.length city + 1;

    (* postal code *)
    let postal_code = G.string_from_bytes gi.G.map !record_pointer in
    (* G.dbg "  reading postal code of %d bytes at record_offset %d: %s"
       (String.length postal_code) (!record_pointer - !begin_record) postal_code; *)
    record_pointer := !record_pointer + String.length postal_code + 1;

    (* latitude/longitude *)
    let latitude  = float_of_int (G.int_from_bytes gi.G.map !record_pointer 3) /. 10000.0 -. 180.0 in
    (* G.dbg "  reading latitude of %d bytes at record_offset %d: %f"
       3 (!record_pointer - !begin_record) latitude; *)
    record_pointer := !record_pointer + 3;
    let longitude = float_of_int (G.int_from_bytes gi.G.map !record_pointer 3) /. 10000.0 -. 180.0 in
    (* G.dbg "  reading longitude of %d bytes at record_offset %d: %f"
       3 (!record_pointer - !begin_record) longitude; *)
    record_pointer := !record_pointer + 3;

    (* get area code and metro code for post April 2002 databases and
       for US locations *)
    let metro_code, area_code =
      if (gi.G.edition = G.GEOIP_CITY_EDITION_REV1 || gi.G.edition = G.GEOIP_CITYCONFIDENCE_EDITION)
        && country_code = Some "US"
      then begin
        let combo = G.int_from_bytes gi.G.map !record_pointer 3 in
        (* G.dbg "  reading metroarea_code of %d bytes at record_offset %d: %d"
           3 (!record_pointer - !begin_record) combo; *)
        Some (combo / 1000), Some (combo mod 1000)
      end else
        None, None in
    let timezone = G.timezone_by_country_and_region gi country_code region in
    let region_name = G.region_name_by_code gi country_code region in
    Some {continent_code = continent_code;
          country_code; country_code3; country_name; region; region_name; city; postal_code;
          latitude; longitude; metro_code; area_code; timezone;
          country_conf; region_conf; city_conf; postal_conf; accuracy_radius}
  end

let extract_city_record gi recofs =
  match gi.G.edition with
    | G.GEOIP_CITY_EDITION_REV0
    | G.GEOIP_CITY_EDITION_REV1 ->
      _extract_city_record gi recofs
    (* TODO: city confidence edition handling *)
    | G.GEOIP_CITYCONFIDENCE_EDITION
    | G.GEOIP_CITYCONFIDENCEDIST_EDITION
    | _ ->
      raise (G.Geoip_error (G.Unexpected_edition (G.GEOIP_CITY_EDITION_REV1, gi.G.edition)))

let record_by_name gi name =
  G.proc_opt (extract_city_record gi) (G.proc_opt (G.seek_record gi) (G.host_to_num name))
