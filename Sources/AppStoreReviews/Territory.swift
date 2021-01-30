import Foundation

/// App Store countries and regions.
///
/// Based on [App Store Connect Help - App Store countries and regions](https://help.apple.com/app-store-connect/#/dev997f9cf7c)
/// 
/// Last updated 30 January 2021.
public enum Territory: String, CaseIterable {
    case AFG, AE, AG, AI, AL, AM, AO, AR, AT, AU, AZ
    case BB, BE, BIH, BF, BG, BH, BJ, BM, BN, BO, BR, BS, BT, BW, BY, BZ
    case CMR, CA, CG, CH, CIV, CL, CN, CO, COD, CR, CV, CY, CZ
    case DE, DK, DM, DO, DZ
    case EC, EE, EG, ES
    case FI, FJ, FM, FR
    case GAB, GB, GD, GEO, GH, GM, GR, GT, GW, GY
    case HK, HN, HR, HU
    case ID, IE, IL, IN, IRQ, IS, IT
    case JM, JO, JP
    case KE, KG, KH, KN, KR, KW, KY, KZ
    case LA, LB, LBY, LC, LK, LR, LT, LU, LV
    case MAR, MD, MDV, MG, MK, ML, MMR, MN, MNE, MO, MR, MS, MT, MU, MW, MX, MY, MZ
    case NA, NE, NG, NI, NL, NO, NP, NRU, NZ
    case OM
    case PA, PE, PG, PH, PK, PL, PT, PW, PY
    case QA
    case RO, RU, RWA
    case SA, SB, SC, SE, SG, SI, SK, SL, SN, SR, SRB, ST, SV, SZ
    case TC, TD, TH, TJ, TM, TN, TON, TR, TT, TW, TZ
    case UA, UG, US, UY, UZ
    case VC, VE, VG, VN, VUT
    case XKS
    case YE
    case ZA, ZMB, ZW
}

public extension Territory {
    /// The ISO3166 two or three letters country or region code.
    var isoCode: String { rawValue }

