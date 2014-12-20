//
//  IBANtoolsTests.swift
//  IBANtoolsTests
//
//  Created by Mike Lischke on 06.12.14.
//  Copyright (c) 2014 Mike Lischke. All rights reserved.
//

import Cocoa
import XCTest
import IBANtools

class IBANtoolsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testCheckIBAN() {
        XCTAssertFalse(IBANtools.checkIBAN("532013018"));
        XCTAssert(IBANtools.checkIBAN("DE10100900440532013018"));

        XCTAssert(IBANtools.checkIBAN("AL47212110090000000235698741")); // Albania
        XCTAssert(IBANtools.checkIBAN("DZ4000400174401001050486"));     // Algeria
        XCTAssert(IBANtools.checkIBAN("AD1200012030200359100100"));     // Andorra
        XCTAssert(IBANtools.checkIBAN("AO06000600000100037131174"));    // Angola
        XCTAssert(IBANtools.checkIBAN("AT611904300234573201"));         // Austria
        XCTAssert(IBANtools.checkIBAN("AZ21NABZ00000000137010001944")); // Azerbaijan
        XCTAssert(IBANtools.checkIBAN("BH29BMAG1299123456BH00"));       // Bosnia and Herzegovina
        XCTAssert(IBANtools.checkIBAN("BA391290079401028494"));         // Bahrain
        XCTAssert(IBANtools.checkIBAN("BE68539007547034"));             // Belgium
        XCTAssert(IBANtools.checkIBAN("BJ11B00610100400271101192591")); // Benin
        XCTAssert(IBANtools.checkIBAN("BR9700360305000010009795493P1"));// Brazil
        XCTAssert(IBANtools.checkIBAN("BG80BNBG96611020345678"));       // Bulgaria
        XCTAssert(IBANtools.checkIBAN("BF1030134020015400945000643"));  // Burkin Faso
        XCTAssert(IBANtools.checkIBAN("BI43201011067444"));             // Burundi
        XCTAssert(IBANtools.checkIBAN("CM2110003001000500000605306"));  // Cameroon
        XCTAssert(IBANtools.checkIBAN("CV64000300004547069110176"));    // Cape Verde
        XCTAssert(IBANtools.checkIBAN("CR0515202001026284066"));        // Costa Rica
        XCTAssert(IBANtools.checkIBAN("HR1210010051863000160"));        // Croatia
        XCTAssert(IBANtools.checkIBAN("CY17002001280000001200527600")); // Cyprus
        XCTAssert(IBANtools.checkIBAN("CZ6508000000192000145399"));     // Czech Republic
        XCTAssert(IBANtools.checkIBAN("DK5000400440116243"));           // Denmark
        XCTAssert(IBANtools.checkIBAN("DO28BAGR00000001212453611324")); // Dominican Republic
        XCTAssert(IBANtools.checkIBAN("EE382200221020145685"));         // Estonia
        XCTAssert(IBANtools.checkIBAN("FO1464600009692713"));           // Faroe Islands
        XCTAssert(IBANtools.checkIBAN("FI2112345600000785"));           // Finland
        XCTAssert(IBANtools.checkIBAN("FR1420041010050500013M02606"));  // France
        XCTAssert(IBANtools.checkIBAN("GT82TRAJ01020000001210029690")); // Guatemala
        XCTAssert(IBANtools.checkIBAN("GE29NB0000000101904917"));       // Georgia
        XCTAssert(IBANtools.checkIBAN("DE89370400440532013000"));       // Germany
        XCTAssert(IBANtools.checkIBAN("GI75NWBK000000007099453"));      // Gibraltar
        XCTAssert(IBANtools.checkIBAN("GR1601101250000000012300695"));  // Greece
        XCTAssert(IBANtools.checkIBAN("GL8964710001000206"));           // Greenland
        XCTAssert(IBANtools.checkIBAN("HU42117730161111101800000000")); // Hungary
        XCTAssert(IBANtools.checkIBAN("IS140159260076545510730339"));   // Iceland
        XCTAssert(IBANtools.checkIBAN("IR580540105180021273113007"));   // Iran
        XCTAssert(IBANtools.checkIBAN("IE29AIBK93115212345678"));       // Ireland
        XCTAssert(IBANtools.checkIBAN("IL620108000000099999999"));      // Israel
        XCTAssert(IBANtools.checkIBAN("IT60X0542811101000000123456"));  // Italy
        XCTAssert(IBANtools.checkIBAN("CI05A00060174100178530011852")); // Ivory Coast
        XCTAssert(IBANtools.checkIBAN("JO94CBJO0010000000000131000302")); // Jordan
        XCTAssert(IBANtools.checkIBAN("KZ176010251000042993"));         // Kazakhstan
        XCTAssert(IBANtools.checkIBAN("KW74NBOK0000000000001000372151")); // Kuwait
        XCTAssert(IBANtools.checkIBAN("LV80BANK0000435195001"));        // Latvia
        XCTAssert(IBANtools.checkIBAN("LB30099900000001001925579115")); // Lebanon
        XCTAssert(IBANtools.checkIBAN("LI21088100002324013AA"));        // Liechtenstein
        XCTAssert(IBANtools.checkIBAN("LT121000011101001000"));         // Lithuania
        XCTAssert(IBANtools.checkIBAN("LU280019400644750000"));         // Luxembourg
        XCTAssert(IBANtools.checkIBAN("MK07300000000042425"));          // Macedonia
        XCTAssert(IBANtools.checkIBAN("MG4600005030010101914016056"));  // Madagascar
        XCTAssert(IBANtools.checkIBAN("MT84MALT011000012345MTLCAST001S")); // Malta
        XCTAssert(IBANtools.checkIBAN("MR1300012000010000002037372"));  // Mauritania
        XCTAssert(IBANtools.checkIBAN("MU17BOMM0101101030300200000MUR")); // Mauritius
        XCTAssert(IBANtools.checkIBAN("ML03D00890170001002120000447")); // Mali
        XCTAssert(IBANtools.checkIBAN("MD24AG000225100013104168"));     // Moldova
        XCTAssert(IBANtools.checkIBAN("MC5813488000010051108001292"));  // Monaco
        XCTAssert(IBANtools.checkIBAN("ME25505000012345678951"));       // Montenegro
        XCTAssert(IBANtools.checkIBAN("MZ59000100000011834194157"));    // Mozambique
        XCTAssert(IBANtools.checkIBAN("NL91ABNA0417164300"));           // Netherlands
        XCTAssert(IBANtools.checkIBAN("NO9386011117947"));              // Norway
        XCTAssert(IBANtools.checkIBAN("PK24SCBL0000001171495101"));     // Pakistan
        XCTAssert(IBANtools.checkIBAN("PS92PALS000000000400123456702"));// Palestine
        XCTAssert(IBANtools.checkIBAN("PL27114020040000300201355387")); // Poland
        XCTAssert(IBANtools.checkIBAN("PT50000201231234567890154"));    // Portugal
        XCTAssert(IBANtools.checkIBAN("QA58DOHB00001234567890ABCDEFG"));// Qatar
        XCTAssert(IBANtools.checkIBAN("RO49AAAA1B31007593840000"));     // Romania
        XCTAssert(IBANtools.checkIBAN("SM86U0322509800000000270100"));  // San Marino
        XCTAssert(IBANtools.checkIBAN("SA0380000000608010167519"));     // Saudi Arabia
        XCTAssert(IBANtools.checkIBAN("SN12K00100152000025690007542")); // Senegal
        XCTAssert(IBANtools.checkIBAN("RS35260005601001611379"));       // Serbia
        XCTAssert(IBANtools.checkIBAN("SK3112000000198742637541"));     // Slovakia
        XCTAssert(IBANtools.checkIBAN("SI56191000000123438"));          // Slovenia
        XCTAssert(IBANtools.checkIBAN("ES9121000418450200051332"));     // Spain
        XCTAssert(IBANtools.checkIBAN("SE3550000000054910000003"));     // Sweden
        XCTAssert(IBANtools.checkIBAN("CH9300762011623852957"));        // Switzerland
        XCTAssert(IBANtools.checkIBAN("TN5914207207100707129648"));     // Tunisia
        XCTAssert(IBANtools.checkIBAN("TR330006100519786457841326"));   // Turkey
        XCTAssert(IBANtools.checkIBAN("AE260211000000230064016"));      // United Arab Emirates
        XCTAssert(IBANtools.checkIBAN("GB29NWBK60161331926819"));       // United Kingdom
        XCTAssert(IBANtools.checkIBAN("VG96VPVG0000012345678901"));     // Virgin Islands, British
    }

    // Variants for which we have no country specific code.
    let testData: [(code: String, bank: String, account: String, checksum: String)] = [
        ("AD", "00012030",    "200359100100",         "12"),
        ("AL", "21211009",    "0000000235698741",     "47"),
        ("AT", "19043",       "00234573201",          "61"),
        ("BA", "129007",      "9401028494",           "39"),
        ("BE", "539",         "007547034",            "68"),
        ("BG", "BNBG9661",    "1020345678",           "80"),
        ("CH", "00762",       "011623852957",         "93"),
        ("CY", "00200128",    "0000001200527600",     "17"),
        ("CZ", "0800",        "0000192000145399",     "65"),
        ("DK", "0040",        "0440116243",           "50"),
        ("EE", "22",          "00221020145685",       "38"),
        ("ES", "21000418",    "450200051332",         "91"),
        ("FI", "123456",      "00000785",             "21"),
        ("FO", "6460",        "0001631634",           "62"),
        ("FR", "2004101005",  "0500013M02606",        "14"),
        ("GB", "NWBK601613",  "31926819",             "29"),
        ("GE", "NB",          "0000000101904917",     "29"),
        ("GI", "NWBK",        "000000007099453",      "75"),
        ("GL", "6471",        "0001000206",           "89"),
        ("GR", "0110125",     "0000000012300695",     "16"),
        ("HR", "1001005",     "1863000160",           "12"),
        ("HU", "1177301",     "61111101800000000",    "42"),
        ("IE", "AIBK931152",  "12345678",             "29"),
        ("IL", "010800",      "0000099999999",        "62"),
        ("IS", "0159",        "260076545510730339",   "14"),
        ("IT", "X0542811101", "000000123456",         "60"),
        ("KW", "CBKU",        "0000000000001234560101", "81"),
        ("KZ", "125",         "KZT5004100100",        "86"),
        ("LB", "0999",        "00000001001901229114", "62"),
        ("LI", "08810",       "0002324013AA",         "21"),
        ("LT", "10000",       "11101001000",          "12"),
        ("LU", "001",         "9400644750000",        "28"),
        ("LV", "BANK",        "0000435195001",        "80"),
        ("MC", "1273900070",  "0011111000h79",        "11"),
        ("ME", "505",         "000012345678951",      "25"),
        ("MK", "250",         "120000058984",         "07"),
        ("MR", "0002000101",  "0000123456753",        "13"),
        ("MT", "MALT01100",   "0012345MTLCAST001S",   "84"),
        ("MU", "BOMM0101",    "101030300200000MUR",   "17"),
        ("NL", "ABNA",        "0417164300",           "91"),
        ("NO", "8601",        "1117947",              "93"),
        ("PL", "10901014",    "0000071219812874",     "61"),
        ("PT", "00020123",    "1234567890154",        "50"),
        ("RO", "AAAA",        "1B31007593840000",     "49"),
        ("RS", "260",         "005601001611379",      "35"),
        ("SA", "80",          "000000608010167519",   "03"),
        ("SE", "500",         "00000058398257466",    "45"),
        ("SI", "19100",       "0000123438",           "56"),
        ("SK", "1200",        "0000198742637541",     "31"),
        ("SM", "U0322509800", "000000270100",         "86"),
        ("TN", "10006",       "035183598478831",      "59"),
        ("TR", "00061",       "00519786457841326",    "33")
    ];

    func testDefault() {
        XCTAssertEqual(IBANtools.convertToIBAN("", bankCode: "12345", countryCode: "xy"), "", "Default 1");
        XCTAssertEqual(IBANtools.convertToIBAN("12345", bankCode: "", countryCode: "xy"), "", "Default 2");
        XCTAssertEqual(IBANtools.convertToIBAN("12345", bankCode: "12345", countryCode: ""), "", "Default 3");
        XCTAssertEqual(IBANtools.convertToIBAN("12345", bankCode: "12345", countryCode: "µ"), "", "Default 4");

        for entry in testData {
            var accountNumber = entry.account;
            var bankCodeNumber = entry.bank;
            let details: CountryDetails? = countryData[entry.code];
            if (details != nil) {
                if accountNumber.utf16Count < details!.accountLength {
                    accountNumber = String(count: details!.accountLength - accountNumber.utf16Count, repeatedValue: "0" as Character) + accountNumber;
                }
                if bankCodeNumber.utf16Count < details!.bankCodeLength {
                    bankCodeNumber = String(count: details!.bankCodeLength - bankCodeNumber.utf16Count, repeatedValue: "0" as Character) + bankCodeNumber;
                }
            }
            let expected = entry.code + entry.checksum + bankCodeNumber + accountNumber;
            XCTAssertEqual(IBANtools.convertToIBAN(entry.account, bankCode: entry.bank, countryCode: entry.code), expected, "");
        }

    }

}
