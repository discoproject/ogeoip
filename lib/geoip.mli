(**************************************************************************)
(*  Copyright (C) 2011, Nokia Corporation.                                *)
(*                                                                        *)
(*  This file is part of the OGeoIp library.                              *)
(*                                                                        *)
(*  This library is free software: you can redistribute it and/or modify  *)
(*  it under the terms of the GNU Lesser General Public License as        *)
(*  published by the Free Software Foundation, either version 2.1 of the  *)
(*  License, or (at your option) any later version.                       *)
(*                                                                        *)
(*  This program is distributed in the hope that it will be useful, but   *)
(*  WITHOUT ANY WARRANTY; without even the implied warranty of            *)
(*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU     *)
(*  Lesser General Public License for more details.                       *)
(*                                                                        *)
(*  You should have received a copy of the GNU Lesser General Public      *)
(*  License along with this program.  If not, see                         *)
(*  <http://www.gnu.org/licenses/>.                                       *)
(**************************************************************************)

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

val edition_name : edition -> string

type charset = Charset_ISO8859_1 | Charset_UTF8

type geoip
(** The type for a handle to an opened GeoIP database. *)

val edition : geoip -> edition

val geoip_open : string -> geoip
(** [geoip_open file_name] returns a handle to the GeoIP database in
    the specified file. *)

val country_code_by_name : geoip -> string -> string option
(** [country_code_by_name g ip_address] returns an optional value for
    the 2-letter country code corresponding to the [ip_address].*)

val country_code3_by_name : geoip -> string -> string option
(** [country_code3_by_name g ip_address] returns an optional value for
    the 3-letter country code corresponding to the [ip_address].*)

val country_name_by_name : geoip -> string -> string option
(** [country_name_by_name g ip_address] returns an optional value for
    the country name corresponding to the [ip_address].*)

val country_continent_by_name : geoip -> string -> string option
(** [country_code_by_name g ip_address] returns an optional value for
    the 2-letter continent code from the country corresponding to the
    [ip_address].*)

(* API for City editions. *)

type geoip_record = {
  continent_code : string option;
  country_code : string option;
  country_code3 : string option;
  country_name : string option;
  region : string;
  region_name : string option;
  city : string;
  postal_code : string;
  latitude : float;
  longitude : float;
  metro_code : int option;
  area_code : int option;
  timezone : string option;
  country_conf : char option;
  region_conf : char option;
  city_conf : char option;
  postal_conf : char option;
  accuracy_radius : int option;
}
(** The record type containing location information from the City
    editions of the GeoIP database. *)

val record_by_name : geoip -> string -> geoip_record option
(** [record_by_name g ip_address] returns a value of type
    [geoip_record]. *)


(* The above functions can throw the exception below. *)

type error =
  | Unsupported_edition of edition
  | Unexpected_edition of edition * edition
  | Invalid_ipv4_address of string
  | Ipv6_not_supported of string

val string_of_error : error -> string

exception Geoip_error of error