    /// Name of the country or territory, in English.
    var name: String {
        switch self {
        case .AFG: return "Afghanistan"
        case .AE: return "United Arab Emirates"
        case .AG: return "Antigua and Barbuda"
        case .AI: return "Anguilla"
        case .AL: return "Albania"
        case .AM: return "Armenia"
        case .AO: return "Angola"
        case .AR: return "Argentina"
        case .AT: return "Austria"
        case .AU: return "Australia"
        case .AZ: return "Azerbaijan"
        case .BB: return "Barbados"
        case .BE: return "Belgium"
        case .BIH: return "Bosnia and Herzegovina"
        case .BF: return "Burkina Faso"
        case .BG: return "Bulgaria"
        case .BH: return "Bahrain"
        case .BJ: return "Benin"
        case .BM: return "Bermuda"
        case .BN: return "Brunei"
        case .BO: return "Bolivia"
        case .BR: return "Brazil"
        case .BS: return "Bahamas"
        case .BT: return "Bhutan"
        case .BW: return "Botswana"
        case .BY: return "Belarus"
        case .BZ: return "Belize"
        case .CMR: return "Cameroon"
        case .CA: return "Canada"
        case .CG: return "Congo, Republic of the"
        case .CH: return "Switzerland"
        case .CIV: return "Cote d’Ivoire"
        case .CL: return "Chile"
        case .CN: return "China mainland"
        case .CO: return "Colombia"
        case .COD: return "Congo, Democratic Republic of the"
        case .CR: return "Costa Rica"
        case .CV: return "Cape Verde"
        case .CY: return "Cyprus"
        case .CZ: return "Czech Republic"
        case .DE: return "Germany"
        case .DK: return "Denmark"
        case .DM: return "Dominica"
        case .DO: return "Dominican Republic"
        case .DZ: return "Algeria"
        case .EC: return "Ecuador"
        case .EE: return "Estonia"
        case .EG: return "Egypt"
        case .ES: return "Spain"
        case .FI: return "Finland"
        case .FJ: return "Fiji"
        case .FM: return "Micronesia"
        case .FR: return "France"
        case .GAB: return "Gabon"
        case .GB: return "United Kingdom"
        case .GD: return "Grenada"
        case .GEO: return "Georgia"
        case .GH: return "Ghana"
        case .GM: return "Gambia"
        case .GR: return "Greece"
        case .GT: return "Guatemala"
        case .GW: return "Guinea-Bissau"
        case .GY: return "Guyana"
        case .HK: return "Hong Kong"
        case .HN: return "Honduras"
        case .HR: return "Croatia"
        case .HU: return "Hungary"
        case .ID: return "Indonesia"
        case .IE: return "Ireland"
        case .IL: return "Israel"
        case .IN: return "India"
        case .IRQ: return "Iraq"
        case .IS: return "Iceland"
        case .IT: return "Italy"
        case .JM: return "Jamaica"
        case .JO: return "Jordan"
        case .JP: return "Japan"
        case .KE: return "Kenya"
        case .KG: return "Kyrgyzstan"
        case .KH: return "Cambodia"
        case .KN: return "St. Kitts and Nevis"
        case .KR: return "Republic of Korea"
        case .KW: return "Kuwait"
        case .KY: return "Cayman Islands"
        case .KZ: return "Kazakhstan"
        case .LA: return "Laos"
        case .LB: return "Lebanon"
        case .LBY: return "Libya"
        case .LC: return "St. Lucia"
        case .LK: return "Sri Lanka"
        case .LR: return "Liberia"
        case .LT: return "Lithuania"
        case .LU: return "Luxembourg"
        case .LV: return "Latvia"
        case .MAR: return "Morocco"
        case .MD: return "Moldova"
        case .MDV: return "Maldives"
        case .MG: return "Madagascar"
        case .MK: return "North Macedonia"
        case .ML: return "Mali"
        case .MMR: return "Myanmar"
        case .MN: return "Mongolia"
        case .MNE: return "Montenegro"
        case .MO: return "Macau"
        case .MR: return "Mauritania"
        case .MS: return "Montserrat"
        case .MT: return "Malta"
        case .MU: return "Mauritius"
        case .MW: return "Malawi"
        case .MX: return "Mexico"
        case .MY: return "Malaysia"
        case .MZ: return "Mozambique"
        case .NA: return "Namibia"
        case .NE: return "Niger"
        case .NG: return "Nigeria"
        case .NI: return "Nicaragua"
        case .NL: return "Netherlands"
        case .NO: return "Norway"
        case .NP: return "Nepal"
        case .NRU: return "Nauru"
        case .NZ: return "New Zealand"
        case .OM: return "Oman"
        case .PA: return "Panama"
        case .PE: return "Peru"
        case .PG: return "Papua New Guinea"
        case .PH: return "Philippines"
        case .PK: return "Pakistan"
        case .PL: return "Poland"
        case .PT: return "Portugal"
        case .PW: return "Palau"
        case .PY: return "Paraguay"
        case .QA: return "Qatar"
        case .RO: return "Romania"
        case .RU: return "Russia"
        case .RWA: return "Rwanda"
        case .SA: return "Saudi Arabia"
        case .SB: return "Solomon Islands"
        case .SC: return "Seychelles"
        case .SE: return "Sweden"
        case .SG: return "Singapore"
        case .SI: return "Slovenia"
        case .SK: return "Slovakia"
        case .SL: return "Sierra Leone"
        case .SN: return "Senegal"
        case .SR: return "Suriname"
        case .SRB: return "Serbia"
        case .ST: return "Sao Tome and Principe"
        case .SV: return "El Salvador"
        case .SZ: return "Swaziland"
        case .TC: return "Turks and Caicos Islands"
        case .TD: return "Chad"
        case .TH: return "Thailand"
        case .TJ: return "Tajikistan"
        case .TM: return "Turkmenistan"
        case .TN: return "Tunisia"
        case .TON: return "Tonga"
        case .TR: return "Turkey"
        case .TT: return "Trinidad and Tobago"
        case .TW: return "Taiwan"
        case .TZ: return "Tanzania"
        case .UA: return "Ukraine"
        case .UG: return "Uganda"
        case .US: return "United States"
        case .UY: return "Uruguay"
        case .UZ: return "Uzbekistan"
        case .VC: return "St. Vincent and the Grenadines"
        case .VE: return "Venezuela"
        case .VG: return "British Virgin Islands"
        case .VN: return "Vietnam"
        case .VUT: return "Vanuatu"
        case .XKS: return "Kosovo"
        case .YE: return "Yemen"
        case .ZA: return "South Africa"
        case .ZMB: return "Zambia"
        case .ZW: return "Zimbabwe"
        }
    }
}
