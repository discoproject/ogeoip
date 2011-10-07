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

let country_code_table = [|
  "--";"AP";"EU";"AD";"AE";"AF";"AG";"AI";"AL";"AM";"CW";
       "AO";"AQ";"AR";"AS";"AT";"AU";"AW";"AZ";"BA";"BB";
       "BD";"BE";"BF";"BG";"BH";"BI";"BJ";"BM";"BN";"BO";
       "BR";"BS";"BT";"BV";"BW";"BY";"BZ";"CA";"CC";"CD";
       "CF";"CG";"CH";"CI";"CK";"CL";"CM";"CN";"CO";"CR";
       "CU";"CV";"CX";"CY";"CZ";"DE";"DJ";"DK";"DM";"DO";
       "DZ";"EC";"EE";"EG";"EH";"ER";"ES";"ET";"FI";"FJ";
       "FK";"FM";"FO";"FR";"SX";"GA";"GB";"GD";"GE";"GF";
       "GH";"GI";"GL";"GM";"GN";"GP";"GQ";"GR";"GS";"GT";
       "GU";"GW";"GY";"HK";"HM";"HN";"HR";"HT";"HU";"ID";
       "IE";"IL";"IN";"IO";"IQ";"IR";"IS";"IT";"JM";"JO";
       "JP";"KE";"KG";"KH";"KI";"KM";"KN";"KP";"KR";"KW";
       "KY";"KZ";"LA";"LB";"LC";"LI";"LK";"LR";"LS";"LT";
       "LU";"LV";"LY";"MA";"MC";"MD";"MG";"MH";"MK";"ML";
       "MM";"MN";"MO";"MP";"MQ";"MR";"MS";"MT";"MU";"MV";
       "MW";"MX";"MY";"MZ";"NA";"NC";"NE";"NF";"NG";"NI";
       "NL";"NO";"NP";"NR";"NU";"NZ";"OM";"PA";"PE";"PF";
       "PG";"PH";"PK";"PL";"PM";"PN";"PR";"PS";"PT";"PW";
       "PY";"QA";"RE";"RO";"RU";"RW";"SA";"SB";"SC";"SD";
       "SE";"SG";"SH";"SI";"SJ";"SK";"SL";"SM";"SN";"SO";
       "SR";"ST";"SV";"SY";"SZ";"TC";"TD";"TF";"TG";"TH";
       "TJ";"TK";"TM";"TN";"TO";"TL";"TR";"TT";"TV";"TW";
       "TZ";"UA";"UG";"UM";"US";"UY";"UZ";"VA";"VC";"VE";
       "VG";"VI";"VN";"VU";"WF";"WS";"YE";"YT";"RS";"ZA";
       "ZM";"ME";"ZW";"A1";"A2";"O1";"AX";"GG";"IM";"JE";
       "BL";"MF"; "BQ"
|]

let country_code_of int =
  try Some country_code_table.(int)
  with Invalid_argument _ -> None

