/**
* Copyright (c) 2014, 2015, Mike Lischke. All rights reserved.
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public License as
* published by the Free Software Foundation; version 2 of the
* License.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program; if not, write to the Free Software
* Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
* 02110-1301  USA
*/

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

  func testisValidIBAN() {
    XCTAssertFalse(IBANtools.isValidIBAN("532013018"));
    XCTAssert(IBANtools.isValidIBAN("DE10100900440532013018"));

    XCTAssert(IBANtools.isValidIBAN("AL47212110090000000235698741")); // Albania
    XCTAssert(IBANtools.isValidIBAN("DZ4000400174401001050486"));     // Algeria
    XCTAssert(IBANtools.isValidIBAN("AD1200012030200359100100"));     // Andorra
    XCTAssert(IBANtools.isValidIBAN("AO06000600000100037131174"));    // Angola
    XCTAssert(IBANtools.isValidIBAN("AT611904300234573201"));         // Austria
    XCTAssert(IBANtools.isValidIBAN("AZ21NABZ00000000137010001944")); // Azerbaijan
    XCTAssert(IBANtools.isValidIBAN("BH29BMAG1299123456BH00"));       // Bosnia and Herzegovina
    XCTAssert(IBANtools.isValidIBAN("BA391290079401028494"));         // Bahrain
    XCTAssert(IBANtools.isValidIBAN("BE68539007547034"));             // Belgium
    XCTAssert(IBANtools.isValidIBAN("BJ11B00610100400271101192591")); // Benin
    XCTAssert(IBANtools.isValidIBAN("BR9700360305000010009795493P1"));// Brazil
    XCTAssert(IBANtools.isValidIBAN("BG80BNBG96611020345678"));       // Bulgaria
    XCTAssert(IBANtools.isValidIBAN("BF1030134020015400945000643"));  // Burkin Faso
    XCTAssert(IBANtools.isValidIBAN("BI43201011067444"));             // Burundi
    XCTAssert(IBANtools.isValidIBAN("CM2110003001000500000605306"));  // Cameroon
    XCTAssert(IBANtools.isValidIBAN("CV64000300004547069110176"));    // Cape Verde
    XCTAssert(IBANtools.isValidIBAN("CR0515202001026284066"));        // Costa Rica
    XCTAssert(IBANtools.isValidIBAN("HR1210010051863000160"));        // Croatia
    XCTAssert(IBANtools.isValidIBAN("CY17002001280000001200527600")); // Cyprus
    XCTAssert(IBANtools.isValidIBAN("CZ6508000000192000145399"));     // Czech Republic
    XCTAssert(IBANtools.isValidIBAN("DK5000400440116243"));           // Denmark
    XCTAssert(IBANtools.isValidIBAN("DO28BAGR00000001212453611324")); // Dominican Republic
    XCTAssert(IBANtools.isValidIBAN("EE382200221020145685"));         // Estonia
    XCTAssert(IBANtools.isValidIBAN("FO1464600009692713"));           // Faroe Islands
    XCTAssert(IBANtools.isValidIBAN("FI2112345600000785"));           // Finland
    XCTAssert(IBANtools.isValidIBAN("FR1420041010050500013M02606"));  // France
    XCTAssert(IBANtools.isValidIBAN("GT82TRAJ01020000001210029690")); // Guatemala
    XCTAssert(IBANtools.isValidIBAN("GE29NB0000000101904917"));       // Georgia
    XCTAssert(IBANtools.isValidIBAN("DE89370400440532013000"));       // Germany
    XCTAssert(IBANtools.isValidIBAN("GI75NWBK000000007099453"));      // Gibraltar
    XCTAssert(IBANtools.isValidIBAN("GR1601101250000000012300695"));  // Greece
    XCTAssert(IBANtools.isValidIBAN("GL8964710001000206"));           // Greenland
    XCTAssert(IBANtools.isValidIBAN("HU42117730161111101800000000")); // Hungary
    XCTAssert(IBANtools.isValidIBAN("IS140159260076545510730339"));   // Iceland
    XCTAssert(IBANtools.isValidIBAN("IR580540105180021273113007"));   // Iran
    XCTAssert(IBANtools.isValidIBAN("IE29AIBK93115212345678"));       // Ireland
    XCTAssert(IBANtools.isValidIBAN("IL620108000000099999999"));      // Israel
    XCTAssert(IBANtools.isValidIBAN("IT60X0542811101000000123456"));  // Italy
    XCTAssert(IBANtools.isValidIBAN("CI05A00060174100178530011852")); // Ivory Coast
    XCTAssert(IBANtools.isValidIBAN("JO94CBJO0010000000000131000302")); // Jordan
    XCTAssert(IBANtools.isValidIBAN("KZ176010251000042993"));         // Kazakhstan
    XCTAssert(IBANtools.isValidIBAN("KW74NBOK0000000000001000372151")); // Kuwait
    XCTAssert(IBANtools.isValidIBAN("LV80BANK0000435195001"));        // Latvia
    XCTAssert(IBANtools.isValidIBAN("LB30099900000001001925579115")); // Lebanon
    XCTAssert(IBANtools.isValidIBAN("LI21088100002324013AA"));        // Liechtenstein
    XCTAssert(IBANtools.isValidIBAN("LT121000011101001000"));         // Lithuania
    XCTAssert(IBANtools.isValidIBAN("LU280019400644750000"));         // Luxembourg
    XCTAssert(IBANtools.isValidIBAN("MK07300000000042425"));          // Macedonia
    XCTAssert(IBANtools.isValidIBAN("MG4600005030010101914016056"));  // Madagascar
    XCTAssert(IBANtools.isValidIBAN("MT84MALT011000012345MTLCAST001S")); // Malta
    XCTAssert(IBANtools.isValidIBAN("MR1300012000010000002037372"));  // Mauritania
    XCTAssert(IBANtools.isValidIBAN("MU17BOMM0101101030300200000MUR")); // Mauritius
    XCTAssert(IBANtools.isValidIBAN("ML03D00890170001002120000447")); // Mali
    XCTAssert(IBANtools.isValidIBAN("MD24AG000225100013104168"));     // Moldova
    XCTAssert(IBANtools.isValidIBAN("MC5813488000010051108001292"));  // Monaco
    XCTAssert(IBANtools.isValidIBAN("ME25505000012345678951"));       // Montenegro
    XCTAssert(IBANtools.isValidIBAN("MZ59000100000011834194157"));    // Mozambique
    XCTAssert(IBANtools.isValidIBAN("NL91ABNA0417164300"));           // Netherlands
    XCTAssert(IBANtools.isValidIBAN("NO9386011117947"));              // Norway
    XCTAssert(IBANtools.isValidIBAN("PK24SCBL0000001171495101"));     // Pakistan
    XCTAssert(IBANtools.isValidIBAN("PS92PALS000000000400123456702"));// Palestine
    XCTAssert(IBANtools.isValidIBAN("PL27114020040000300201355387")); // Poland
    XCTAssert(IBANtools.isValidIBAN("PT50000201231234567890154"));    // Portugal
    XCTAssert(IBANtools.isValidIBAN("QA58DOHB00001234567890ABCDEFG"));// Qatar
    XCTAssert(IBANtools.isValidIBAN("RO49AAAA1B31007593840000"));     // Romania
    XCTAssert(IBANtools.isValidIBAN("SM86U0322509800000000270100"));  // San Marino
    XCTAssert(IBANtools.isValidIBAN("SA0380000000608010167519"));     // Saudi Arabia
    XCTAssert(IBANtools.isValidIBAN("SN12K00100152000025690007542")); // Senegal
    XCTAssert(IBANtools.isValidIBAN("RS35260005601001611379"));       // Serbia
    XCTAssert(IBANtools.isValidIBAN("SK3112000000198742637541"));     // Slovakia
    XCTAssert(IBANtools.isValidIBAN("SI56191000000123438"));          // Slovenia
    XCTAssert(IBANtools.isValidIBAN("ES9121000418450200051332"));     // Spain
    XCTAssert(IBANtools.isValidIBAN("SE3550000000054910000003"));     // Sweden
    XCTAssert(IBANtools.isValidIBAN("CH9300762011623852957"));        // Switzerland
    XCTAssert(IBANtools.isValidIBAN("TN5914207207100707129648"));     // Tunisia
    XCTAssert(IBANtools.isValidIBAN("TR330006100519786457841326"));   // Turkey
    XCTAssert(IBANtools.isValidIBAN("AE260211000000230064016"));      // United Arab Emirates
    XCTAssert(IBANtools.isValidIBAN("GB29NWBK60161331926819"));       // United Kingdom
    XCTAssert(IBANtools.isValidIBAN("VG96VPVG0000012345678901"));     // Virgin Islands, British
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

  func testIBANConversion() {
    XCTAssertEqual(IBANtools.convertToIBAN("", bankCode: "12345", countryCode: "xy").1, IBANToolsResult.IBANToolsWrongValue, "Default 1");
    XCTAssertEqual(IBANtools.convertToIBAN("12345", bankCode: "", countryCode: "xy").1, IBANToolsResult.IBANToolsWrongValue, "Default 2");
    XCTAssertEqual(IBANtools.convertToIBAN("12345", bankCode: "12345", countryCode: "").1, IBANToolsResult.IBANToolsWrongValue, "Default 3");
    XCTAssertEqual(IBANtools.convertToIBAN("12345", bankCode: "12345", countryCode: "µ", validateAccount: false).1, IBANToolsResult.IBANToolsWrongValue, "Default 4");

    var counter = 5;
    for entry in testData {
      var accountNumber = entry.account;
      var bankCodeNumber = entry.bank;
      if let details = countryData[entry.code] {
        if accountNumber.utf16Count < details.accountLength {
          accountNumber = String(count: details.accountLength - accountNumber.utf16Count, repeatedValue: "0" as Character) + accountNumber;
        }
        if bankCodeNumber.utf16Count < details.bankCodeLength {
          bankCodeNumber = String(count: details.bankCodeLength - bankCodeNumber.utf16Count, repeatedValue: "0" as Character) + bankCodeNumber;
        }
      }
      let expected = entry.code + entry.checksum + bankCodeNumber + accountNumber;
      XCTAssertEqual(IBANtools.convertToIBAN(entry.account, bankCode: entry.bank, countryCode: entry.code).0, expected, "Default \(counter++)");
    }

  }

  func testBICDetermination () {
    // Currently BICs can only be determined for german accounts.
    XCTAssertEqual(IBANtools.bicForIBAN("VG96VPVG0000012345678901").result, IBANToolsResult.IBANToolsNoBic);
  }

}
