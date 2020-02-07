/**
 * Copyright (c) 2014, 2019, Mike Lischke. All rights reserved.
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

import XCTest

#if os(macOS)
import Cocoa
import IBANtools
#else
import Foundation
import IBANtools_iOS
#endif

class IBANtoolsTests: XCTestCase {

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  func testIsValidIBAN() {
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
    XCTAssert(IBANtools.isValidIBAN("HR 12 10010051863000160"));        // Croatia
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
    XCTAssert(IBANtools.isValidIBAN("G R 1 6 0 1 1 0 1 2 5 0 0 0 0 0 0 0 0 1 2 3 0 0 6 9 5   "));  // Greece
    XCTAssert(IBANtools.isValidIBAN("GL        89              64710001000206"));           // Greenland
    XCTAssertFalse(IBANtools.isValidIBAN("GL        88              64710001000206"));
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

    // Make sure we can handle invalid input.
    XCTAssertFalse(IBANtools.isValidIBAN("DE97500400000589011600 DRESDEFF265"));
    XCTAssertFalse(IBANtools.isValidIBAN("\u{0004}\u{8888}"));
    XCTAssertFalse(IBANtools.isValidIBAN("\u{0004}\u{8888}\u{0004}\u{8888}"));
    XCTAssertFalse(IBANtools.isValidIBAN("DE97\u{0004}\u{8888}"));
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

  func testAndCompare(_ account: String, _ bank: String, _ country: String,
    _ expected: (String, IBANToolsResult), _ checkAccount: Bool = true) -> Bool {
    var account = account, bank = bank
    let result = IBANtools.convertToIBAN(&account, bankCode: &bank, countryCode: country, validateAccount: checkAccount);
    return result.0 == expected.0 && result.1 == expected.1;
  }
  
  func testIBANConversion() {
    XCTAssert(testAndCompare("", "12345", "xy", ("", .wrongValue)),  "Default 1");
    XCTAssert(testAndCompare("12345", "", "xy", ("", .wrongValue)), "Default 2");
    XCTAssert(testAndCompare("12345", "12345", "", ("", .wrongValue)), "Default 3");
    XCTAssert(testAndCompare("12345", "12345", "µ", ("", .wrongValue), false), "Default 4");

    var counter = 5;
    for entry in testData {
      var accountNumber = entry.account;
      var bankCodeNumber = entry.bank;
      if let details = countryData[entry.code] {
        if accountNumber.count < details.accountLength {
          accountNumber = String(repeating: "0", count: details.accountLength - accountNumber.count) + accountNumber;
        }
        if bankCodeNumber.count < details.bankCodeLength {
          bankCodeNumber = String(repeating: "0", count: details.bankCodeLength - bankCodeNumber.count) + bankCodeNumber;
        }
      }
      let expected = entry.code + entry.checksum + bankCodeNumber + accountNumber;
      XCTAssert(testAndCompare(entry.account, entry.bank, entry.code, (expected, .defaultIBAN)), "Default \(counter)");
      counter += 1;
    }
  }

  func ibanToBicTest(_ iban: String, _ expected: (bic: String, result: IBANToolsResult)) -> Bool {
    let result: (bic: String, result: IBANToolsResult) = IBANtools.bicForIBAN(iban);
    return result.bic == expected.bic && result.result == expected.result;
  }

  func bankCodeToBicTest(_ bankCode: String, countryCode: String, _ expected: (bic: String, result: IBANToolsResult)) -> Bool {
    let (bic, result): (String, IBANToolsResult) = IBANtools.bicForBankCode(bankCode, countryCode: countryCode);
    return bic == expected.bic && result == expected.result;
  }

  func testBICDetermination() {
    // Currently BICs can only be determined for german accounts.
    XCTAssert(ibanToBicTest("VG96VPVG0000012345678901", ("", IBANToolsResult.noBIC)));

    XCTAssert(ibanToBicTest("DE32265800700732502200", ("DRESDEFF265", .ok)));
    XCTAssert(ibanToBicTest("DE32265800700732502200", ("DRESDEFF265", .ok)));
    XCTAssert(ibanToBicTest("DE60265800708732502200", ("DRESDEFF265", .ok)));
    XCTAssert(ibanToBicTest("DE37265800704820379900", ("DRESDEFF265", .ok)));
    XCTAssert(ibanToBicTest("DE70500800004814706100", ("DRESDEFFXXX", .ok)));
    XCTAssert(ibanToBicTest("DE77500800006814706100", ("DRESDEFFXXX", .ok)));
    XCTAssert(ibanToBicTest("DE32500800007814706100", ("DRESDEFFXXX", .ok)));
    XCTAssert(ibanToBicTest("DE84500800008814706100", ("DRESDEFFXXX", .ok)));
    XCTAssert(ibanToBicTest("DE39500800009814706100", ("DRESDEFFXXX", .ok)));
    XCTAssert(ibanToBicTest("DE42500800000023165400", ("DRESDEFFXXX", .ok)));
    XCTAssert(ibanToBicTest("DE42500800000023165400", ("DRESDEFFXXX", .ok)));
    XCTAssert(ibanToBicTest("DE21500800000004350300", ("DRESDEFFXXX", .ok)));
    XCTAssert(ibanToBicTest("DE21500800000004350300", ("DRESDEFFXXX", .ok)));
    XCTAssert(ibanToBicTest("DE49500894000000526400", ("DRESDEFFI01", .ok)));
    XCTAssert(ibanToBicTest("DE73100800000998761700", ("DRESDEFF100", .ok)));
    XCTAssert(ibanToBicTest("DE10265800709902100000", ("DRESDEFF265", .ok)));
    XCTAssert(ibanToBicTest("DE24505400280421738600", ("COBADEFFXXX", .ok)));
    XCTAssert(ibanToBicTest("DE10720400460111198800", ("COBADEFFXXX", .ok)));
    XCTAssert(ibanToBicTest("DE46505400280420086100", ("COBADEFFXXX", .ok)));
    XCTAssert(ibanToBicTest("DE13505400280421573704", ("COBADEFFXXX", .ok)));
    XCTAssert(ibanToBicTest("DE26505400280421679200", ("COBADEFFXXX", .ok)));
    XCTAssert(ibanToBicTest("DE63654400870130023500", ("COBADEFFXXX", .ok)));
    XCTAssert(ibanToBicTest("DE29230400220010441400", ("COBADEFFXXX", .ok)));
    XCTAssert(ibanToBicTest("DE27120400000040050700", ("COBADEFFXXX", .ok)));
    XCTAssert(ibanToBicTest("DE73230400220010133700", ("COBADEFFXXX", .ok)));
    XCTAssert(ibanToBicTest("DE77230400220010503101", ("COBADEFFXXX", .ok)));
    XCTAssert(ibanToBicTest("DE12120400000052065002", ("COBADEFFXXX", .ok)));
    XCTAssert(ibanToBicTest("DE97500400000930125001", ("COBADEFFXXX", .ok)));
    XCTAssert(ibanToBicTest("DE89700400410930125000", ("COBADEFFXXX", .ok)));
    XCTAssert(ibanToBicTest("DE59500400000930125006", ("COBADEFFXXX", .ok)));
    XCTAssert(ibanToBicTest("DE81200411110130023500", ("COBADEHDXXX", .ok)));
    XCTAssert(ibanToBicTest("DE69370800400215022000", ("DRESDEFF370", .ok)));
    XCTAssert(ibanToBicTest("DE46500400000311011100", ("COBADEFFXXX", .ok)));
    XCTAssert(ibanToBicTest("DE16150800004241770400", ("DRESDEFF150", .ok)));
    XCTAssert(ibanToBicTest("DE41120800000070548200", ("DRESDEFF120", .ok)));
    XCTAssert(ibanToBicTest("DE95210800500118650400", ("DRESDEFF210", .ok)));
    XCTAssert(ibanToBicTest("DE58210800500001186103", ("DRESDEFF210", .ok)));
    XCTAssert(ibanToBicTest("DE80500202000000038000", ("BHFBDEFF500", .ok)));
    XCTAssert(ibanToBicTest("DE46500202000030009963", ("BHFBDEFF500", .ok)));
    XCTAssert(ibanToBicTest("DE02500202000040033086", ("BHFBDEFF500", .ok)));
    XCTAssert(ibanToBicTest("DE55500202000050017409", ("BHFBDEFF500", .ok)));
    XCTAssert(ibanToBicTest("DE38500202000055036107", ("BHFBDEFF500", .ok)));
    XCTAssert(ibanToBicTest("DE98500202000070049754", ("BHFBDEFF500", .ok)));
    XCTAssert(ibanToBicTest("DE03683515573047232594", ("SOLADES1SFH", .ok)));
    XCTAssert(ibanToBicTest("DE10683515570016005845", ("SOLADES1SFH", .ok)));
    XCTAssert(ibanToBicTest("DE95500500005000002096", ("HELADEFFXXX", .ok)));
    XCTAssert(ibanToBicTest("DE15300500000000060624", ("WELADEDDXXX", .ok)));
    XCTAssert(ibanToBicTest("DE25300606010000060624", ("DAAEDEDDXXX", .ok)));
    XCTAssert(ibanToBicTest("DE25300606010000060624", ("DAAEDEDDXXX", .ok)));
    XCTAssert(ibanToBicTest("DE25300606010000060624", ("DAAEDEDDXXX", .ok)));
    XCTAssert(ibanToBicTest("DE25300606010000060624", ("DAAEDEDDXXX", .ok)));
    XCTAssert(ibanToBicTest("DE25300606010000060624", ("DAAEDEDDXXX", .ok)));
    XCTAssert(ibanToBicTest("DE25300606010000060624", ("DAAEDEDDXXX", .ok)));
    XCTAssert(ibanToBicTest("DE25300606010000060624", ("DAAEDEDDXXX", .ok)));
    XCTAssert(ibanToBicTest("DE25300606010000060624", ("DAAEDEDDXXX", .ok)));
    XCTAssert(ibanToBicTest("DE25300606010000060624", ("DAAEDEDDXXX", .ok)));
    XCTAssert(ibanToBicTest("DE25300606010000060624", ("DAAEDEDDXXX", .ok)));
    XCTAssert(ibanToBicTest("DE25300606010000060624", ("DAAEDEDDXXX", .ok)));
    XCTAssert(ibanToBicTest("DE25300606010000060624", ("DAAEDEDDXXX", .ok)));
    XCTAssert(ibanToBicTest("DE25300606010000060624", ("DAAEDEDDXXX", .ok)));
    XCTAssert(ibanToBicTest("DE25300606010000060624", ("DAAEDEDDXXX", .ok)));
    XCTAssert(ibanToBicTest("DE25300606010000060624", ("DAAEDEDDXXX", .ok)));
    XCTAssert(ibanToBicTest("DE82501203830020475000", ("DELBDE33XXX", .ok)));
    XCTAssert(ibanToBicTest("DE82501203830020475000", ("DELBDE33XXX", .ok)));
    XCTAssert(ibanToBicTest("DE82501203830020475000", ("DELBDE33XXX", .ok)));
    XCTAssert(ibanToBicTest("DE82501203830020475000", ("DELBDE33XXX", .ok)));
    XCTAssert(ibanToBicTest("DE81360200300000305200", ("NBAGDE3EXXX", .ok)));
    XCTAssert(ibanToBicTest("DE03360200300000900826", ("NBAGDE3EXXX", .ok)));
    XCTAssert(ibanToBicTest("DE71360200300000705020", ("NBAGDE3EXXX", .ok)));
    XCTAssert(ibanToBicTest("DE18360200300009197354", ("NBAGDE3EXXX", .ok)));
    XCTAssert(ibanToBicTest("DE69250501800000017095", ("SPKHDE2HXXX", .ok)));
    XCTAssert(ibanToBicTest("DE77545201946790149813", ("HYVEDEMM483", .ok)));
    XCTAssert(ibanToBicTest("DE70762200731210100047", ("HYVEDEMM419", .ok)));
    XCTAssert(ibanToBicTest("DE70762200731210100047", ("HYVEDEMM419", .ok)));
    XCTAssert(ibanToBicTest("DE70762200731210100047", ("HYVEDEMM419", .ok)));
    XCTAssert(ibanToBicTest("DE70762200731210100047", ("HYVEDEMM419", .ok)));
    XCTAssert(ibanToBicTest("DE92660202861457032621", ("HYVEDEMM475", .ok)));
    XCTAssert(ibanToBicTest("DE70762200731210100047", ("HYVEDEMM419", .ok)));
    XCTAssert(ibanToBicTest("DE92660202861457032621", ("HYVEDEMM475", .ok)));
    XCTAssert(ibanToBicTest("DE06710221823200000012", ("HYVEDEMM453", .ok)));
    XCTAssert(ibanToBicTest("DE07100208900005951950", ("HYVEDEMM488", .ok)));
    XCTAssert(ibanToBicTest("DE76700202702950219435", ("HYVEDEMMXXX", .ok)));
    XCTAssert(ibanToBicTest("DE92660202861457032621", ("HYVEDEMM475", .ok)));
    XCTAssert(ibanToBicTest("DE55700202700000000897", ("HYVEDEMMXXX", .ok)));
    XCTAssert(ibanToBicTest("DE36700202700847321750", ("HYVEDEMMXXX", .ok)));
    XCTAssert(ibanToBicTest("DE11700202705803435253", ("HYVEDEMMXXX", .ok)));
    XCTAssert(ibanToBicTest("DE88700202700039908140", ("HYVEDEMMXXX", .ok)));
    XCTAssert(ibanToBicTest("DE83700202700002711931", ("HYVEDEMMXXX", .ok)));
    XCTAssert(ibanToBicTest("DE40700202705800522694", ("HYVEDEMMXXX", .ok)));
    XCTAssert(ibanToBicTest("DE61700202705801800000", ("HYVEDEMMXXX", .ok)));
    XCTAssert(ibanToBicTest("DE69600202901320815432", ("HYVEDEMM473", .ok)));
    XCTAssert(ibanToBicTest("DE92660202861457032621", ("HYVEDEMM475", .ok)));
    XCTAssert(ibanToBicTest("DE67600202900005951950", ("HYVEDEMM473", .ok)));
    XCTAssert(ibanToBicTest("DE82600202904340111112", ("HYVEDEMM473", .ok)));
    XCTAssert(ibanToBicTest("DE28600202904340118001", ("HYVEDEMM473", .ok)));
    XCTAssert(ibanToBicTest("DE42790200761050958422", ("HYVEDEMM455", .ok)));
    XCTAssert(ibanToBicTest("DE69600202901320815432", ("HYVEDEMM473", .ok)));
    XCTAssert(ibanToBicTest("DE56790200760005951950", ("HYVEDEMM455", .ok)));
    XCTAssert(ibanToBicTest("DE29790200761490196966", ("HYVEDEMM455", .ok)));
    XCTAssert(ibanToBicTest("DE41300107000000123456", ("BOTKDEDXXXX", .ok)));
    XCTAssert(ibanToBicTest("DE85300107000000654321", ("BOTKDEDXXXX", .ok)));
    XCTAssert(ibanToBicTest("DE17680523280006015002", ("SOLADES1STF", .ok)));
    XCTAssert(ibanToBicTest("DE96500604000000011404", ("GENODEFFXXX", .ok)));
    XCTAssert(ibanToBicTest("DE96500604000000011404", ("GENODEFFXXX", .ok)));
    XCTAssert(ibanToBicTest("DE49666500850000000868", ("PZHSDE66XXX", .ok)));
    XCTAssert(ibanToBicTest("DE33666500850000012602", ("PZHSDE66XXX", .ok)));
    XCTAssert(ibanToBicTest("DE12360102001231234567", ("VONEDE33XXX", .ok)));
    XCTAssert(ibanToBicTest("DE38600501010002662604", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE54600501010002659600", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE22600501017496510994", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE85600501017481501341", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE13600501017498502663", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE28600501017477501214", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE82600501017469534505", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE69600501010004475655", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE72600501017406501175", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE91600501017485500252", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE94600501017401555913", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE89600501017401555906", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE31600501017401507480", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE57600501017401507497", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE21600501017401507466", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE94600501017401555913", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE26600501017401507473", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE37600501017401555872", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE32600501017401550530", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE96600501017401501266", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE94600501017401555913", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE53600501017401502234", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE37600501017401555872", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE14600501017401512248", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE82600501017871538395", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE53600501010001366705", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE21600501010002009906", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE06600501010002001155", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE59600501010002588991", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE85600501017871513509", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE66600501017871531505", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE61600501017871521216", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE49600501010001364934", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE17600501010001367450", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE53600501010001366705", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE56600501017402051588", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE23600501010001367924", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE48600501010001372809", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE21600501010002009906", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE73600501010002782254", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE23600501010001367924", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE26600501010001362826", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE66600501010001119897", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE92600501010001375703", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE74600501017495500967", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE28600501010002810030", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE02600501017495530102", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE56600501017495501485", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE49600501010001364934", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE56600501017402046641", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE15600501017402045439", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE56600501017402051588", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE80600501017461500128", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE61600501017461505611", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE43600501017461500018", ("SOLADEST600", .ok)));
    XCTAssert(ibanToBicTest("DE93600501017461505714", ("SOLADEST600", .ok)));

    // Some of the tests below fail, even though in the IBAN creation tests the same values succeed.
    // That happens usually for bank codes that are no longer in use and need a mapping to another
    // bankcode. However this often requires a specific account which we do not have here by intention.
    // Other calls may return a different bank code than what comes out of the IBAN creation.
    XCTAssert(bankCodeToBicTest("26580070", countryCode: "de", ("DRESDEFF265", .ok)));
    XCTAssert(bankCodeToBicTest("50080000", countryCode: "de", ("DRESDEFFXXX", .ok)));
    XCTAssert(bankCodeToBicTest("50089400", countryCode: "de", ("DRESDEFFI01", .ok)));
    XCTAssert(bankCodeToBicTest("10080000", countryCode: "de", ("DRESDEFF100", .ok)));
    XCTAssert(bankCodeToBicTest("26580070", countryCode: "de", ("DRESDEFF265", .ok)));
    XCTAssert(bankCodeToBicTest("26580070", countryCode: "de", ("DRESDEFF265", .ok)));
    XCTAssert(bankCodeToBicTest("50540028", countryCode: "de", ("COBADEFFXXX", .ok)));
    XCTAssert(bankCodeToBicTest("72040046", countryCode: "de", ("COBADEFFXXX", .ok)));
    XCTAssert(bankCodeToBicTest("65440087", countryCode: "de", ("COBADEFFXXX", .ok)));
    XCTAssert(bankCodeToBicTest("23040022", countryCode: "de", ("COBADEFFXXX", .ok)));
    XCTAssert(bankCodeToBicTest("12040000", countryCode: "de", ("COBADEFFXXX", .ok)));
    XCTAssert(bankCodeToBicTest("23040022", countryCode: "de", ("COBADEFFXXX", .ok)));
    XCTAssert(bankCodeToBicTest("12040000", countryCode: "de", ("COBADEFFXXX", .ok)));
    XCTAssert(bankCodeToBicTest("50040000", countryCode: "de", ("COBADEFFXXX", .ok)));
    XCTAssert(bankCodeToBicTest("70040041", countryCode: "de", ("COBADEFFXXX", .ok)));
    XCTAssert(bankCodeToBicTest("50040000", countryCode: "de", ("COBADEFFXXX", .ok)));
    XCTAssert(bankCodeToBicTest("20041111", countryCode: "de", ("COBADEHDXXX", .ok)));
    XCTAssert(bankCodeToBicTest("37080040", countryCode: "de", ("DRESDEFF370", .ok)));
    XCTAssert(bankCodeToBicTest("50040000", countryCode: "de", ("COBADEFFXXX", .ok)));
    XCTAssert(bankCodeToBicTest("15080000", countryCode: "de", ("DRESDEFF150", .ok)));
    XCTAssert(bankCodeToBicTest("12080000", countryCode: "de", ("DRESDEFF120", .ok)));
    XCTAssert(bankCodeToBicTest("21080050", countryCode: "de", ("DRESDEFF210", .ok)));
    XCTAssert(bankCodeToBicTest("21080050", countryCode: "de", ("DRESDEFF210", .ok)));
    XCTAssert(bankCodeToBicTest("50020200", countryCode: "de", ("BHFBDEFF500", .ok)));
    XCTAssert(bankCodeToBicTest("51020000", countryCode: "de", ("BHFBDEFF500", .ok)));
    XCTAssert(bankCodeToBicTest("30020500", countryCode: "de", ("BHFBDEFF500", .ok)));
    XCTAssert(bankCodeToBicTest("20120200", countryCode: "de", ("BHFBDEFF500", .ok)));
    XCTAssert(bankCodeToBicTest("70220200", countryCode: "de", ("BHFBDEFF500", .ok)));
    XCTAssert(bankCodeToBicTest("10020200", countryCode: "de", ("BHFBDEFF500", .ok)));
    XCTAssert(bankCodeToBicTest("68351976", countryCode: "de", ("SOLADES1SFH", .ok)));
    XCTAssert(bankCodeToBicTest("68351976", countryCode: "de", ("SOLADES1SFH", .ok)));
    XCTAssert(bankCodeToBicTest("50850049", countryCode: "de", ("HELADEFFXXX", .ok)));
    XCTAssert(bankCodeToBicTest("40050000", countryCode: "de", ("WELADEDDXXX", .ok)));
    XCTAssert(bankCodeToBicTest("10090603", countryCode: "de", ("DAAEDEDDXXX", .ok)));
    XCTAssert(bankCodeToBicTest("12090640", countryCode: "de", ("DAAEDEDDXXX", .ok)));
    XCTAssert(bankCodeToBicTest("20090602", countryCode: "de", ("DAAEDEDDXXX", .ok)));
    XCTAssert(bankCodeToBicTest("21090619", countryCode: "de", ("DAAEDEDDXXX", .ok)));
    XCTAssert(bankCodeToBicTest("23092620", countryCode: "de", ("DAAEDEDDXXX", .ok)));
    XCTAssert(bankCodeToBicTest("25090608", countryCode: "de", ("DAAEDEDDXXX", .ok)));
    XCTAssert(bankCodeToBicTest("26560625", countryCode: "de", ("DAAEDEDDXXX", .ok)));
    XCTAssert(bankCodeToBicTest("27090618", countryCode: "de", ("DAAEDEDDXXX", .ok)));
    XCTAssert(bankCodeToBicTest("28090633", countryCode: "de", ("DAAEDEDDXXX", .ok)));
    XCTAssert(bankCodeToBicTest("29090605", countryCode: "de", ("DAAEDEDDXXX", .ok)));
    XCTAssert(bankCodeToBicTest("30060601", countryCode: "de", ("DAAEDEDDXXX", .ok)));
    XCTAssert(bankCodeToBicTest("33060616", countryCode: "de", ("DAAEDEDDXXX", .ok)));
    XCTAssert(bankCodeToBicTest("35060632", countryCode: "de", ("DAAEDEDDXXX", .ok)));
    XCTAssert(bankCodeToBicTest("76090613", countryCode: "de", ("DAAEDEDDXXX", .ok)));
    XCTAssert(bankCodeToBicTest("79090624", countryCode: "de", ("DAAEDEDDXXX", .ok)));
    XCTAssert(bankCodeToBicTest("50120383", countryCode: "de", ("DELBDE33XXX", .ok)));
    XCTAssert(bankCodeToBicTest("50130100", countryCode: "de", ("DELBDE33XXX", .ok)));
    XCTAssert(bankCodeToBicTest("50220200", countryCode: "de", ("DELBDE33XXX", .ok)));
    XCTAssert(bankCodeToBicTest("70030800", countryCode: "de", ("DELBDE33XXX", .ok)));
    XCTAssert(bankCodeToBicTest("35020030", countryCode: "de", ("NBAGDE3EXXX", .ok)));
    XCTAssert(bankCodeToBicTest("35020030", countryCode: "de", ("NBAGDE3EXXX", .ok)));
    XCTAssert(bankCodeToBicTest("35020030", countryCode: "de", ("NBAGDE3EXXX", .ok)));
    XCTAssert(bankCodeToBicTest("35020030", countryCode: "de", ("NBAGDE3EXXX", .ok)));
    XCTAssert(bankCodeToBicTest("25050299", countryCode: "de", ("SPKHDE2HXXX", .ok)));
    XCTAssert(bankCodeToBicTest("54520071", countryCode: "de", ("", .noBIC)));
    XCTAssert(bankCodeToBicTest("79020325", countryCode: "de", ("", .noBIC)));
    XCTAssert(bankCodeToBicTest("70020001", countryCode: "de", ("", .noBIC)));
    XCTAssert(bankCodeToBicTest("76020214", countryCode: "de", ("", .noBIC)));
    XCTAssert(bankCodeToBicTest("76220073", countryCode: "de", ("HYVEDEMM419", .ok)));
    XCTAssert(bankCodeToBicTest("66020150", countryCode: "de", ("", .noBIC)));
    XCTAssert(bankCodeToBicTest("76220073", countryCode: "de", ("HYVEDEMM419", .ok)));
    XCTAssert(bankCodeToBicTest("66020286", countryCode: "de", ("HYVEDEMM475", .ok)));
    XCTAssert(bankCodeToBicTest("76220073", countryCode: "de", ("HYVEDEMM419", .ok)));
    XCTAssert(bankCodeToBicTest("10020890", countryCode: "de", ("HYVEDEMM488", .ok)));
    XCTAssert(bankCodeToBicTest("70020270", countryCode: "de", ("HYVEDEMMXXX", .ok)));
    XCTAssert(bankCodeToBicTest("60020290", countryCode: "de", ("HYVEDEMM473", .ok)));
    XCTAssert(bankCodeToBicTest("79020076", countryCode: "de", ("HYVEDEMM455", .ok)));
    XCTAssert(bankCodeToBicTest("20110700", countryCode: "de", ("BOTKDEH1XXX", .ok)));
    XCTAssert(bankCodeToBicTest("30010700", countryCode: "de", ("BOTKDEDXXXX", .ok)));
    XCTAssert(bankCodeToBicTest("68052328", countryCode: "de", ("SOLADES1STF", .ok)));
    XCTAssert(bankCodeToBicTest("62220000", countryCode: "de", ("GENODEFFXXX", .ok)));
    XCTAssert(bankCodeToBicTest("60651070", countryCode: "de", ("PZHSDE66XXX", .ok)));
    XCTAssert(bankCodeToBicTest("10120800", countryCode: "de", ("VONEDE33XXX", .ok)));
    XCTAssert(bankCodeToBicTest("67220020", countryCode: "de", ("SOLADEST672", .ok)));
    XCTAssert(bankCodeToBicTest("67020020", countryCode: "de", ("SOLADEST671", .ok)));
    XCTAssert(bankCodeToBicTest("69421020", countryCode: "de", ("SOLADEST694", .ok)));
    XCTAssert(bankCodeToBicTest("66620020", countryCode: "de", ("SOLADEST666", .ok)));
    XCTAssert(bankCodeToBicTest("64120030", countryCode: "de", ("SOLADEST641", .ok)));
    XCTAssert(bankCodeToBicTest("64020030", countryCode: "de", ("SOLADEST640", .ok)));
    XCTAssert(bankCodeToBicTest("63020130", countryCode: "de", ("SOLADEST630", .ok)));
    XCTAssert(bankCodeToBicTest("62030050", countryCode: "de", ("SOLADEST620", .ok)));
    XCTAssert(bankCodeToBicTest("69220020", countryCode: "de", ("SOLADEST692", .ok)));
    XCTAssert(bankCodeToBicTest("55050000", countryCode: "de", ("SOLADEST550", .ok)));
    XCTAssert(bankCodeToBicTest("55050000", countryCode: "de", ("SOLADEST550", .ok)));
    XCTAssert(bankCodeToBicTest("60020030", countryCode: "de", ("SOLADEST601", .ok)));
    XCTAssert(bankCodeToBicTest("60050000", countryCode: "de", ("SOLADESTXXX", .ok)));
    XCTAssert(bankCodeToBicTest("66020020", countryCode: "de", ("SOLADEST663", .ok)));
    XCTAssert(bankCodeToBicTest("66050000", countryCode: "de", ("SOLADEST660", .ok)));
    XCTAssert(bankCodeToBicTest("86050000", countryCode: "de", ("SOLADEST861", .ok)));
  }

  func bankInfoTest(_ bic: String, _ expected: (isAvailable: Bool, country: String, name: String, city: String, address: String)) -> Bool {
    if let info = IBANtools.instituteDetailsForBIC(bic) {
      if !expected.isAvailable {
        return false;
      }
      return info.countryCode == expected.country && info.name == expected.name && info.city == expected.city
        && info.address == expected.address;
    }
    return !expected.isAvailable;
  }

  func bankInfoTest2(_ bic: String, _ expected: (isAvailable: Bool, hbciVersion: String, pinTanVersion: String, url: String)) -> Bool {
    if let info = IBANtools.instituteDetailsForBIC(bic) {
      if !expected.isAvailable {
        return false;
      }
      return info.hbciVersion == expected.hbciVersion && info.pinTanVersion == expected.pinTanVersion && info.pinTanURL == expected.url;
    }
    return !expected.isAvailable;
  }

  func bankInfoTest3(_ bankCode: String, _ expected: (isAvailable: Bool, country: String, name: String, city: String, address: String)) -> Bool {
    if let info = IBANtools.instituteDetailsForBankCode(bankCode) {
      if !expected.isAvailable {
        return false;
      }
      return info.countryCode == expected.country && info.name == expected.name && info.city == expected.city
        && info.address == expected.address;
    }
    return !expected.isAvailable;
  }

  func bankInfoTest4(_ bankCode: String, _ expected: (isAvailable: Bool, hbciVersion: String, pinTanVersion: String, url: String)) -> Bool {
    if let info = IBANtools.instituteDetailsForBankCode(bankCode) {
      if !expected.isAvailable {
        return false;
      }
      return info.hbciVersion == expected.hbciVersion && info.pinTanVersion == expected.pinTanVersion && info.pinTanURL == expected.url;
    }
    return !expected.isAvailable;
  }

  func testBankInfo() {
    XCTAssert(bankInfoTest("CKCNIE21", (true, "IE", "St. Canice's Kilkenny Credit Union Limited", "Co Kilkenny", "78 High Street, Kilkenny,")));
    XCTAssert(bankInfoTest("BCDMITM1XXX", (true, "IT", "BANQUE CHAABI DU MAROC", "MILANO", "VIALE SAURO NAZARIO, 14")));

    XCTAssert(bankInfoTest2("HYVEDEMM466", (true, "300", "300", "https://hbci-01.hypovereinsbank.de/bank/hbci")));
    XCTAssert(bankInfoTest2("WELADED1EMR", (true, "300", "300", "https://banking-rl2.s-fints-pt-rl.de/fints30")));

    let (bic, _): (String, IBANToolsResult) = IBANtools.bicForBankCode("30060601", countryCode: "DE");
    XCTAssert(bankInfoTest(bic, (true, "DE", "Deutsche Apotheker- und Ärztebank eG", "Düsseldorf", "")));
    XCTAssert(bankInfoTest2(bic, (true, "300", "300", "https://hbci-pintan.gad.de/cgi-bin/hbciservlet")));

    XCTAssert(bankInfoTest3("30060601", (true, "DE", "Deutsche Apotheker- und Ärztebank eG", "Düsseldorf", "")));
    XCTAssert(bankInfoTest4("30060601", (true, "300", "300", "https://hbci-pintan.gad.de/cgi-bin/hbciservlet")));

  }
}