let country_code3_table = [|
  "--";"AP";"EU";"AND";"ARE";"AFG";"ATG";"AIA";"ALB";"ARM";"CUW";
       "AGO";"ATA";"ARG";"ASM";"AUT";"AUS";"ABW";"AZE";"BIH";"BRB";
       "BGD";"BEL";"BFA";"BGR";"BHR";"BDI";"BEN";"BMU";"BRN";"BOL";
       "BRA";"BHS";"BTN";"BVT";"BWA";"BLR";"BLZ";"CAN";"CCK";"COD";
       "CAF";"COG";"CHE";"CIV";"COK";"CHL";"CMR";"CHN";"COL";"CRI";
       "CUB";"CPV";"CXR";"CYP";"CZE";"DEU";"DJI";"DNK";"DMA";"DOM";
       "DZA";"ECU";"EST";"EGY";"ESH";"ERI";"ESP";"ETH";"FIN";"FJI";
       "FLK";"FSM";"FRO";"FRA";"SXM";"GAB";"GBR";"GRD";"GEO";"GUF";
       "GHA";"GIB";"GRL";"GMB";"GIN";"GLP";"GNQ";"GRC";"SGS";"GTM";
       "GUM";"GNB";"GUY";"HKG";"HMD";"HND";"HRV";"HTI";"HUN";"IDN";
       "IRL";"ISR";"IND";"IOT";"IRQ";"IRN";"ISL";"ITA";"JAM";"JOR";
       "JPN";"KEN";"KGZ";"KHM";"KIR";"COM";"KNA";"PRK";"KOR";"KWT";
       "CYM";"KAZ";"LAO";"LBN";"LCA";"LIE";"LKA";"LBR";"LSO";"LTU";
       "LUX";"LVA";"LBY";"MAR";"MCO";"MDA";"MDG";"MHL";"MKD";"MLI";
       "MMR";"MNG";"MAC";"MNP";"MTQ";"MRT";"MSR";"MLT";"MUS";"MDV";
       "MWI";"MEX";"MYS";"MOZ";"NAM";"NCL";"NER";"NFK";"NGA";"NIC";
       "NLD";"NOR";"NPL";"NRU";"NIU";"NZL";"OMN";"PAN";"PER";"PYF";
       "PNG";"PHL";"PAK";"POL";"SPM";"PCN";"PRI";"PSE";"PRT";"PLW";
       "PRY";"QAT";"REU";"ROU";"RUS";"RWA";"SAU";"SLB";"SYC";"SDN";
       "SWE";"SGP";"SHN";"SVN";"SJM";"SVK";"SLE";"SMR";"SEN";"SOM";
       "SUR";"STP";"SLV";"SYR";"SWZ";"TCA";"TCD";"ATF";"TGO";"THA";
       "TJK";"TKL";"TKM";"TUN";"TON";"TLS";"TUR";"TTO";"TUV";"TWN";
       "TZA";"UKR";"UGA";"UMI";"USA";"URY";"UZB";"VAT";"VCT";"VEN";
       "VGB";"VIR";"VNM";"VUT";"WLF";"WSM";"YEM";"MYT";"SRB";"ZAF";
       "ZMB";"MNE";"ZWE";"A1";"A2";"O1";"ALA";"GGY";"IMN";"JEY";
       "BLM";"MAF"; "BES"
|]

let country_code3_of int =
  try Some country_code3_table.(int)
  with Invalid_argument _ -> None

let utf8_country_name_table = [|
  "N/A";"Asia/Pacific Region";"Europe";"Andorra";"United Arab Emirates";"Afghanistan";"Antigua and Barbuda";"Anguilla";"Albania";"Armenia";"Cura" ^ "\xc3\xa7" ^ "ao";
  "Angola";"Antarctica";"Argentina";"American Samoa";"Austria";"Australia";"Aruba";"Azerbaijan";"Bosnia and Herzegovina";"Barbados";
  "Bangladesh";"Belgium";"Burkina Faso";"Bulgaria";"Bahrain";"Burundi";"Benin";"Bermuda";"Brunei Darussalam";"Bolivia";
  "Brazil";"Bahamas";"Bhutan";"Bouvet Island";"Botswana";"Belarus";"Belize";"Canada";"Cocos (Keeling) Islands";"Congo; The Democratic Republic of the";
  "Central African Republic";"Congo";"Switzerland";"Cote D'Ivoire";"Cook Islands";"Chile";"Cameroon";"China";"Colombia";"Costa Rica";
  "Cuba";"Cape Verde";"Christmas Island";"Cyprus";"Czech Republic";"Germany";"Djibouti";"Denmark";"Dominica";"Dominican Republic";
  "Algeria";"Ecuador";"Estonia";"Egypt";"Western Sahara";"Eritrea";"Spain";"Ethiopia";"Finland";"Fiji";
  "Falkland Islands (Malvinas)";"Micronesia; Federated States of";"Faroe Islands";"France";"Sint Maarten (Dutch part)";"Gabon";"United Kingdom";"Grenada";"Georgia";"French Guiana";
  "Ghana";"Gibraltar";"Greenland";"Gambia";"Guinea";"Guadeloupe";"Equatorial Guinea";"Greece";"South Georgia and the South Sandwich Islands";"Guatemala";
  "Guam";"Guinea-Bissau";"Guyana";"Hong Kong";"Heard Island and McDonald Islands";"Honduras";"Croatia";"Haiti";"Hungary";"Indonesia";
  "Ireland";"Israel";"India";"British Indian Ocean Territory";"Iraq";"Iran; Islamic Republic of";"Iceland";"Italy";"Jamaica";"Jordan";
  "Japan";"Kenya";"Kyrgyzstan";"Cambodia";"Kiribati";"Comoros";"Saint Kitts and Nevis";"Korea; Democratic People's Republic of";"Korea; Republic of";"Kuwait";
  "Cayman Islands";"Kazakhstan";"Lao People's Democratic Republic";"Lebanon";"Saint Lucia";"Liechtenstein";"Sri Lanka";"Liberia";"Lesotho";"Lithuania";
  "Luxembourg";"Latvia";"Libyan Arab Jamahiriya";"Morocco";"Monaco";"Moldova; Republic of";"Madagascar";"Marshall Islands";"Macedonia";"Mali";
  "Myanmar";"Mongolia";"Macau";"Northern Mariana Islands";"Martinique";"Mauritania";"Montserrat";"Malta";"Mauritius";"Maldives";
  "Malawi";"Mexico";"Malaysia";"Mozambique";"Namibia";"New Caledonia";"Niger";"Norfolk Island";"Nigeria";"Nicaragua";
  "Netherlands";"Norway";"Nepal";"Nauru";"Niue";"New Zealand";"Oman";"Panama";"Peru";"French Polynesia";
  "Papua New Guinea";"Philippines";"Pakistan";"Poland";"Saint Pierre and Miquelon";"Pitcairn Islands";"Puerto Rico";"Palestinian Territory";"Portugal";"Palau";
  "Paraguay";"Qatar";"Reunion";"Romania";"Russian Federation";"Rwanda";"Saudi Arabia";"Solomon Islands";"Seychelles";"Sudan";
  "Sweden";"Singapore";"Saint Helena";"Slovenia";"Svalbard and Jan Mayen";"Slovakia";"Sierra Leone";"San Marino";"Senegal";"Somalia";"Suriname";
  "Sao Tome and Principe";"El Salvador";"Syrian Arab Republic";"Swaziland";"Turks and Caicos Islands";"Chad";"French Southern Territories";"Togo";"Thailand";
  "Tajikistan";"Tokelau";"Turkmenistan";"Tunisia";"Tonga";"Timor-Leste";"Turkey";"Trinidad and Tobago";"Tuvalu";"Taiwan";
  "Tanzania; United Republic of";"Ukraine";"Uganda";"United States Minor Outlying Islands";"United States";"Uruguay";"Uzbekistan";"Holy See (Vatican City State)";"Saint Vincent and the Grenadines";"Venezuela";
  "Virgin Islands; British";"Virgin Islands; U.S.";"Vietnam";"Vanuatu";"Wallis and Futuna";"Samoa";"Yemen";"Mayotte";"Serbia";"South Africa";
  "Zambia";"Montenegro";"Zimbabwe";"Anonymous Proxy";"Satellite Provider";"Other";"Aland Islands";"Guernsey";"Isle of Man";"Jersey";
  "Saint Barthelemy";"Saint Martin"; "Bonaire; Saint Eustatius and Saba"
|]

let country_name_table = [|
  "N/A";"Asia/Pacific Region";"Europe";"Andorra";"United Arab Emirates";"Afghanistan";"Antigua and Barbuda";"Anguilla";"Albania";"Armenia";"Cura" ^ "\xe7" ^ "ao";
  "Angola";"Antarctica";"Argentina";"American Samoa";"Austria";"Australia";"Aruba";"Azerbaijan";"Bosnia and Herzegovina";"Barbados";
  "Bangladesh";"Belgium";"Burkina Faso";"Bulgaria";"Bahrain";"Burundi";"Benin";"Bermuda";"Brunei Darussalam";"Bolivia";
  "Brazil";"Bahamas";"Bhutan";"Bouvet Island";"Botswana";"Belarus";"Belize";"Canada";"Cocos (Keeling) Islands";"Congo; The Democratic Republic of the";
  "Central African Republic";"Congo";"Switzerland";"Cote D'Ivoire";"Cook Islands";"Chile";"Cameroon";"China";"Colombia";"Costa Rica";
  "Cuba";"Cape Verde";"Christmas Island";"Cyprus";"Czech Republic";"Germany";"Djibouti";"Denmark";"Dominica";"Dominican Republic";
  "Algeria";"Ecuador";"Estonia";"Egypt";"Western Sahara";"Eritrea";"Spain";"Ethiopia";"Finland";"Fiji";
  "Falkland Islands (Malvinas)";"Micronesia; Federated States of";"Faroe Islands";"France";"Sint Maarten (Dutch part)";"Gabon";"United Kingdom";"Grenada";"Georgia";"French Guiana";
  "Ghana";"Gibraltar";"Greenland";"Gambia";"Guinea";"Guadeloupe";"Equatorial Guinea";"Greece";"South Georgia and the South Sandwich Islands";"Guatemala";
  "Guam";"Guinea-Bissau";"Guyana";"Hong Kong";"Heard Island and McDonald Islands";"Honduras";"Croatia";"Haiti";"Hungary";"Indonesia";
  "Ireland";"Israel";"India";"British Indian Ocean Territory";"Iraq";"Iran; Islamic Republic of";"Iceland";"Italy";"Jamaica";"Jordan";
  "Japan";"Kenya";"Kyrgyzstan";"Cambodia";"Kiribati";"Comoros";"Saint Kitts and Nevis";"Korea; Democratic People's Republic of";"Korea; Republic of";"Kuwait";
  "Cayman Islands";"Kazakhstan";"Lao People's Democratic Republic";"Lebanon";"Saint Lucia";"Liechtenstein";"Sri Lanka";"Liberia";"Lesotho";"Lithuania";
  "Luxembourg";"Latvia";"Libyan Arab Jamahiriya";"Morocco";"Monaco";"Moldova; Republic of";"Madagascar";"Marshall Islands";"Macedonia";"Mali";
  "Myanmar";"Mongolia";"Macau";"Northern Mariana Islands";"Martinique";"Mauritania";"Montserrat";"Malta";"Mauritius";"Maldives";
  "Malawi";"Mexico";"Malaysia";"Mozambique";"Namibia";"New Caledonia";"Niger";"Norfolk Island";"Nigeria";"Nicaragua";
  "Netherlands";"Norway";"Nepal";"Nauru";"Niue";"New Zealand";"Oman";"Panama";"Peru";"French Polynesia";
  "Papua New Guinea";"Philippines";"Pakistan";"Poland";"Saint Pierre and Miquelon";"Pitcairn Islands";"Puerto Rico";"Palestinian Territory";"Portugal";"Palau";
  "Paraguay";"Qatar";"Reunion";"Romania";"Russian Federation";"Rwanda";"Saudi Arabia";"Solomon Islands";"Seychelles";"Sudan";
  "Sweden";"Singapore";"Saint Helena";"Slovenia";"Svalbard and Jan Mayen";"Slovakia";"Sierra Leone";"San Marino";"Senegal";"Somalia";"Suriname";
  "Sao Tome and Principe";"El Salvador";"Syrian Arab Republic";"Swaziland";"Turks and Caicos Islands";"Chad";"French Southern Territories";"Togo";"Thailand";
  "Tajikistan";"Tokelau";"Turkmenistan";"Tunisia";"Tonga";"Timor-Leste";"Turkey";"Trinidad and Tobago";"Tuvalu";"Taiwan";
  "Tanzania; United Republic of";"Ukraine";"Uganda";"United States Minor Outlying Islands";"United States";"Uruguay";"Uzbekistan";"Holy See (Vatican City State)";"Saint Vincent and the Grenadines";"Venezuela";
  "Virgin Islands; British";"Virgin Islands; U.S.";"Vietnam";"Vanuatu";"Wallis and Futuna";"Samoa";"Yemen";"Mayotte";"Serbia";"South Africa";
  "Zambia";"Montenegro";"Zimbabwe";"Anonymous Proxy";"Satellite Provider";"Other";"Aland Islands";"Guernsey";"Isle of Man";"Jersey";
  "Saint Barthelemy";"Saint Martin"; "Bonaire; Saint Eustatius and Saba"
|]

let country_name_of _gi int =
  (* ignore UTF8 for now. We could check the charset in gi, but that
     would involve module recursion, so we just use default charset,
     which seems to be the only one used anyway even in C. *)
  try Some country_name_table.(int)
  with Invalid_argument _ -> None

(* Possible continent codes are AF, AS, EU, NA, OC, SA for Africa, Asia, Europe, North America, Oceania
   and South America. *)

let country_continent_table = [|
  "--"; "AS";"EU";"EU";"AS";"AS";"NA";"NA";"EU";"AS";"NA";
        "AF";"AN";"SA";"OC";"EU";"OC";"NA";"AS";"EU";"NA";
        "AS";"EU";"AF";"EU";"AS";"AF";"AF";"NA";"AS";"SA";
        "SA";"NA";"AS";"AN";"AF";"EU";"NA";"NA";"AS";"AF";
        "AF";"AF";"EU";"AF";"OC";"SA";"AF";"AS";"SA";"NA";
        "NA";"AF";"AS";"AS";"EU";"EU";"AF";"EU";"NA";"NA";
        "AF";"SA";"EU";"AF";"AF";"AF";"EU";"AF";"EU";"OC";
        "SA";"OC";"EU";"EU";"NA";"AF";"EU";"NA";"AS";"SA";
        "AF";"EU";"NA";"AF";"AF";"NA";"AF";"EU";"AN";"NA";
        "OC";"AF";"SA";"AS";"AN";"NA";"EU";"NA";"EU";"AS";
        "EU";"AS";"AS";"AS";"AS";"AS";"EU";"EU";"NA";"AS";
        "AS";"AF";"AS";"AS";"OC";"AF";"NA";"AS";"AS";"AS";
        "NA";"AS";"AS";"AS";"NA";"EU";"AS";"AF";"AF";"EU";
        "EU";"EU";"AF";"AF";"EU";"EU";"AF";"OC";"EU";"AF";
        "AS";"AS";"AS";"OC";"NA";"AF";"NA";"EU";"AF";"AS";
        "AF";"NA";"AS";"AF";"AF";"OC";"AF";"OC";"AF";"NA";
        "EU";"EU";"AS";"OC";"OC";"OC";"AS";"NA";"SA";"OC";
        "OC";"AS";"AS";"EU";"NA";"OC";"NA";"AS";"EU";"OC";
        "SA";"AS";"AF";"EU";"EU";"AF";"AS";"OC";"AF";"AF";
        "EU";"AS";"AF";"EU";"EU";"EU";"AF";"EU";"AF";"AF";
        "SA";"AF";"NA";"AS";"AF";"NA";"AF";"AN";"AF";"AS";
        "AS";"OC";"AS";"AF";"OC";"AS";"EU";"NA";"OC";"AS";
        "AF";"EU";"AF";"OC";"NA";"SA";"AS";"EU";"NA";"SA";
        "NA";"NA";"AS";"OC";"OC";"OC";"AS";"AF";"EU";"AF";
        "AF";"EU";"AF";"--";"--";"--";"EU";"EU";"EU";"EU";
        "NA";"NA";"NA";
|]

let country_continent_of int =
  try Some country_continent_table.(int)
  with Invalid_argument _ -> None
