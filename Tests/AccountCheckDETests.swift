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

import XCTest
import IBANtools

class AccountCheckDETests: XCTestCase {

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  func checkAccount(var account: String, var bankCode: String) -> Bool {
    return IBANtools.isValidAccount(&account, bankCode: &bankCode, countryCode: "de").valid;
  }

  func testChecksums() {
    // 00
    // Tests for a 0-account mostly test if the algorithm is robust against such a corner case,
    // not so much to compute a valid account number/checksum.
    XCTAssert(checkAccount("0", bankCode: "12030000"), "Rule 00.0");

    XCTAssert(checkAccount("9290701", bankCode: "12030000"), "Rule 00.1");
    XCTAssert(checkAccount("539290858", bankCode: "12030000"), "Rule 00.2");
    XCTAssert(checkAccount("1501824", bankCode: "12030000"), "Rule 00.3");
    XCTAssert(checkAccount("1501832", bankCode: "12030000"), "Rule 00.4");

    // 01 - no test case yet, don't include a single 0-account test, if there are no real test cases too.
    // 02 - no test case yet
    // 03 - no test case yet
    // 04 - no test case yet
    // 05 - no test case yet

    // 06
    XCTAssert(checkAccount("0", bankCode: "15091704"), "Rule 06.0");
    XCTAssert(checkAccount("94012341", bankCode: "15091704"), "Rule 06.1");
    XCTAssert(checkAccount("5073321010", bankCode: "15091704"), "Rule 06.2");

    // 07 - no test case yet
    // 08 - no test case yet

    // 09 - no checksum check, all accounts are valid
    XCTAssert(checkAccount("0", bankCode: "16010300"), "Rule 09.0");
    XCTAssert(checkAccount("12345", bankCode: "16010300"), "Rule 09.1");
    XCTAssert(checkAccount("9999999999", bankCode: "16010300"), "Rule 09.2");

    // 10
    XCTAssert(checkAccount("0", bankCode: "20030133"), "Rule 10.0");
    XCTAssert(checkAccount("12345008", bankCode: "20030133"), "Rule 10.1");
    XCTAssert(checkAccount("87654008", bankCode: "20030133"), "Rule 10.2");

    // 11 - no test case yet
    // 12 - not used
    // 13 - no test case yet
    // 14 - no test case yet
    // 15 - no test case yet
    // 16 - no test case yet

    // 17
    XCTAssertFalse(checkAccount("0", bankCode: "10110600"), "Rule 17.0");
    XCTAssert(checkAccount("0446786040", bankCode: "10110600"), "Rule 17.1");

    // 18 - no test case yet

    // 19
    XCTAssert(checkAccount("0", bankCode: "10220600"), "Rule 19.0");
    XCTAssert(checkAccount("0240334000", bankCode: "10220600"), "Rule 19.1");
    XCTAssert(checkAccount("0200520016", bankCode: "10220600"), "Rule 19.2");

    // 20 - no test case yet
    // 21 - no test case yet
    // 22 - used by C2 and tested by its test cases
    // 23 - no test case yet

    // 24
    XCTAssertFalse(checkAccount("0", bankCode: "37010050"), "Rule 24.0");
    XCTAssert(checkAccount("1 3 8 3 0 1", bankCode: "37010050"), "Rule 24.1");
    XCTAssert(checkAccount("1 3 0 6 1 1 8 6 0 5", bankCode: "37010050"), "Rule 24.2");
    XCTAssert(checkAccount("3 3 0 7 1 1 8 6 0 8", bankCode: "37010050"), "Rule 24.3");
    XCTAssert(checkAccount("9 3 0 7 1 1 8 6 0 3", bankCode: "37010050"), "Rule 24.4");

    // 25
    XCTAssert(checkAccount("0", bankCode: "42050001"), "Rule 25.0");
    XCTAssert(checkAccount("5 2 1 3 8 2 1 8 1", bankCode: "42050001"), "Rule 25.1");

    // 26
    XCTAssert(checkAccount("0", bankCode: "72012300"), "Rule 26.0");
    XCTAssert(checkAccount("0520309001", bankCode: "72012300"), "Rule 26.1");
    XCTAssert(checkAccount("1111118111", bankCode: "72012300"), "Rule 26.2");
    XCTAssert(checkAccount("0005501024", bankCode: "72012300"), "Rule 26.3");

    // 27
    XCTAssert(checkAccount("0", bankCode: "25050000"), "Rule 27.0");
    XCTAssert(checkAccount("12344", bankCode: "25050000"), "Rule 27.1");
    XCTAssert(checkAccount("2847169488", bankCode: "25050000"), "Rule 27.2");

    // 28
    XCTAssert(checkAccount("0", bankCode: "16062008"), "Rule 28.0");
    XCTAssert(checkAccount("19999000", bankCode: "16062008"), "Rule 28.1");
    XCTAssert(checkAccount("9130000201", bankCode: "16062008"), "Rule 28.2");

    // 29
    XCTAssertFalse(checkAccount("0", bankCode: "29050000"), "Rule 29.0");
    XCTAssert(checkAccount("3 1 4 5 8 6 3 0 2 9", bankCode: "29050000"), "Rule 29.1");

    // 30 - no test case yet

    // 31
    XCTAssert(checkAccount("0", bankCode: "50324000"), "Rule 31.0");
    XCTAssert(checkAccount("1000000524", bankCode: "50324000"), "Rule 31.1");
    XCTAssert(checkAccount("1000000583", bankCode: "50324000"), "Rule 31.2");

    // 32
    XCTAssert(checkAccount("0", bankCode: "50560102"), "Rule 32.0");
    XCTAssert(checkAccount("9141405", bankCode: "50560102"), "Rule 32.1");
    XCTAssert(checkAccount("1709107983", bankCode: "50560102"), "Rule 32.2");
    XCTAssert(checkAccount("0122116979", bankCode: "50560102"), "Rule 32.3");
    XCTAssert(checkAccount("0121114867", bankCode: "50560102"), "Rule 32.4");
    XCTAssert(checkAccount("9030101192", bankCode: "50560102"), "Rule 32.5");
    XCTAssert(checkAccount("9245500460", bankCode: "50560102"), "Rule 32.6");

    // 33
    XCTAssert(checkAccount("0", bankCode: "10060237"), "Rule 33.0");
    XCTAssert(checkAccount("48658", bankCode: "10060237"), "Rule 33.1");
    XCTAssert(checkAccount("84956", bankCode: "10060237"), "Rule 33.2");

    // 34
    XCTAssert(checkAccount("0", bankCode: "36060488"), "Rule 34.0");
    XCTAssert(checkAccount("9913000700", bankCode: "36060488"), "Rule 34.1");
    XCTAssert(checkAccount("9914001000", bankCode: "36060488"), "Rule 34.2");

    // 35 - defined but not used it seems. Use dummy bank codes for these tests.
    XCTAssert(checkAccount("0", bankCode: "11111111"), "Rule 35.0");
    XCTAssert(checkAccount("0000108443", bankCode: "11111111"), "Rule 35.1");
    XCTAssert(checkAccount("0000107451", bankCode: "11111111"), "Rule 35.2");
    XCTAssert(checkAccount("0000102921", bankCode: "11111111"), "Rule 35.3");
    XCTAssert(checkAccount("0000102349", bankCode: "11111111"), "Rule 35.4");
    XCTAssert(checkAccount("0000101709", bankCode: "11111111"), "Rule 35.5");
    XCTAssert(checkAccount("0000101599", bankCode: "11111111"), "Rule 35.6");

    // 36 - same as for 35
    XCTAssert(checkAccount("0", bankCode: "11111112"), "Rule 36.0");
    XCTAssert(checkAccount("113178", bankCode: "11111112"), "Rule 36.1");
    XCTAssert(checkAccount("146666", bankCode: "11111112"), "Rule 36.2");

    // 37 - same as for 35
    XCTAssert(checkAccount("0", bankCode: "11111113"), "Rule 37.0");
    XCTAssert(checkAccount("624315", bankCode: "11111113"), "Rule 37.1");
    XCTAssert(checkAccount("632500", bankCode: "11111113"), "Rule 37.2");

    // 38
    XCTAssert(checkAccount("0", bankCode: "38621500"), "Rule 38.0");
    XCTAssert(checkAccount("191919", bankCode: "38621500"), "Rule 38.1");
    XCTAssert(checkAccount("1100660", bankCode: "38621500"), "Rule 38.2");

    // 39 - same as for 35
    XCTAssert(checkAccount("0", bankCode: "11111114"), "Rule 39.0");
    XCTAssert(checkAccount("624315", bankCode: "11111114"), "Rule 39.1");
    XCTAssert(checkAccount("632500", bankCode: "11111114"), "Rule 39.2");

    // 40
    XCTAssert(checkAccount("0", bankCode: "56062227"), "Rule 40.0");
    XCTAssert(checkAccount("1258345", bankCode: "56062227"), "Rule 40.1");
    XCTAssert(checkAccount("3231963", bankCode: "56062227"), "Rule 40.2");

    // 41
    XCTAssert(checkAccount("0", bankCode: "25020600"), "Rule 41.0");
    XCTAssert(checkAccount("4013410024", bankCode: "25020600"), "Rule 41.1");
    XCTAssert(checkAccount("4016660195", bankCode: "25020600"), "Rule 41.2");
    XCTAssert(checkAccount("0166805317", bankCode: "25020600"), "Rule 41.3");
    XCTAssert(checkAccount("4029310079", bankCode: "25020600"), "Rule 41.4");
    XCTAssert(checkAccount("4029340829", bankCode: "25020600"), "Rule 41.5");
    XCTAssert(checkAccount("4029151002", bankCode: "25020600"), "Rule 41.6");

    // 42
    XCTAssert(checkAccount("0", bankCode: "66661454"), "Rule 42.0");
    XCTAssert(checkAccount("59498", bankCode: "66661454"), "Rule 42.1");
    XCTAssert(checkAccount("59510", bankCode: "66661454"), "Rule 42.2");

    // 43
    XCTAssert(checkAccount("0", bankCode: "66690000"), "Rule 43.0");
    XCTAssert(checkAccount("6135244", bankCode: "66690000"), "Rule 43.1");
    XCTAssert(checkAccount("9516893476", bankCode: "66690000"), "Rule 43.2");

    // 44
    XCTAssert(checkAccount("0", bankCode: "30060010"), "Rule 44.0");
    XCTAssert(checkAccount("889006", bankCode: "30060010"), "Rule 44.1");
    XCTAssert(checkAccount("2618040504", bankCode: "30060010"), "Rule 44.2");

    // 45
    XCTAssert(checkAccount("0", bankCode: "29020000"), "Rule 45.0");
    XCTAssert(checkAccount("3545343232", bankCode: "29020000"), "Rule 45.1");
    XCTAssert(checkAccount("4013410024", bankCode: "29020000"), "Rule 45.2");
    XCTAssert(checkAccount("0994681254", bankCode: "29020000"), "Rule 45.3");
    XCTAssert(checkAccount("0000012340", bankCode: "29020000"), "Rule 45.4");
    XCTAssert(checkAccount("1000199999", bankCode: "29020000"), "Rule 45.5");
    XCTAssert(checkAccount("0100114240", bankCode: "29020000"), "Rule 45.6");

    // 46
    XCTAssert(checkAccount("0", bankCode: "50310400"), "Rule 46.0");
    XCTAssert(checkAccount("0235468612", bankCode: "50310400"), "Rule 46.1");
    XCTAssert(checkAccount("0837890901", bankCode: "50310400"), "Rule 46.2");
    XCTAssert(checkAccount("1041447600", bankCode: "50310400"), "Rule 46.3");

    // 47
    XCTAssert(checkAccount("0", bankCode: "27290087"), "Rule 47.0");
    XCTAssert(checkAccount("1018000", bankCode: "27290087"), "Rule 47.1");
    XCTAssert(checkAccount("1003554450", bankCode: "27290087"), "Rule 47.2");

    // 48 - no test case yet
    // 49 - no test case yet

    // 50
    XCTAssert(checkAccount("0", bankCode: "51220910"), "Rule 50.0");
    XCTAssert(checkAccount("4000005001", bankCode: "51220910"), "Rule 50.1");
    XCTAssert(checkAccount("4444442001", bankCode: "51220910"), "Rule 50.2");
    XCTAssert(checkAccount("4444442", bankCode: "51220910"), "Rule 50.3");

    // 51 - this one is crazy: 4 different approaches used until one succeeds + 2 special cases.
    // The cases that must fail are probably meant to fail the specific sub check, but may succeed in
    // a following one. So, some of the fail values are not included here.
    XCTAssert(checkAccount("0", bankCode: "33060592"), "Rule 51.0");
    XCTAssert(checkAccount("0001156071", bankCode: "33060592"), "Rule 51.1");
    XCTAssert(checkAccount("0001156136", bankCode: "33060592"), "Rule 51.2");
    XCTAssertFalse(checkAccount("0000156079", bankCode: "33060592"), "Rule 51.4"); // must fail
    XCTAssert(checkAccount("0001156078", bankCode: "33060592"), "Rule 51.5");
    XCTAssert(checkAccount("0001234567", bankCode: "33060592"), "Rule 51.6");
    XCTAssertFalse(checkAccount("0012345678", bankCode: "33060592"), "Rule 51.8"); // must fail
    XCTAssert(checkAccount("340968", bankCode: "33060592"), "Rule 51.9");
    XCTAssert(checkAccount("201178", bankCode: "33060592"), "Rule 51.10");
    XCTAssert(checkAccount("1009588", bankCode: "33060592"), "Rule 51.10");
    XCTAssertFalse(checkAccount("0023456783", bankCode: "33060592"), "Rule 51.11"); // must fail
    XCTAssertFalse(checkAccount("0076543211", bankCode: "33060592"), "Rule 51.12"); // must fail
    XCTAssert(checkAccount("0000156071", bankCode: "33060592"), "Rule 51.13");
    XCTAssert(checkAccount("101356073", bankCode: "33060592"), "Rule 51.14");
    XCTAssertFalse(checkAccount("0123412345", bankCode: "33060592"), "Rule 51.15"); // must fail
    XCTAssertFalse(checkAccount("67493647", bankCode: "33060592"), "Rule 51.16"); // must fail

    // Special cases
    XCTAssert(checkAccount("0199100002", bankCode: "33060592"), "Rule 51.17");
    XCTAssert(checkAccount("0099100010", bankCode: "33060592"), "Rule 51.18");
    XCTAssert(checkAccount("2599100002", bankCode: "33060592"), "Rule 51.19");
    XCTAssertFalse(checkAccount("0099345678", bankCode: "33060592"), "Rule 51.22"); // must fail
    XCTAssert(checkAccount("0199100004", bankCode: "33060592"), "Rule 51.23");
    XCTAssert(checkAccount("2599100003", bankCode: "33060592"), "Rule 51.24");
    XCTAssert(checkAccount("3199204090", bankCode: "33060592"), "Rule 51.25");
    XCTAssertFalse(checkAccount("0099345678", bankCode: "33060592"), "Rule 51.26"); // must fail
    XCTAssertFalse(checkAccount("0099100110", bankCode: "33060592"), "Rule 51.27"); // must fail
    XCTAssertFalse(checkAccount("0199100040", bankCode: "33060592"), "Rule 51.28"); // must fail

    // 52
    XCTAssertFalse(checkAccount("0", bankCode: "13051172"), "Rule 52.0");
    XCTAssert(checkAccount("43001500", bankCode: "13051172"), "Rule 52.1");

    // 53 - used as second chance by method B6
    XCTAssertFalse(checkAccount("0", bankCode: "16052072"), "Rule 53.0");
    XCTAssert(checkAccount("382432256", bankCode: "16052082"), "Rule 53.1");

    // 54
    XCTAssertFalse(checkAccount("0", bankCode: "11111115"), "Rule 54.0");
    XCTAssert(checkAccount("49 64137395", bankCode: "11111115"), "Rule 54.1");
    XCTAssert(checkAccount("49 00010987", bankCode: "11111115"), "Rule 54.2");

    // 55 - no test case yet

    // 56
    XCTAssertFalse(checkAccount("0", bankCode: "51051000"), "Rule 56.0");
    XCTAssert(checkAccount("0 2 9 0 5 4 5 0 0 5", bankCode: "51051000"), "Rule 56.1");
    XCTAssert(checkAccount("9718304037", bankCode: "51051000"), "Rule 56.2");

    // 57 - also here multiple variants.
    XCTAssertFalse(checkAccount("0", bankCode: "30020900"), "Rule 57.0");
    XCTAssert(checkAccount("7500021766", bankCode: "30020900"), "Rule 57.1");
    XCTAssert(checkAccount("9400001734", bankCode: "30020900"), "Rule 57.2");
    XCTAssert(checkAccount("7800028282", bankCode: "30020900"), "Rule 57.3");
    XCTAssert(checkAccount("8100244186", bankCode: "30020900"), "Rule 57.4");
    XCTAssert(checkAccount("3251080371", bankCode: "30020900"), "Rule 57.5");
    XCTAssert(checkAccount("3891234567", bankCode: "30020900"), "Rule 57.6");
    XCTAssert(checkAccount("7777778800", bankCode: "30020900"), "Rule 57.7");
    XCTAssert(checkAccount("5001050352", bankCode: "30020900"), "Rule 57.8");
    XCTAssert(checkAccount("5045090090", bankCode: "30020900"), "Rule 57.9");
    XCTAssert(checkAccount("1909700805", bankCode: "30020900"), "Rule 57.10");
    XCTAssert(checkAccount("9322111030", bankCode: "30020900"), "Rule 57.11");
    XCTAssert(checkAccount("7400060823", bankCode: "30020900"), "Rule 57.12");

    XCTAssertFalse(checkAccount("5302707782", bankCode: "30020900"), "Rule 57.13"); // must fail
    XCTAssertFalse(checkAccount("6412121212", bankCode: "30020900"), "Rule 57.14"); // must fail
    XCTAssertFalse(checkAccount("1813499124", bankCode: "30020900"), "Rule 57.15"); // must fail
    XCTAssertFalse(checkAccount("2206735010", bankCode: "30020900"), "Rule 57.16"); // must fail

    // 58
    XCTAssert(checkAccount("0", bankCode: "20120100"), "Rule 58.0");
    XCTAssert(checkAccount("1800881120", bankCode: "20120100"), "Rule 58.1");
    XCTAssert(checkAccount("9200654108", bankCode: "20120100"), "Rule 58.2");
    XCTAssert(checkAccount("1015222224", bankCode: "20120100"), "Rule 58.3");
    XCTAssert(checkAccount("3703169668", bankCode: "20120100"), "Rule 58.4");

    // 59 - no test case yet
    // 60 - no test case yet

    // 61
    XCTAssert(checkAccount("0", bankCode: "25621327"), "Rule 61.0");
    XCTAssert(checkAccount("2 0 6 3 0 9 9 2 0 0", bankCode: "25621327"), "Rule 61.1");
    XCTAssert(checkAccount("0 2 6 0 7 6 0 2 8 2", bankCode: "25621327"), "Rule 61.2");

    // 62
    XCTAssert(checkAccount("0", bankCode: "11111116"), "Rule 62.0");
    XCTAssert(checkAccount("5 0 2 9 0 7 6 7 0 1", bankCode: "11111116"), "Rule 62.1");

    // 63
    XCTAssert(checkAccount("0", bankCode: "25770024"), "Rule 63.0");
    XCTAssert(checkAccount("1 2 3 4 5 6 6 0 0", bankCode: "25770024"), "Rule 63.1");
    XCTAssert(checkAccount("0 0 0 1 2 3 4 5 6 6", bankCode: "25770024"), "Rule 63.2");

    // 64
    XCTAssert(checkAccount("0", bankCode: "57090000"), "Rule 64.0");
    XCTAssert(checkAccount("1206473010", bankCode: "57090000"), "Rule 64.1");
    XCTAssert(checkAccount("5016511020", bankCode: "57090000"), "Rule 64.2");

    // 65
    XCTAssert(checkAccount("0", bankCode: "60020030"), "Rule 65.0");
    XCTAssert(checkAccount("1 2 3 4 5 6 7 4 0 0", bankCode: "60020030"), "Rule 65.1");
    XCTAssert(checkAccount("1 2 3 4 5 6 7 5 9 0", bankCode: "60020030"), "Rule 65.2");

    // 66
    XCTAssertFalse(checkAccount("0", bankCode: "50120500"), "Rule 66.0");
    XCTAssert(checkAccount("100150502", bankCode: "50120500"), "Rule 66.1");
    XCTAssert(checkAccount("100154508", bankCode: "50120500"), "Rule 66.2");
    XCTAssert(checkAccount("101154508", bankCode: "50120500"), "Rule 66.3");
    XCTAssert(checkAccount("100154516", bankCode: "50120500"), "Rule 66.4");
    XCTAssert(checkAccount("101154516", bankCode: "50120500"), "Rule 66.5");
    XCTAssert(checkAccount("0983393104", bankCode: "50120500"), "Rule 66.6");

    // 67 - no test case yet

    // 68
    XCTAssertFalse(checkAccount("0", bankCode: "20030000"), "Rule 68.0");

    XCTAssert(checkAccount("8 8 8 9 6 5 4 3 2 8", bankCode: "20030000"), "Rule 68.1");
    XCTAssert(checkAccount("9 8 7 6 5 4 3 2 4", bankCode: "20030000"), "Rule 68.2");
    XCTAssert(checkAccount("9 8 7 6 5 4 3 2 8", bankCode: "20030000"), "Rule 68.3");
    XCTAssert(checkAccount("400 000 000", bankCode: "20030000"), "Rule 68.4");

    // 69
    XCTAssert(checkAccount("0", bankCode: "11111117"), "Rule 69.0");
    XCTAssert(checkAccount("9 7 2 1 1 3 4 8 6 9", bankCode: "11111117"), "Rule 69.1");
    XCTAssert(checkAccount("1234567900", bankCode: "11111117"), "Rule 69.2");
    XCTAssert(checkAccount("1234567006", bankCode: "11111117"), "Rule 69.3");
    XCTAssert(checkAccount("9 300 000 000", bankCode: "11111117"), "Rule 69.4");

    // 70 - not used and no test case yet

    // 71
    XCTAssert(checkAccount("0", bankCode: "65110200"), "Rule 71.0");
    XCTAssert(checkAccount("7 1 0 1 2 3 4 0 0 7", bankCode: "65110200"), "Rule 71.1");

    // 72 - not used and no test case yet

    // 73 - also here multiple variants.
    XCTAssert(checkAccount("0", bankCode: "50090500"), "Rule 73.0");
    XCTAssert(checkAccount("0003503398", bankCode: "50090500"), "Rule 73.1");
    XCTAssert(checkAccount("0001340967", bankCode: "50090500"), "Rule 73.2");
    XCTAssert(checkAccount("0003503391", bankCode: "50090500"), "Rule 73.3");
    XCTAssert(checkAccount("0001340968", bankCode: "50090500"), "Rule 73.4");
    XCTAssert(checkAccount("0003503392", bankCode: "50090500"), "Rule 73.5");
    XCTAssert(checkAccount("0001340966", bankCode: "50090500"), "Rule 73.6");
    XCTAssert(checkAccount("123456", bankCode: "50090500"), "Rule 73.7");
    XCTAssert(checkAccount("0199100002", bankCode: "50090500"), "Rule 73.8");
    XCTAssert(checkAccount("0099100010", bankCode: "50090500"), "Rule 73.9");
    XCTAssert(checkAccount("2599100002", bankCode: "50090500"), "Rule 73.10");
    XCTAssert(checkAccount("0199100004", bankCode: "50090500"), "Rule 73.11");
    XCTAssert(checkAccount("2599100003", bankCode: "50090500"), "Rule 73.12");
    XCTAssert(checkAccount("3199204090", bankCode: "50090500"), "Rule 73.13");

    XCTAssertFalse(checkAccount("121212", bankCode: "50090500"), "Rule 73.14"); // must fail
    XCTAssertFalse(checkAccount("987654321", bankCode: "50090500"), "Rule 73.15"); // must fail
    XCTAssertFalse(checkAccount("0099345678", bankCode: "50090500"), "Rule 73.16"); // must fail
    XCTAssertFalse(checkAccount("0099100110", bankCode: "50090500"), "Rule 73.17"); // must fail
    XCTAssertFalse(checkAccount("0199100040", bankCode: "50090500"), "Rule 73.18"); // must fail

    // 74 - also here multiple variants.
    XCTAssert(checkAccount("0", bankCode: "21050170"), "Rule 74.0");
    XCTAssert(checkAccount("1016", bankCode: "21050170"), "Rule 74.1");
    XCTAssert(checkAccount("26260", bankCode: "21050170"), "Rule 74.2");
    XCTAssert(checkAccount("242243", bankCode: "21050170"), "Rule 74.3");
    XCTAssert(checkAccount("242248", bankCode: "21050170"), "Rule 74.4");
    XCTAssert(checkAccount("18002113", bankCode: "21050170"), "Rule 74.5");
    XCTAssert(checkAccount("1821200043", bankCode: "21050170"), "Rule 74.6");

    XCTAssertFalse(checkAccount("1011", bankCode: "21050170"), "Rule 74.7"); // must fail
    XCTAssertFalse(checkAccount("26265", bankCode: "21050170"), "Rule 74.8"); // must fail
    XCTAssertFalse(checkAccount("18002118", bankCode: "21050170"), "Rule 74.9"); // must fail
    XCTAssertFalse(checkAccount("6160000024", bankCode: "21050170"), "Rule 74.10"); // must fail

    // 75 - used by method C5 and tested by its test cases

    // 76
    XCTAssert(checkAccount("0", bankCode: "21080050"), "Rule 76.0");
    XCTAssert(checkAccount("0006543200", bankCode: "21080050"), "Rule 76.1");
    XCTAssert(checkAccount("9012345600", bankCode: "21080050"), "Rule 76.2");
    XCTAssert(checkAccount("7876543100", bankCode: "21080050"), "Rule 76.3");
    XCTAssert(checkAccount("78765431", bankCode: "21080050"), "Rule 76.4");

    // 77
    XCTAssert(checkAccount("0", bankCode: "11111118"), "Rule 77.0");
    XCTAssert(checkAccount("10338", bankCode: "11111118"), "Rule 77.1");
    XCTAssert(checkAccount("13844", bankCode: "11111118"), "Rule 77.2");
    XCTAssert(checkAccount("65354", bankCode: "11111118"), "Rule 77.3");
    XCTAssert(checkAccount("69258", bankCode: "11111118"), "Rule 77.4");

    // 78
    XCTAssert(checkAccount("0", bankCode: "36050105"), "Rule 78.0");
    XCTAssert(checkAccount("7581499", bankCode: "36050105"), "Rule 78.1");
    XCTAssert(checkAccount("9999999981", bankCode: "36050105"), "Rule 78.2");
    XCTAssert(checkAccount("12345678", bankCode: "36050105"), "Rule 78.3");

    // 79
    XCTAssertFalse(checkAccount("0", bankCode: "11111119"), "Rule 79.0");
    XCTAssert(checkAccount("3230012688", bankCode: "11111119"), "Rule 79.1");
    XCTAssert(checkAccount("4230028872", bankCode: "11111119"), "Rule 79.2");
    XCTAssert(checkAccount("5440001898", bankCode: "11111119"), "Rule 79.3");
    XCTAssert(checkAccount("6330001063", bankCode: "11111119"), "Rule 79.4");
    XCTAssert(checkAccount("7000149349", bankCode: "11111119"), "Rule 79.5");
    XCTAssert(checkAccount("8000003577", bankCode: "11111119"), "Rule 79.6");
    XCTAssert(checkAccount("1550167850", bankCode: "11111119"), "Rule 79.7");
    XCTAssert(checkAccount("9011200140", bankCode: "11111119"), "Rule 79.8");

    // 80
    XCTAssert(checkAccount("0", bankCode: "11111120"), "Rule 80.0");
    XCTAssert(checkAccount("340968", bankCode: "11111120"), "Rule 80.1");
    XCTAssert(checkAccount("340966", bankCode: "11111120"), "Rule 80.2");

    // Special cases (like in rule 51)
    XCTAssert(checkAccount("0199100002", bankCode: "11111120"), "Rule 80.3");
    XCTAssert(checkAccount("0099100010", bankCode: "11111120"), "Rule 80.4");
    XCTAssert(checkAccount("2599100002", bankCode: "11111120"), "Rule 80.5");
    XCTAssertFalse(checkAccount("0099345678", bankCode: "11111120"), "Rule 80.6"); // must fail
    XCTAssert(checkAccount("0199100004", bankCode: "11111120"), "Rule 80.7");
    XCTAssert(checkAccount("2599100003", bankCode: "11111120"), "Rule 80.8");
    XCTAssert(checkAccount("3199204090", bankCode: "11111120"), "Rule 80.9");
    XCTAssertFalse(checkAccount("0099345678", bankCode: "11111120"), "Rule 80.10"); // must fail
    XCTAssertFalse(checkAccount("0099100110", bankCode: "11111120"), "Rule 80.11"); // must fail
    XCTAssertFalse(checkAccount("0199100040", bankCode: "11111120"), "Rule 80.12"); // must fail

    // 81
    XCTAssert(checkAccount("0", bankCode: "70090500"), "Rule 81.0");
    XCTAssert(checkAccount("0646440", bankCode: "70090500"), "Rule 81.1");
    XCTAssert(checkAccount("1359100", bankCode: "70090500"), "Rule 81.2");

    // Special cases (like in rule 51)
    XCTAssert(checkAccount("0199100002", bankCode: "70090500"), "Rule 81.3");
    XCTAssert(checkAccount("0099100010", bankCode: "70090500"), "Rule 81.4");
    XCTAssert(checkAccount("2599100002", bankCode: "70090500"), "Rule 81.5");
    XCTAssertFalse(checkAccount("0099345678", bankCode: "70090500"), "Rule 81.6"); // must fail
    XCTAssert(checkAccount("0199100004", bankCode: "70090500"), "Rule 81.7");
    XCTAssert(checkAccount("2599100003", bankCode: "70090500"), "Rule 81.8");
    XCTAssert(checkAccount("3199204090", bankCode: "70090500"), "Rule 81.9");
    XCTAssertFalse(checkAccount("0099345678", bankCode: "70090500"), "Rule 81.10"); // must fail
    XCTAssertFalse(checkAccount("0099100110", bankCode: "70090500"), "Rule 81.11"); // must fail
    XCTAssertFalse(checkAccount("0199100040", bankCode: "70090500"), "Rule 81.12"); // must fail

    // 82
    XCTAssert(checkAccount("0", bankCode: "11111121"), "Rule 82.0");
    XCTAssert(checkAccount("123897", bankCode: "11111121"), "Rule 82.1");
    XCTAssert(checkAccount("3199500501", bankCode: "11111121"), "Rule 82.2");

    // 83
    XCTAssert(checkAccount("0", bankCode: "11111122"), "Rule 83.0");
    XCTAssert(checkAccount("0001156071", bankCode: "11111122"), "Rule 83.1");
    XCTAssert(checkAccount("0001156136", bankCode: "11111122"), "Rule 83.2");
    XCTAssert(checkAccount("0000156078", bankCode: "11111122"), "Rule 83.3");
    XCTAssert(checkAccount("0000156071", bankCode: "11111122"), "Rule 83.4");
    XCTAssert(checkAccount("0099100002", bankCode: "11111122"), "Rule 83.5");

    // 84
    XCTAssert(checkAccount("0", bankCode: "72090500"), "Rule 84.0");
    XCTAssert(checkAccount("240699", bankCode: "72090500"), "Rule 84.1");
    XCTAssert(checkAccount("350982", bankCode: "72090500"), "Rule 84.2");
    XCTAssert(checkAccount("461059", bankCode: "72090500"), "Rule 84.3");
    XCTAssertFalse(checkAccount("240965", bankCode: "72090500"), "Rule 84.4"); // must fail
    XCTAssertFalse(checkAccount("350980", bankCode: "72090500"), "Rule 84.5"); // must fail
    XCTAssertFalse(checkAccount("461053", bankCode: "72090500"), "Rule 84.6"); // must fail
    XCTAssert(checkAccount("240692", bankCode: "72090500"), "Rule 84.7");
    XCTAssert(checkAccount("350985", bankCode: "72090500"), "Rule 84.8");
    XCTAssert(checkAccount("461052", bankCode: "72090500"), "Rule 84.9");
    XCTAssertFalse(checkAccount("240965", bankCode: "72090500"), "Rule 84.10"); // must fail
    XCTAssertFalse(checkAccount("350980", bankCode: "72090500"), "Rule 84.11"); // must fail
    XCTAssertFalse(checkAccount("461053", bankCode: "72090500"), "Rule 84.12"); // must fail
    XCTAssert(checkAccount("240961", bankCode: "72090500"), "Rule 84.13");
    XCTAssert(checkAccount("350984", bankCode: "72090500"), "Rule 84.14");
    XCTAssert(checkAccount("461054", bankCode: "72090500"), "Rule 84.15");
    XCTAssertFalse(checkAccount("240965", bankCode: "72090500"), "Rule 84.16"); // must fail
    XCTAssertFalse(checkAccount("350980", bankCode: "72090500"), "Rule 84.17"); // must fail
    XCTAssertFalse(checkAccount("461053", bankCode: "72090500"), "Rule 84.18"); // must fail

    // Special cases (like in rule 51)
    XCTAssert(checkAccount("0199100002", bankCode: "72090500"), "Rule 84.3");
    XCTAssert(checkAccount("0099100010", bankCode: "72090500"), "Rule 84.4");
    XCTAssert(checkAccount("2599100002", bankCode: "72090500"), "Rule 84.5");
    XCTAssertFalse(checkAccount("0099345678", bankCode: "72090500"), "Rule 84.6"); // must fail
    XCTAssert(checkAccount("0199100004", bankCode: "72090500"), "Rule 84.7");
    XCTAssert(checkAccount("2599100003", bankCode: "72090500"), "Rule 84.8");
    XCTAssert(checkAccount("3199204090", bankCode: "72090500"), "Rule 84.9");
    XCTAssertFalse(checkAccount("0099345678", bankCode: "72090500"), "Rule 84.10"); // must fail
    XCTAssertFalse(checkAccount("0099100110", bankCode: "72090500"), "Rule 84.11"); // must fail
    XCTAssertFalse(checkAccount("0199100040", bankCode: "72090500"), "Rule 84.12"); // must fail

    // 85
    XCTAssert(checkAccount("0", bankCode: "40060560"), "Rule 85.0");
    XCTAssert(checkAccount("0001156071", bankCode: "40060560"), "Rule 85.1");
    XCTAssert(checkAccount("0001156136", bankCode: "40060560"), "Rule 85.2");
    XCTAssert(checkAccount("0000156078", bankCode: "40060560"), "Rule 85.3");
    XCTAssert(checkAccount("0000156071", bankCode: "40060560"), "Rule 85.4");
    XCTAssert(checkAccount("3199100002", bankCode: "40060560"), "Rule 85.5");

    // 86
    XCTAssert(checkAccount("0", bankCode: "11111123"), "Rule 84.0");
    XCTAssert(checkAccount("340968", bankCode: "11111123"), "Rule 84.1");
    XCTAssert(checkAccount("1001171", bankCode: "11111123"), "Rule 84.2");
    XCTAssert(checkAccount("1009588", bankCode: "11111123"), "Rule 84.3");
    XCTAssert(checkAccount("123897", bankCode: "11111123"), "Rule 84.4");
    XCTAssert(checkAccount("340960", bankCode: "11111123"), "Rule 84.5");

    // Special cases (like in rule 51)
    XCTAssert(checkAccount("0199100002", bankCode: "11111123"), "Rule 84.3");
    XCTAssert(checkAccount("0099100010", bankCode: "11111123"), "Rule 84.4");
    XCTAssert(checkAccount("2599100002", bankCode: "11111123"), "Rule 84.5");
    XCTAssertFalse(checkAccount("0099345678", bankCode: "11111123"), "Rule 84.6"); // must fail
    XCTAssert(checkAccount("0199100004", bankCode: "11111123"), "Rule 84.7");
    XCTAssert(checkAccount("2599100003", bankCode: "11111123"), "Rule 84.8");
    XCTAssert(checkAccount("3199204090", bankCode: "11111123"), "Rule 84.9");
    XCTAssertFalse(checkAccount("0099345678", bankCode: "11111123"), "Rule 84.10"); // must fail
    XCTAssertFalse(checkAccount("0099100110", bankCode: "11111123"), "Rule 84.11"); // must fail
    XCTAssertFalse(checkAccount("0199100040", bankCode: "11111123"), "Rule 84.12"); // must fail

    // 87
    XCTAssertFalse(checkAccount("0", bankCode: "60090800"), "Rule 84.0");

    XCTAssert(checkAccount("0000000406", bankCode: "60090800"), "Rule 84.1");
    XCTAssert(checkAccount("0000051768", bankCode: "60090800"), "Rule 84.2");
    XCTAssert(checkAccount("0010701590", bankCode: "60090800"), "Rule 84.3");
    XCTAssert(checkAccount("0010720185", bankCode: "60090800"), "Rule 84.4");

    XCTAssert(checkAccount("0000100005", bankCode: "60090800"), "Rule 84.5");
    XCTAssert(checkAccount("0000393814", bankCode: "60090800"), "Rule 84.6");
    XCTAssert(checkAccount("0000950360", bankCode: "60090800"), "Rule 84.7");
    XCTAssert(checkAccount("3199500501", bankCode: "60090800"), "Rule 84.8");

    // Special cases (like in rule 51)
    XCTAssert(checkAccount("0199100002", bankCode: "60090800"), "Rule 84.9");
    XCTAssert(checkAccount("0099100010", bankCode: "60090800"), "Rule 84.10");
    XCTAssert(checkAccount("2599100002", bankCode: "60090800"), "Rule 84.11");
    XCTAssertFalse(checkAccount("0099345678", bankCode: "60090800"), "Rule 84.12"); // must fail
    XCTAssert(checkAccount("0199100004", bankCode: "60090800"), "Rule 84.13");
    XCTAssert(checkAccount("2599100003", bankCode: "60090800"), "Rule 84.14");
    XCTAssert(checkAccount("3199204090", bankCode: "60090800"), "Rule 84.15");
    XCTAssertFalse(checkAccount("0099345678", bankCode: "60090800"), "Rule 84.16"); // must fail
    XCTAssertFalse(checkAccount("0099100110", bankCode: "60090800"), "Rule 84.17"); // must fail
    XCTAssertFalse(checkAccount("0199100040", bankCode: "60090800"), "Rule 84.18"); // must fail

    // 88
    XCTAssert(checkAccount("0", bankCode: "70090100"), "Rule 88.0");
    XCTAssert(checkAccount("2525259", bankCode: "70090100"), "Rule 88.1");
    XCTAssert(checkAccount("1000500", bankCode: "70090100"), "Rule 88.2");
    XCTAssert(checkAccount("90013000", bankCode: "70090100"), "Rule 88.3");
    XCTAssert(checkAccount("92525253", bankCode: "70090100"), "Rule 88.4");
    XCTAssert(checkAccount("99913003", bankCode: "70090100"), "Rule 88.5");

    // 89
    XCTAssert(checkAccount("0", bankCode: "11111124"), "Rule 89.0");
    XCTAssert(checkAccount("1098506", bankCode: "11111124"), "Rule 89.1");
    XCTAssert(checkAccount("32028008", bankCode: "11111124"), "Rule 89.2");
    XCTAssert(checkAccount("218433000", bankCode: "11111124"), "Rule 89.3");

    // 90
    XCTAssert(checkAccount("0", bankCode: "55090500"), "Rule 90.0");
    XCTAssert(checkAccount("0001975641", bankCode: "55090500"), "Rule 90.1"); // method A
    XCTAssert(checkAccount("0001988654", bankCode: "55090500"), "Rule 90.2");
    XCTAssertFalse(checkAccount("0001924592", bankCode: "55090500"), "Rule 90.3"); // must fail
    XCTAssert(checkAccount("0001863530", bankCode: "55090500"), "Rule 90.4"); // method B
    XCTAssert(checkAccount("0001784451", bankCode: "55090500"), "Rule 90.5");
    XCTAssertFalse(checkAccount("0000901568", bankCode: "55090500"), "Rule 90.6"); // must fail
    XCTAssert(checkAccount("0000654321", bankCode: "55090500"), "Rule 90.7"); // method C
    XCTAssert(checkAccount("0000824491", bankCode: "55090500"), "Rule 90.8");
    XCTAssertFalse(checkAccount("0000820487", bankCode: "55090500"), "Rule 90.9"); // must fail
    XCTAssert(checkAccount("0000677747", bankCode: "55090500"), "Rule 90.10"); // method D
    XCTAssert(checkAccount("0000840507", bankCode: "55090500"), "Rule 90.11");
    XCTAssertFalse(checkAccount("0000726393", bankCode: "55090500"), "Rule 90.12"); // must fail
    XCTAssert(checkAccount("0000996663", bankCode: "55090500"), "Rule 90.13"); // method E
    XCTAssert(checkAccount("0000666034", bankCode: "55090500"), "Rule 90.14");
    XCTAssertFalse(checkAccount("0000924591", bankCode: "55090500"), "Rule 90.15"); // must fail
    XCTAssert(checkAccount("0004923250", bankCode: "55090500"), "Rule 90.16"); // method G
    XCTAssert(checkAccount("0003865960", bankCode: "55090500"), "Rule 90.17");
    XCTAssertFalse(checkAccount("0003865964", bankCode: "55090500"), "Rule 90.18"); // must fail
    XCTAssert(checkAccount("0099100002", bankCode: "55090500"), "Rule 90.19"); // method F
    XCTAssertFalse(checkAccount("0099100007", bankCode: "55090500"), "Rule 90.20"); // must fail

    // 91
    XCTAssert(checkAccount("0", bankCode: "57090900"), "Rule 91.0");

    XCTAssert(checkAccount("2974118000", bankCode: "57090900"), "Rule 91.1");
    XCTAssert(checkAccount("5281741000", bankCode: "57090900"), "Rule 91.2");
    XCTAssert(checkAccount("9952810000", bankCode: "57090900"), "Rule 91.3");
    XCTAssertFalse(checkAccount("8840017000", bankCode: "57090900"), "Rule 91.4"); // must fail
    XCTAssertFalse(checkAccount("8840023000", bankCode: "57090900"), "Rule 91.5"); // must fail
    XCTAssertFalse(checkAccount("8840041000", bankCode: "57090900"), "Rule 91.6"); // must fail

    XCTAssert(checkAccount("2974117000", bankCode: "57090900"), "Rule 91.7");
    XCTAssert(checkAccount("5281770000", bankCode: "57090900"), "Rule 91.8");
    XCTAssert(checkAccount("9952812000", bankCode: "57090900"), "Rule 91.9");
    XCTAssertFalse(checkAccount("8840014000", bankCode: "57090900"), "Rule 91.10"); // must fail
    XCTAssertFalse(checkAccount("8840026000", bankCode: "57090900"), "Rule 91.11"); // must fail

    XCTAssert(checkAccount("8840019000", bankCode: "57090900"), "Rule 91.13");
    XCTAssert(checkAccount("8840050000", bankCode: "57090900"), "Rule 91.14");
    XCTAssert(checkAccount("8840087000", bankCode: "57090900"), "Rule 91.15");
    XCTAssert(checkAccount("8840045000", bankCode: "57090900"), "Rule 91.16");
    XCTAssertFalse(checkAccount("8840011000", bankCode: "57090900"), "Rule 91.17"); // must fail
    XCTAssertFalse(checkAccount("8840025000", bankCode: "57090900"), "Rule 91.18"); // must fail
    XCTAssertFalse(checkAccount("8840062000", bankCode: "57090900"), "Rule 91.19"); // must fail

    XCTAssert(checkAccount("8840012000", bankCode: "57090900"), "Rule 91.20");
    XCTAssert(checkAccount("8840055000", bankCode: "57090900"), "Rule 91.21");
    XCTAssert(checkAccount("8840080000", bankCode: "57090900"), "Rule 91.22");
    XCTAssertFalse(checkAccount("8840010000", bankCode: "57090900"), "Rule 91.23"); // must fail
    XCTAssertFalse(checkAccount("8840057000", bankCode: "57090900"), "Rule 91.24"); // must fail

    // 92 - not used and no test case yet

    // 93
    XCTAssert(checkAccount("0", bankCode: "11111125"), "Rule 93.0");
    XCTAssert(checkAccount("6714790000", bankCode: "11111125"), "Rule 93.1");
    XCTAssert(checkAccount("0000671479", bankCode: "11111125"), "Rule 93.2");
    XCTAssert(checkAccount("1277830000", bankCode: "11111125"), "Rule 93.3");
    XCTAssert(checkAccount("0000127783", bankCode: "11111125"), "Rule 93.4");
    XCTAssert(checkAccount("1277910000", bankCode: "11111125"), "Rule 93.5");
    XCTAssert(checkAccount("0000127791", bankCode: "11111125"), "Rule 93.6");
    XCTAssert(checkAccount("3067540000", bankCode: "11111125"), "Rule 93.7");
    XCTAssert(checkAccount("0000306754", bankCode: "11111125"), "Rule 93.8");

    // 94
    XCTAssert(checkAccount("0", bankCode: "10120100"), "Rule 94.0");
    XCTAssert(checkAccount("6782533003", bankCode: "10120100"), "Rule 94.1");

    // 95
    XCTAssert(checkAccount("0", bankCode: "70020270"), "Rule 95.0");
    XCTAssert(checkAccount("0068007003", bankCode: "70020270"), "Rule 95.1");
    XCTAssert(checkAccount("0847321750", bankCode: "70020270"), "Rule 95.2");
    XCTAssert(checkAccount("6450060494", bankCode: "70020270"), "Rule 95.3");
    XCTAssert(checkAccount("6454000003", bankCode: "70020270"), "Rule 95.4");
    XCTAssert(checkAccount("0000000001", bankCode: "70020270"), "Rule 95.5");
    XCTAssert(checkAccount("0009000000", bankCode: "70020270"), "Rule 95.6");
    XCTAssert(checkAccount("0396000000", bankCode: "70020270"), "Rule 95.7");
    XCTAssert(checkAccount("0700000000", bankCode: "70020270"), "Rule 95.8");
    XCTAssert(checkAccount("0910000000", bankCode: "70020270"), "Rule 95.9");

    // 96
    XCTAssert(checkAccount("0", bankCode: "50050201"), "Rule 96.0");
    XCTAssert(checkAccount("0000254100", bankCode: "50050201"), "Rule 96.1");
    XCTAssert(checkAccount("9421000009", bankCode: "50050201"), "Rule 96.2");
    XCTAssert(checkAccount("0000000208", bankCode: "50050201"), "Rule 96.3");
    XCTAssert(checkAccount("0101115152", bankCode: "50050201"), "Rule 96.4");
    XCTAssert(checkAccount("0301204301", bankCode: "50050201"), "Rule 96.5");
    XCTAssert(checkAccount("0001300000", bankCode: "50050201"), "Rule 96.6");

    // 97
    XCTAssert(checkAccount("0", bankCode: "11111126"), "Rule 97.0");
    XCTAssert(checkAccount("2 4 0 1 0 0 1 9", bankCode: "11111126"), "Rule 97.1");

    // 98
    XCTAssert(checkAccount("0", bankCode: "74290100"), "Rule 98.0");
    XCTAssert(checkAccount("9619439213", bankCode: "74290100"), "Rule 98.1");
    XCTAssert(checkAccount("3009800016", bankCode: "74290100"), "Rule 98.2");
    XCTAssert(checkAccount("9619509976", bankCode: "74290100"), "Rule 98.3");
    XCTAssert(checkAccount("9619319999", bankCode: "74290100"), "Rule 98.4");
    XCTAssert(checkAccount("9619319999", bankCode: "74290100"), "Rule 98.5");
    XCTAssert(checkAccount("6719430018", bankCode: "74290100"), "Rule 98.6");

    // 99
    XCTAssert(checkAccount("0", bankCode: "74320073"), "Rule 99.0");
    XCTAssert(checkAccount("0068007003", bankCode: "74320073"), "Rule 99.1");
    XCTAssert(checkAccount("0847321750", bankCode: "74320073"), "Rule 99.2");
    XCTAssert(checkAccount("0396000000", bankCode: "74320073"), "Rule 99.3");

    // A0
    XCTAssert(checkAccount("0", bankCode: "11111127"), "Rule A0.0");
    XCTAssert(checkAccount("521003287", bankCode: "11111127"), "Rule A0.1");
    XCTAssert(checkAccount("54500", bankCode: "11111127"), "Rule A0.2");
    XCTAssert(checkAccount("3287", bankCode: "11111127"), "Rule A0.3");
    XCTAssert(checkAccount("18761", bankCode: "11111127"), "Rule A0.4");
    XCTAssert(checkAccount("28290", bankCode: "11111127"), "Rule A0.5");
    XCTAssertFalse(checkAccount("42", bankCode: "11111127"), "Rule A0.6"); // Must fail
    XCTAssert(checkAccount("142", bankCode: "11111127"), "Rule A0.6");

    // A1
    XCTAssertFalse(checkAccount("0", bankCode: "73362500"), "Rule A1.0");
    XCTAssert(checkAccount("0010030005", bankCode: "73362500"), "Rule A1.1");
    XCTAssert(checkAccount("0010030997", bankCode: "73362500"), "Rule A1.2");
    XCTAssert(checkAccount("1010030054", bankCode: "73362500"), "Rule A1.3");
    XCTAssertFalse(checkAccount("0110030005", bankCode: "73362500"), "Rule A1.4"); // must fail
    XCTAssertFalse(checkAccount("0010030998", bankCode: "73362500"), "Rule A1.5"); // must fail
    XCTAssertFalse(checkAccount("0000030005", bankCode: "73362500"), "Rule A1.6"); // must fail

    // A2
    XCTAssert(checkAccount("0", bankCode: "21051275"), "Rule A2.0");
    XCTAssert(checkAccount("3456789019", bankCode: "21051275"), "Rule A2.1");
    XCTAssert(checkAccount("5678901231", bankCode: "21051275"), "Rule A2.2");
    XCTAssert(checkAccount("6789012348", bankCode: "21051275"), "Rule A2.3");
    XCTAssert(checkAccount("3456789012", bankCode: "21051275"), "Rule A2.4");
    XCTAssertFalse(checkAccount("1234567890", bankCode: "21051275"), "Rule A2.5"); // must fail
    XCTAssertFalse(checkAccount("0123456789", bankCode: "21051275"), "Rule A2.6"); // must fail

    // A3
    XCTAssert(checkAccount("0", bankCode: "25050180"), "Rule A3.0");
    XCTAssert(checkAccount("1234567897", bankCode: "25050180"), "Rule A3.1");
    XCTAssert(checkAccount("0123456782", bankCode: "25050180"), "Rule A3.2");
    XCTAssertFalse(checkAccount("6543217890", bankCode: "25050180"), "Rule A3.5"); // must fail
    XCTAssertFalse(checkAccount("0543216789", bankCode: "25050180"), "Rule A3.6"); // must fail
    XCTAssert(checkAccount("9876543210", bankCode: "25050180"), "Rule A3.7");
    XCTAssert(checkAccount("1234567890", bankCode: "25050180"), "Rule A3.8");
    XCTAssert(checkAccount("0123456789", bankCode: "25050180"), "Rule A3.9");
    XCTAssertFalse(checkAccount("6543217890", bankCode: "25050180"), "Rule A3.10"); // must fail
    XCTAssertFalse(checkAccount("0543216789", bankCode: "25050180"), "Rule A3.11"); // must fail

    // A4
    XCTAssert(checkAccount("0", bankCode: "25090608"), "Rule A4.0");

    XCTAssert(checkAccount("0004711173", bankCode: "25090608"), "Rule A4.1");
    XCTAssert(checkAccount("0007093330", bankCode: "25090608"), "Rule A4.2");
    XCTAssertFalse(checkAccount("8623420004,", bankCode: "25090608"), "Rule A4.3"); // must fail

    XCTAssert(checkAccount("0004711172", bankCode: "25090608"), "Rule A4.4");
    XCTAssert(checkAccount("0007093335", bankCode: "25090608"), "Rule A4.5");
    XCTAssertFalse(checkAccount("8623420000,", bankCode: "25090608"), "Rule A4.6"); // must fail

    XCTAssert(checkAccount("1199503010", bankCode: "25090608"), "Rule A4.7");
    XCTAssert(checkAccount("8499421235", bankCode: "25090608"), "Rule A4.8");

    XCTAssert(checkAccount("6099702031", bankCode: "25090608"), "Rule A4.9");
    XCTAssert(checkAccount("0000862342", bankCode: "25090608"), "Rule A4.10");
    XCTAssert(checkAccount("8997710000", bankCode: "25090608"), "Rule A4.11");
    XCTAssert(checkAccount("0664040000", bankCode: "25090608"), "Rule A4.12");
    XCTAssert(checkAccount("0000905844", bankCode: "25090608"), "Rule A4.13");
    XCTAssert(checkAccount("5030101099", bankCode: "25090608"), "Rule A4.14");
    XCTAssert(checkAccount("0001123458", bankCode: "25090608"), "Rule A4.15");
    XCTAssert(checkAccount("1299503117", bankCode: "25090608"), "Rule A4.16");
    XCTAssertFalse(checkAccount("0000399443", bankCode: "25090608"), "Rule A4.17"); // must fail
    XCTAssertFalse(checkAccount("0000553313", bankCode: "25090608"), "Rule A4.18"); // must fail

    // A5
    XCTAssert(checkAccount("0", bankCode: "76450000"), "Rule A5.0");

    XCTAssert(checkAccount("9941510001", bankCode: "76450000"), "Rule A5.1");
    XCTAssert(checkAccount("9961230019", bankCode: "76450000"), "Rule A5.2");
    XCTAssert(checkAccount("9380027210", bankCode: "76450000"), "Rule A5.3");
    XCTAssert(checkAccount("9932290910", bankCode: "76450000"), "Rule A5.4");
    XCTAssertFalse(checkAccount("9941510002,", bankCode: "76450000"), "Rule A5.5"); // must fail
    XCTAssertFalse(checkAccount("9961230020,", bankCode: "76450000"), "Rule A5.6"); // must fail

    XCTAssert(checkAccount("0000251437", bankCode: "76450000"), "Rule A5.7");
    XCTAssert(checkAccount("0007948344", bankCode: "76450000"), "Rule A5.8");
    XCTAssert(checkAccount("0000159590", bankCode: "76450000"), "Rule A5.9");
    XCTAssert(checkAccount("0000051640", bankCode: "76450000"), "Rule A5.10");
    XCTAssertFalse(checkAccount("0000251438", bankCode: "76450000"), "Rule A5.11"); // must fail
    XCTAssertFalse(checkAccount("0007948345", bankCode: "76450000"), "Rule A5.12"); // must fail

    // A6
    XCTAssert(checkAccount("0", bankCode: "11111128"), "Rule A6.0");

    XCTAssert(checkAccount("800048548", bankCode: "11111128"), "Rule A6.1");
    XCTAssert(checkAccount("0855000014", bankCode: "11111128"), "Rule A6.2");
    XCTAssertFalse(checkAccount("860000817,", bankCode: "11111128"), "Rule A6.3"); // must fail
    XCTAssertFalse(checkAccount("810033652,", bankCode: "11111128"), "Rule A6.4"); // must fail

    XCTAssert(checkAccount("17", bankCode: "11111128"), "Rule A6.5");
    XCTAssert(checkAccount("55300030", bankCode: "11111128"), "Rule A6.6");
    XCTAssert(checkAccount("150178033", bankCode: "11111128"), "Rule A6.7");
    XCTAssert(checkAccount("600003555", bankCode: "11111128"), "Rule A6.8");
    XCTAssert(checkAccount("900291823", bankCode: "11111128"), "Rule A6.9");
    XCTAssertFalse(checkAccount("305888", bankCode: "11111128"), "Rule A6.10"); // must fail
    XCTAssertFalse(checkAccount("200071280", bankCode: "11111128"), "Rule A6.11"); // must fail

    // A7
    XCTAssert(checkAccount("0", bankCode: "11111129"), "Rule A7.0");

    XCTAssert(checkAccount("19010008", bankCode: "11111129"), "Rule A7.1");
    XCTAssert(checkAccount("19010438", bankCode: "11111129"), "Rule A7.2");
    XCTAssertFalse(checkAccount("209010892,", bankCode: "11111129"), "Rule A7.3"); // must fail
    XCTAssertFalse(checkAccount("209010893,", bankCode: "11111129"), "Rule A7.4"); // must fail

    XCTAssert(checkAccount("19010660", bankCode: "11111129"), "Rule A7.5");
    XCTAssert(checkAccount("19010876", bankCode: "11111129"), "Rule A7.6");
    XCTAssert(checkAccount("209010892", bankCode: "11111129"), "Rule A7.7");
    XCTAssertFalse(checkAccount("209010893", bankCode: "11111129"), "Rule A7.8"); // must fail

    // A8
    XCTAssert(checkAccount("0", bankCode: "11111130"), "Rule A8.0");

    XCTAssert(checkAccount("7436661", bankCode: "11111130"), "Rule A8.1");
    XCTAssert(checkAccount("7436670", bankCode: "11111130"), "Rule A8.2");
    XCTAssert(checkAccount("1359100", bankCode: "11111130"), "Rule A8.3");

    XCTAssert(checkAccount("7436660", bankCode: "11111130"), "Rule A8.6");
    XCTAssert(checkAccount("7436678", bankCode: "11111130"), "Rule A8.7");
    XCTAssert(checkAccount("0003503398", bankCode: "11111130"), "Rule A8.8");
    XCTAssert(checkAccount("0001340967", bankCode: "11111130"), "Rule A8.9");
    XCTAssertFalse(checkAccount("7436666", bankCode: "11111130"), "Rule A8.10"); // must fail
    XCTAssertFalse(checkAccount("7436677", bankCode: "11111130"), "Rule A8.11"); // must fail
    XCTAssertFalse(checkAccount("0003503391", bankCode: "11111130"), "Rule A8.12"); // must fail
    XCTAssertFalse(checkAccount("0001340966", bankCode: "11111130"), "Rule A8.13"); // must fail

    // Special cases (like in rule 51)
    XCTAssert(checkAccount("0199100002", bankCode: "11111130"), "Rule A8.14");
    XCTAssert(checkAccount("0099100010", bankCode: "11111130"), "Rule A8.15");
    XCTAssert(checkAccount("2599100002", bankCode: "11111130"), "Rule A8.16");
    XCTAssertFalse(checkAccount("0099345678", bankCode: "11111130"), "Rule A8.17"); // must fail
    XCTAssert(checkAccount("0199100004", bankCode: "11111130"), "Rule A8.18");
    XCTAssert(checkAccount("2599100003", bankCode: "11111130"), "Rule A8.19");
    XCTAssert(checkAccount("3199204090", bankCode: "11111130"), "Rule A8.20");
    XCTAssertFalse(checkAccount("0099345678", bankCode: "11111130"), "Rule A8.21"); // must fail
    XCTAssertFalse(checkAccount("0099100110", bankCode: "11111130"), "Rule A8.22"); // must fail
    XCTAssertFalse(checkAccount("0199100040", bankCode: "11111130"), "Rule A8.23"); // must fail

    // A9
    XCTAssert(checkAccount("0", bankCode: "11111131"), "Rule A9.0");

    XCTAssert(checkAccount("5043608", bankCode: "11111131"), "Rule A9.1");
    XCTAssert(checkAccount("86725", bankCode: "11111131"), "Rule A9.2");
    XCTAssertFalse(checkAccount("86724,", bankCode: "11111131"), "Rule A9.3"); // must fail

    XCTAssert(checkAccount("504360", bankCode: "11111131"), "Rule A9.4");
    XCTAssert(checkAccount("822035", bankCode: "11111131"), "Rule A9.5");
    XCTAssert(checkAccount("32577083", bankCode: "11111131"), "Rule A9.6");
    XCTAssertFalse(checkAccount("86724", bankCode: "11111131"), "Rule A9.7"); // must fail
    XCTAssertFalse(checkAccount("292497", bankCode: "11111131"), "Rule A9.8"); // must fail
    XCTAssertFalse(checkAccount("30767208", bankCode: "11111131"), "Rule A9.9"); // must fail

    // B0
    XCTAssert(checkAccount("0", bankCode: "11111131"), "Rule B0.0");

    XCTAssert(checkAccount("1197423162", bankCode: "11111132"), "Rule B0.1");
    XCTAssert(checkAccount("1000000606", bankCode: "11111132"), "Rule B0.2");
    XCTAssertFalse(checkAccount("600000606,", bankCode: "11111132"), "Rule B0.4"); // must fail

    XCTAssert(checkAccount("1000000406", bankCode: "11111132"), "Rule B0.6");
    XCTAssert(checkAccount("1035791538", bankCode: "11111132"), "Rule B0.7");
    XCTAssert(checkAccount("1126939724", bankCode: "11111132"), "Rule B0.8");
    XCTAssert(checkAccount("1197423460", bankCode: "11111132"), "Rule B0.9");
    XCTAssertFalse(checkAccount("1000000405", bankCode: "11111132"), "Rule B0.10"); // must fail
    XCTAssertFalse(checkAccount("1035791539", bankCode: "11111132"), "Rule B0.11"); // must fail

    // B1
    XCTAssert(checkAccount("0", bankCode: "25950001"), "Rule B1.0");

    XCTAssert(checkAccount("1434253150", bankCode: "25950001"), "Rule B1.1");
    XCTAssert(checkAccount("2746315471", bankCode: "25950001"), "Rule B1.2");
    XCTAssertFalse(checkAccount("7414398260,", bankCode: "25950001"), "Rule B1.3"); // must fail
    XCTAssertFalse(checkAccount("0123456789", bankCode: "25950001"), "Rule B1.5"); // must fail
    XCTAssertFalse(checkAccount("2345678901,", bankCode: "25950001"), "Rule B1.6"); // must fail
    XCTAssertFalse(checkAccount("5678901234,", bankCode: "25950001"), "Rule B1.7"); // must fail

    XCTAssert(checkAccount("7414398260", bankCode: "25950001"), "Rule B1.8");
    XCTAssert(checkAccount("8347251693", bankCode: "25950001"), "Rule B1.9");
    XCTAssertFalse(checkAccount("0123456789", bankCode: "25950001"), "Rule B1.10"); // must fail
    XCTAssertFalse(checkAccount("2345678901", bankCode: "25950001"), "Rule B1.11"); // must fail
    XCTAssertFalse(checkAccount("5678901234", bankCode: "25950001"), "Rule B1.12"); // must fail

    // B2
    XCTAssert(checkAccount("0", bankCode: "54051660"), "Rule B2.0");

    XCTAssert(checkAccount("0020012357", bankCode: "54051660"), "Rule B2.1");
    XCTAssert(checkAccount("0080012345", bankCode: "54051660"), "Rule B2.2");
    XCTAssert(checkAccount("0926801910", bankCode: "54051660"), "Rule B2.3");
    XCTAssert(checkAccount("1002345674", bankCode: "54051660"), "Rule B2.4");
    XCTAssertFalse(checkAccount("0020012399", bankCode: "54051660"), "Rule B2.5"); // must fail
    XCTAssertFalse(checkAccount("0080012347", bankCode: "54051660"), "Rule B2.6"); // must fail
    XCTAssertFalse(checkAccount("0080012370,", bankCode: "54051660"), "Rule B2.7"); // must fail
    XCTAssertFalse(checkAccount("0932100027,", bankCode: "54051660"), "Rule B2.8"); // must fail
    XCTAssertFalse(checkAccount("3310123454,", bankCode: "54051660"), "Rule B2.9"); // must fail

    XCTAssert(checkAccount("8000990054", bankCode: "54051660"), "Rule B2.10");
    XCTAssert(checkAccount("9000481805", bankCode: "54051660"), "Rule B2.11");
    XCTAssertFalse(checkAccount("8000990057", bankCode: "54051660"), "Rule B2.12"); // must fail
    XCTAssertFalse(checkAccount("8011000126", bankCode: "54051660"), "Rule B2.13"); // must fail
    XCTAssertFalse(checkAccount("9000481800", bankCode: "54051660"), "Rule B2.14"); // must fail
    XCTAssertFalse(checkAccount("9980480111", bankCode: "54051660"), "Rule B2.15"); // must fail

    // B3
    XCTAssert(checkAccount("0", bankCode: "66090800"), "Rule B3.0");

    XCTAssert(checkAccount("1000000060", bankCode: "66090800"), "Rule B3.1");
    XCTAssert(checkAccount("0000000140", bankCode: "66090800"), "Rule B3.2");
    XCTAssert(checkAccount("0000000019", bankCode: "66090800"), "Rule B3.3");
    XCTAssert(checkAccount("1002798417", bankCode: "66090800"), "Rule B3.4");
    XCTAssert(checkAccount("8409915001", bankCode: "66090800"), "Rule B3.5");
    XCTAssertFalse(checkAccount("0002799899", bankCode: "66090800"), "Rule B3.6"); // must fail
    XCTAssertFalse(checkAccount("1000000111", bankCode: "66090800"), "Rule B3.7"); // must fail

    XCTAssert(checkAccount("9635000101", bankCode: "66090800"), "Rule B3.8");
    XCTAssert(checkAccount("9730200100", bankCode: "66090800"), "Rule B3.9");
    XCTAssertFalse(checkAccount("9635100101", bankCode: "66090800"), "Rule B3.10"); // must fail
    XCTAssertFalse(checkAccount("9730300100", bankCode: "66090800"), "Rule B3.11"); // must fail

    // B4
    XCTAssert(checkAccount("0", bankCode: "11111133"), "Rule B4.0");

    XCTAssert(checkAccount("9941510001", bankCode: "11111133"), "Rule B4.1");
    XCTAssert(checkAccount("9961230019", bankCode: "11111133"), "Rule B4.2");
    XCTAssert(checkAccount("9380027210", bankCode: "11111133"), "Rule B4.3");
    XCTAssert(checkAccount("9932290910", bankCode: "11111133"), "Rule B4.4");
    XCTAssertFalse(checkAccount("9941510002", bankCode: "11111133"), "Rule B4.5"); // must fail
    XCTAssertFalse(checkAccount("9961230020", bankCode: "11111133"), "Rule B4.6"); // must fail

    XCTAssert(checkAccount("0000251437", bankCode: "11111133"), "Rule B4.7");
    XCTAssert(checkAccount("0007948344", bankCode: "11111133"), "Rule B4.8");
    XCTAssert(checkAccount("0000051640", bankCode: "11111133"), "Rule B4.9");
    XCTAssertFalse(checkAccount("0000251438", bankCode: "11111133"), "Rule B4.10"); // must fail
    XCTAssertFalse(checkAccount("0007948345", bankCode: "11111133"), "Rule B4.11"); // must fail
    XCTAssertFalse(checkAccount("0000159590", bankCode: "11111133"), "Rule B4.12"); // must fail

    // B5
    XCTAssert(checkAccount("0", bankCode: "37050299"), "Rule B5.0");

    XCTAssert(checkAccount("0159006955", bankCode: "37050299"), "Rule B5.1");
    XCTAssert(checkAccount("2000123451", bankCode: "37050299"), "Rule B5.2");
    XCTAssert(checkAccount("1151043216", bankCode: "37050299"), "Rule B5.3");
    XCTAssert(checkAccount("9000939033", bankCode: "37050299"), "Rule B5.4");
    XCTAssertFalse(checkAccount("7414398260", bankCode: "37050299"), "Rule B5.5"); // must fail
    XCTAssertFalse(checkAccount("8347251693", bankCode: "37050299"), "Rule B5.6"); // must fail
    XCTAssertFalse(checkAccount("2345678901", bankCode: "37050299"), "Rule B5.8"); // must fail
    XCTAssertFalse(checkAccount("5678901234", bankCode: "37050299"), "Rule B5.9"); // must fail
    XCTAssertFalse(checkAccount("9000293707", bankCode: "37050299"), "Rule B5.10"); // must fail

    XCTAssert(checkAccount("0123456782", bankCode: "37050299"), "Rule B5.11");
    XCTAssert(checkAccount("0130098767", bankCode: "37050299"), "Rule B5.12");
    XCTAssert(checkAccount("1045000252", bankCode: "37050299"), "Rule B5.13");
    XCTAssertFalse(checkAccount("0159004165", bankCode: "37050299"), "Rule B5.14"); // must fail
    XCTAssertFalse(checkAccount("0023456787", bankCode: "37050299"), "Rule B5.15"); // must fail
    XCTAssertFalse(checkAccount("0056789018", bankCode: "37050299"), "Rule B5.16"); // must fail
    XCTAssertFalse(checkAccount("3045000333", bankCode: "37050299"), "Rule B6.17"); // must fail

    // B6
    XCTAssert(checkAccount("0", bankCode: "80053762"), "Rule B6.0");

    XCTAssert(checkAccount("9110000000", bankCode: "80053762"), "Rule B6.1");
    XCTAssert(checkAccount("0269876545", bankCode: "80053762"), "Rule B6.2");
    XCTAssertFalse(checkAccount("9111000000", bankCode: "80053762"), "Rule B6.35"); // must fail
    XCTAssertFalse(checkAccount("0269456780", bankCode: "80053762"), "Rule B6.4"); // must fail

    XCTAssert(checkAccount("487310018", bankCode: "80053782"), "Rule B6.5");
    XCTAssertFalse(checkAccount("477310018", bankCode: "80053762"), "Rule B6.6"); // must fail

    // B7
    XCTAssert(checkAccount("0", bankCode: "50010700"), "Rule B7.0");

    XCTAssert(checkAccount("0700001529", bankCode: "50010700"), "Rule B7.1");
    XCTAssert(checkAccount("0730000019", bankCode: "50010700"), "Rule B7.2");
    XCTAssert(checkAccount("0001001008", bankCode: "50010700"), "Rule B7.3");
    XCTAssert(checkAccount("0001057887", bankCode: "50010700"), "Rule B7.4");
    XCTAssert(checkAccount("0001007222", bankCode: "50010700"), "Rule B7.5");
    XCTAssert(checkAccount("0810011825", bankCode: "50010700"), "Rule B7.6");
    XCTAssert(checkAccount("0800107653", bankCode: "50010700"), "Rule B7.7");
    XCTAssert(checkAccount("0005922372", bankCode: "50010700"), "Rule B7.8");
    XCTAssert(checkAccount("0006000000", bankCode: "50010700"), "Rule B7.9");
    XCTAssertFalse(checkAccount("0001057886", bankCode: "50010700"), "Rule B7.10"); // must fail
    XCTAssertFalse(checkAccount("0003815570", bankCode: "50010700"), "Rule B7.11"); // must fail
    XCTAssertFalse(checkAccount("0005620516", bankCode: "50010700"), "Rule B7.12"); // must fail
    XCTAssertFalse(checkAccount("0740912243", bankCode: "50010700"), "Rule B7.13"); // must fail
    XCTAssertFalse(checkAccount("0893524479", bankCode: "50010700"), "Rule B7.14"); // must fail

    // B8
    XCTAssert(checkAccount("0", bankCode: "10050000"), "Rule B8.0");

    XCTAssert(checkAccount("0734192657", bankCode: "10050000"), "Rule B8.1");
    XCTAssert(checkAccount("6932875274", bankCode: "10050000"), "Rule B8.2");
    XCTAssert(checkAccount("5011654366", bankCode: "10050000"), "Rule B8.3");
    XCTAssertFalse(checkAccount("0132572975", bankCode: "10050000"), "Rule B8.5"); // must fail
    XCTAssertFalse(checkAccount("9000412340", bankCode: "10050000"), "Rule B8.9"); // must fail
    XCTAssertFalse(checkAccount("9310305011", bankCode: "10050000"), "Rule B8.10"); // must fail
    XCTAssert(checkAccount("3145863029", bankCode: "10050000"), "Rule B8.11");
    XCTAssert(checkAccount("2938692523", bankCode: "10050000"), "Rule B8.12");
    XCTAssert(checkAccount("5432198760", bankCode: "10050000"), "Rule B8.13");
    XCTAssert(checkAccount("9070873333", bankCode: "10050000"), "Rule B8.14");
    XCTAssertFalse(checkAccount("0132572975", bankCode: "10050000"), "Rule B8.15"); // must fail
    XCTAssertFalse(checkAccount("9000412340", bankCode: "10050000"), "Rule B8.16"); // must fail
    XCTAssertFalse(checkAccount("9310305011", bankCode: "10050000"), "Rule B8.17"); // must fail

    // B9
    XCTAssertFalse(checkAccount("0", bankCode: "11111134"), "Rule B9.0");

    XCTAssert(checkAccount("87920187", bankCode: "11111134"), "Rule B9.1");
    XCTAssert(checkAccount("41203755", bankCode: "11111134"), "Rule B9.2");
    XCTAssert(checkAccount("81069577", bankCode: "11111134"), "Rule B9.3");
    XCTAssert(checkAccount("61287958", bankCode: "11111134"), "Rule B9.4");
    XCTAssert(checkAccount("58467232", bankCode: "11111134"), "Rule B9.5");
    XCTAssertFalse(checkAccount("43025432", bankCode: "11111134"), "Rule B9.7"); // must fail
    XCTAssertFalse(checkAccount("61256523", bankCode: "11111134"), "Rule B9.9"); // must fail
    XCTAssertFalse(checkAccount("54352684", bankCode: "11111134"), "Rule B9.10"); // must fail
    XCTAssert(checkAccount("7125633", bankCode: "11111134"), "Rule B9.11");
    XCTAssert(checkAccount("1253657", bankCode: "11111134"), "Rule B9.12");
    XCTAssert(checkAccount("4353631", bankCode: "11111134"), "Rule B9.13");
    XCTAssertFalse(checkAccount("2356412", bankCode: "11111134"), "Rule B9.14"); // must fail
    XCTAssertFalse(checkAccount("5435886", bankCode: "11111134"), "Rule B9.15"); // must fail
    XCTAssertFalse(checkAccount("9435414", bankCode: "11111134"), "Rule B9.16"); // must fail

    // C0
    XCTAssert(checkAccount("0", bankCode: "13051042"), "Rule C0.0");

    // The documentation includes some test cases that use an old bank code which is already in our list for method 52.
    // However these test cases are made to use method 52 anyway. So we are fine with that.
    XCTAssert(checkAccount("43001500", bankCode: "130 511 72"), "Rule C0.1");
    XCTAssert(checkAccount("48726458", bankCode: "130 511 72"), "Rule C0.2");
    XCTAssertFalse(checkAccount("82335729", bankCode: "130 511 72"), "Rule C0.3"); // must fail
    XCTAssertFalse(checkAccount("29837521", bankCode: "130 511 72"), "Rule C0.4"); // must fail
    XCTAssert(checkAccount("0082335729", bankCode: "13051042"), "Rule C0.5");
    XCTAssert(checkAccount("0734192657", bankCode: "13051042"), "Rule C0.6");
    XCTAssert(checkAccount("6932875274", bankCode: "13051042"), "Rule C0.7");
    XCTAssertFalse(checkAccount("0132572975", bankCode: "13051042"), "Rule C0.8"); // must fail
    XCTAssertFalse(checkAccount("3038752371", bankCode: "13051042"), "Rule C0.9"); // must fail

    // C1
    XCTAssertFalse(checkAccount("0", bankCode: "50010517"), "Rule C1.0");

    XCTAssert(checkAccount("0446786040", bankCode: "50010517"), "Rule C1.1");
    XCTAssert(checkAccount("0478046940", bankCode: "50010517"), "Rule C1.2");
    XCTAssert(checkAccount("0701625830", bankCode: "50010517"), "Rule C1.3");
    XCTAssert(checkAccount("0701625840", bankCode: "50010517"), "Rule C1.4");
    XCTAssert(checkAccount("0882095630", bankCode: "50010517"), "Rule C1.5");
    XCTAssertFalse(checkAccount("0478046340", bankCode: "50010517"), "Rule C1.7"); // must fail
    XCTAssertFalse(checkAccount("0701625730", bankCode: "50010517"), "Rule C1.8"); // must fail
    XCTAssertFalse(checkAccount("0701625440", bankCode: "50010517"), "Rule C1.9"); // must fail
    XCTAssertFalse(checkAccount("0882095130", bankCode: "50010517"), "Rule C1.10"); // must fail

    XCTAssert(checkAccount("5432112349", bankCode: "50010517"), "Rule C1.11");
    XCTAssert(checkAccount("5543223456", bankCode: "50010517"), "Rule C1.12");
    XCTAssert(checkAccount("5654334563", bankCode: "50010517"), "Rule C1.13");
    XCTAssert(checkAccount("5765445670", bankCode: "50010517"), "Rule C1.14");
    XCTAssert(checkAccount("5876556788", bankCode: "50010517"), "Rule C1.15");
    XCTAssertFalse(checkAccount("5432112341", bankCode: "50010517"), "Rule C1.16"); // must fail
    XCTAssertFalse(checkAccount("5543223458", bankCode: "50010517"), "Rule C1.17"); // must fail
    XCTAssertFalse(checkAccount("5654334565", bankCode: "50010517"), "Rule C1.18"); // must fail
    XCTAssertFalse(checkAccount("5765445672", bankCode: "50010517"), "Rule C1.19"); // must fail
    XCTAssertFalse(checkAccount("5876556780", bankCode: "50010517"), "Rule C1.20"); // must fail

    // C2
    XCTAssert(checkAccount("0", bankCode: "21450000"), "Rule C2.0");

    XCTAssert(checkAccount("2394871426", bankCode: "21450000"), "Rule C2.1");
    XCTAssert(checkAccount("4218461950", bankCode: "21450000"), "Rule C2.2");
    XCTAssert(checkAccount("7352569148", bankCode: "21450000"), "Rule C2.3");
    XCTAssertFalse(checkAccount("0328705282", bankCode: "21450000"), "Rule C2.6"); // must fail
    XCTAssertFalse(checkAccount("9024675131", bankCode: "21450000"), "Rule C2.7"); // must fail

    XCTAssert(checkAccount("5127485166", bankCode: "21450000"), "Rule C2.8");
    XCTAssert(checkAccount("8738142564", bankCode: "21450000"), "Rule C2.9");
    XCTAssertFalse(checkAccount("0328705282", bankCode: "21450000"), "Rule C2.10"); // must fail
    XCTAssertFalse(checkAccount("9024675131", bankCode: "21450000"), "Rule C2.11"); // must fail

    // C3
    XCTAssert(checkAccount("0", bankCode: "25060180"), "Rule C3.0");

    XCTAssert(checkAccount("9294182", bankCode: "25060180"), "Rule C3.1");
    XCTAssert(checkAccount("4431276", bankCode: "25060180"), "Rule C3.2");
    XCTAssert(checkAccount("19919", bankCode: "25060180"), "Rule C3.3");
    XCTAssertFalse(checkAccount("17002", bankCode: "25060180"), "Rule C3.4"); // must fail
    XCTAssertFalse(checkAccount("123451", bankCode: "25060180"), "Rule C3.5"); // must fail
    XCTAssertFalse(checkAccount("122448", bankCode: "25060180"), "Rule C3.6"); // must fail

    XCTAssert(checkAccount("9000420530", bankCode: "25060180"), "Rule C3.7");
    XCTAssert(checkAccount("9000010006", bankCode: "25060180"), "Rule C3.8");
    XCTAssert(checkAccount("9000577650", bankCode: "25060180"), "Rule C3.9");
    XCTAssertFalse(checkAccount("9000734028", bankCode: "25060180"), "Rule C3.10"); // must fail
    XCTAssertFalse(checkAccount("9000733227", bankCode: "25060180"), "Rule C3.11"); // must fail
    XCTAssertFalse(checkAccount("9000731120", bankCode: "25060180"), "Rule C3.12"); // must fail

    // C4
    XCTAssert(checkAccount("0", bankCode: "29030400"), "Rule C4.0");

    XCTAssert(checkAccount("0000000019", bankCode: "29030400"), "Rule C4.1");
    XCTAssert(checkAccount("0000292932", bankCode: "29030400"), "Rule C4.2");
    XCTAssert(checkAccount("0000094455", bankCode: "29030400"), "Rule C4.3");
    XCTAssertFalse(checkAccount("0000000017", bankCode: "29030400"), "Rule C4.4"); // must fail
    XCTAssertFalse(checkAccount("0000292933", bankCode: "29030400"), "Rule C4.5"); // must fail
    XCTAssertFalse(checkAccount("0000094459", bankCode: "29030400"), "Rule C4.6"); // must fail

    XCTAssert(checkAccount("9000420530", bankCode: "29030400"), "Rule C4.7");
    XCTAssert(checkAccount("9000010006", bankCode: "29030400"), "Rule C4.8");
    XCTAssert(checkAccount("9000577650", bankCode: "29030400"), "Rule C4.9");
    XCTAssertFalse(checkAccount("9000726558", bankCode: "29030400"), "Rule C4.10"); // must fail
    XCTAssertFalse(checkAccount("9001733457", bankCode: "29030400"), "Rule C4.11"); // must fail
    XCTAssertFalse(checkAccount("9000732000", bankCode: "29030400"), "Rule C4.12"); // must fail

    // C5
    XCTAssertFalse(checkAccount("0", bankCode: "20050000"), "Rule C5.0");

    XCTAssert(checkAccount("0000301168", bankCode: "20050000"), "Rule C5.1");
    XCTAssert(checkAccount("0000302554", bankCode: "20050000"), "Rule C5.2");
    XCTAssertFalse(checkAccount("0000302589", bankCode: "20050000"), "Rule C5.3"); // must fail
    XCTAssertFalse(checkAccount("0000507336", bankCode: "20050000"), "Rule C5.4"); // must fail

    XCTAssert(checkAccount("0300020050", bankCode: "20050000"), "Rule C5.5");
    XCTAssert(checkAccount("0300566000", bankCode: "20050000"), "Rule C5.6");
    XCTAssertFalse(checkAccount("0302555000", bankCode: "20050000"), "Rule C5.7"); // must fail
    XCTAssertFalse(checkAccount("0302589000", bankCode: "20050000"), "Rule C5.8"); // must fail

    XCTAssert(checkAccount("1000061378", bankCode: "20050000"), "Rule C5.9");
    XCTAssert(checkAccount("1000061412", bankCode: "20050000"), "Rule C5.10");
    XCTAssert(checkAccount("4450164064", bankCode: "20050000"), "Rule C5.11");
    XCTAssert(checkAccount("4863476104", bankCode: "20050000"), "Rule C5.12");
    XCTAssert(checkAccount("5000000028", bankCode: "20050000"), "Rule C5.13");
    XCTAssert(checkAccount("5000000391", bankCode: "20050000"), "Rule C5.14");
    XCTAssert(checkAccount("6450008149", bankCode: "20050000"), "Rule C5.15");
    XCTAssert(checkAccount("6800001016", bankCode: "20050000"), "Rule C5.16");
    XCTAssert(checkAccount("9000100012", bankCode: "20050000"), "Rule C5.17");
    XCTAssert(checkAccount("9000210017", bankCode: "20050000"), "Rule C5.18");
    XCTAssertFalse(checkAccount("1000061457", bankCode: "20050000"), "Rule C5.19"); // must fail
    XCTAssertFalse(checkAccount("1000061498", bankCode: "20050000"), "Rule C5.20"); // must fail
    XCTAssertFalse(checkAccount("4864446015", bankCode: "20050000"), "Rule C5.21"); // must fail
    XCTAssertFalse(checkAccount("4865038012", bankCode: "20050000"), "Rule C5.22"); // must fail
    XCTAssertFalse(checkAccount("5000001028", bankCode: "20050000"), "Rule C5.23"); // must fail
    XCTAssertFalse(checkAccount("5000001075", bankCode: "20050000"), "Rule C5.24"); // must fail
    XCTAssertFalse(checkAccount("6450008150", bankCode: "20050000"), "Rule C5.25"); // must fail
    XCTAssertFalse(checkAccount("6542812818", bankCode: "20050000"), "Rule C5.26"); // must fail
    XCTAssertFalse(checkAccount("9000110012", bankCode: "20050000"), "Rule C5.27"); // must fail
    XCTAssertFalse(checkAccount("9000300310", bankCode: "20050000"), "Rule C5.28"); // must fail

    XCTAssert(checkAccount("3060188103", bankCode: "20050000"), "Rule C5.29");
    XCTAssert(checkAccount("3070402023", bankCode: "20050000"), "Rule C5.30");
    XCTAssertFalse(checkAccount("3081000783", bankCode: "20050000"), "Rule C5.31"); // must fail
    XCTAssertFalse(checkAccount("3081308871", bankCode: "20050000"), "Rule C5.32"); // must fail

    XCTAssert(checkAccount("0030000000", bankCode: "20050000"), "Rule C5.33");
    XCTAssert(checkAccount("7000000000", bankCode: "20050000"), "Rule C5.34");
    XCTAssert(checkAccount("8500000000", bankCode: "20050000"), "Rule C5.35");

    // C6
    XCTAssert(checkAccount("0", bankCode: "10050005"), "Rule C6.0");

    XCTAssert(checkAccount("0000065516", bankCode: "10050005"), "Rule C6.1");
    XCTAssert(checkAccount("0203178249", bankCode: "10050005"), "Rule C6.2");
    XCTAssert(checkAccount("1031405209", bankCode: "10050005"), "Rule C6.3");
    XCTAssert(checkAccount("1082012201", bankCode: "10050005"), "Rule C6.4");
    XCTAssert(checkAccount("2003455189", bankCode: "10050005"), "Rule C6.5");
    XCTAssert(checkAccount("2004001016", bankCode: "10050005"), "Rule C6.6");
    XCTAssert(checkAccount("3110150986", bankCode: "10050005"), "Rule C6.7");
    XCTAssert(checkAccount("3068459207", bankCode: "10050005"), "Rule C6.8");
    XCTAssert(checkAccount("5035105948", bankCode: "10050005"), "Rule C6.9");
    XCTAssert(checkAccount("5286102149", bankCode: "10050005"), "Rule C6.10");
    XCTAssert(checkAccount("4012660028", bankCode: "10050005"), "Rule C6.11");
    XCTAssert(checkAccount("4100235626", bankCode: "10050005"), "Rule C6.12");
    XCTAssert(checkAccount("6028426119", bankCode: "10050005"), "Rule C6.13");
    XCTAssert(checkAccount("6861001755", bankCode: "10050005"), "Rule C6.14");
    XCTAssert(checkAccount("7008199027", bankCode: "10050005"), "Rule C6.15");
    XCTAssert(checkAccount("7002000023", bankCode: "10050005"), "Rule C6.16");
    XCTAssert(checkAccount("8526080015", bankCode: "10050005"), "Rule C6.17");
    XCTAssert(checkAccount("8711072264", bankCode: "10050005"), "Rule C6.18");
    XCTAssert(checkAccount("9000430223", bankCode: "10050005"), "Rule C6.19");
    XCTAssert(checkAccount("9000781153", bankCode: "10050005"), "Rule C6.20");
    XCTAssertFalse(checkAccount("0525111212", bankCode: "10050005"), "Rule C6.21"); // must fail
    XCTAssertFalse(checkAccount("0091423614", bankCode: "10050005"), "Rule C6.22"); // must fail
    XCTAssertFalse(checkAccount("1082311275", bankCode: "10050005"), "Rule C6.23"); // must fail
    XCTAssertFalse(checkAccount("1000118821", bankCode: "10050005"), "Rule C6.24"); // must fail
    XCTAssertFalse(checkAccount("2004306518", bankCode: "10050005"), "Rule C6.25"); // must fail
    XCTAssertFalse(checkAccount("2016001206", bankCode: "10050005"), "Rule C6.26"); // must fail
    XCTAssertFalse(checkAccount("3462816371", bankCode: "10050005"), "Rule C6.27"); // must fail
    XCTAssertFalse(checkAccount("3622548632", bankCode: "10050005"), "Rule C6.28"); // must fail
    XCTAssertFalse(checkAccount("4232300158", bankCode: "10050005"), "Rule C6.29"); // must fail
    XCTAssertFalse(checkAccount("4000456126", bankCode: "10050005"), "Rule C6.30"); // must fail
    XCTAssertFalse(checkAccount("5002684526", bankCode: "10050005"), "Rule C6.31"); // must fail
    XCTAssertFalse(checkAccount("5564123850", bankCode: "10050005"), "Rule C6.32"); // must fail
    XCTAssertFalse(checkAccount("6295473774", bankCode: "10050005"), "Rule C6.33"); // must fail
    XCTAssertFalse(checkAccount("6640806317", bankCode: "10050005"), "Rule C6.34"); // must fail
    XCTAssertFalse(checkAccount("7000062022", bankCode: "10050005"), "Rule C6.35"); // must fail
    XCTAssertFalse(checkAccount("7006003027", bankCode: "10050005"), "Rule C6.36"); // must fail
    XCTAssertFalse(checkAccount("8348300002", bankCode: "10050005"), "Rule C6.37"); // must fail
    XCTAssertFalse(checkAccount("8654216984", bankCode: "10050005"), "Rule C6.38"); // must fail
    XCTAssertFalse(checkAccount("9000641509", bankCode: "10050005"), "Rule C6.39"); // must fail
    XCTAssertFalse(checkAccount("9000260986", bankCode: "10050005"), "Rule C6.40"); // must fail

    // C7
    XCTAssert(checkAccount("0", bankCode: "76026000"), "Rule C7.0");

    XCTAssert(checkAccount("3500022", bankCode: "76026000"), "Rule C7.1");
    XCTAssert(checkAccount("38150900", bankCode: "76026000"), "Rule C7.2");
    XCTAssert(checkAccount("600103660", bankCode: "76026000"), "Rule C7.3");
    XCTAssert(checkAccount("39101181", bankCode: "76026000"), "Rule C7.4");

    XCTAssert(checkAccount("94012341", bankCode: "76026000"), "Rule C7.7");
    XCTAssert(checkAccount("5073321010", bankCode: "76026000"), "Rule C7.8");
    XCTAssertFalse(checkAccount("1234517892", bankCode: "76026000"), "Rule C7.9"); // must fail
    XCTAssertFalse(checkAccount("987614325", bankCode: "76026000"), "Rule C7.10"); // must fail

    // C8
    XCTAssert(checkAccount("0", bankCode: "21750000"), "Rule C8.0");

    XCTAssert(checkAccount("3456789019", bankCode: "21750000"), "Rule C8.1");
    XCTAssert(checkAccount("5678901231", bankCode: "21750000"), "Rule C8.2");
    XCTAssertFalse(checkAccount("1234567890", bankCode: "21750000"), "Rule C8.5"); // must fail
    XCTAssertFalse(checkAccount("9012345678", bankCode: "21750000"), "Rule C8.6"); // must fail

    XCTAssert(checkAccount("3456789012", bankCode: "21750000"), "Rule C8.7");
    XCTAssert(checkAccount("0022007130", bankCode: "21750000"), "Rule C8.8");
    XCTAssertFalse(checkAccount("1234567890", bankCode: "21750000"), "Rule C8.10"); // must fail
    XCTAssertFalse(checkAccount("9012345678", bankCode: "21750000"), "Rule C8.11"); // must fail

    XCTAssert(checkAccount("0123456789", bankCode: "21750000"), "Rule C8.12");
    XCTAssert(checkAccount("0552071285", bankCode: "21750000"), "Rule C8.13");
    XCTAssertFalse(checkAccount("1234567890", bankCode: "21750000"), "Rule C8.14"); // must fail
    XCTAssertFalse(checkAccount("9012345678", bankCode: "21750000"), "Rule C8.15"); // must fail

    // C9
    XCTAssert(checkAccount("0", bankCode: "59252046"), "Rule C9.0");

    XCTAssert(checkAccount("3456789019", bankCode: "59252046"), "Rule C9.1");
    XCTAssert(checkAccount("5678901231", bankCode: "59252046"), "Rule C9.2");
    XCTAssertFalse(checkAccount("3456789012", bankCode: "59252046"), "Rule C9.3"); // must fail

    XCTAssert(checkAccount("0123456789", bankCode: "59252046"), "Rule C9.6");
    XCTAssertFalse(checkAccount("1234567890", bankCode: "59252046"), "Rule C9.7"); // must fail
    XCTAssertFalse(checkAccount("9012345678", bankCode: "59252046"), "Rule C9.8"); // must fail

    // D0
    XCTAssert(checkAccount("0", bankCode: "86055592"), "Rule D0.0");

    XCTAssert(checkAccount("6100272324", bankCode: "86055592"), "Rule D0.1");
    XCTAssert(checkAccount("6100273479", bankCode: "86055592"), "Rule D0.2");
    XCTAssert(checkAccount("5700000000", bankCode: "86055592"), "Rule D0.3");
    XCTAssertFalse(checkAccount("6100272885", bankCode: "86055592"), "Rule D0.4"); // must fail
    XCTAssertFalse(checkAccount("6100273377", bankCode: "86055592"), "Rule D0.5"); // must fail
    XCTAssertFalse(checkAccount("6100274012", bankCode: "86055592"), "Rule D0.6"); // must fail

    // D1
    XCTAssertFalse(checkAccount("0", bankCode: "10050006"), "Rule D1.0");

    XCTAssert(checkAccount("0082012203", bankCode: "10050006"), "Rule D1.1");
    XCTAssert(checkAccount("1452683581", bankCode: "10050006"), "Rule D1.2");
    XCTAssert(checkAccount("2129642505", bankCode: "10050006"), "Rule D1.3");
    XCTAssert(checkAccount("3002000027", bankCode: "10050006"), "Rule D1.4");
    XCTAssert(checkAccount("4230001407", bankCode: "10050006"), "Rule D1.5");
    XCTAssert(checkAccount("5000065514", bankCode: "10050006"), "Rule D1.6");
    XCTAssert(checkAccount("6001526215", bankCode: "10050006"), "Rule D1.7");
    XCTAssert(checkAccount("7126502149", bankCode: "10050006"), "Rule D1.8");
    XCTAssert(checkAccount("9000430223", bankCode: "10050006"), "Rule D1.9");
    XCTAssertFalse(checkAccount("0000260986", bankCode: "10050006"), "Rule D1.10"); // must fail
    XCTAssertFalse(checkAccount("1062813622", bankCode: "10050006"), "Rule D1.11"); // must fail
    XCTAssertFalse(checkAccount("2256412314", bankCode: "10050006"), "Rule D1.12"); // must fail
    XCTAssertFalse(checkAccount("3012084101", bankCode: "10050006"), "Rule D1.13"); // must fail
    XCTAssertFalse(checkAccount("4006003027", bankCode: "10050006"), "Rule D1.14"); // must fail
    XCTAssertFalse(checkAccount("5814500990", bankCode: "10050006"), "Rule D1.15"); // must fail
    XCTAssertFalse(checkAccount("6128462594", bankCode: "10050006"), "Rule D1.16"); // must fail
    XCTAssertFalse(checkAccount("7000062035", bankCode: "10050006"), "Rule D1.17"); // must fail
    XCTAssertFalse(checkAccount("8003306026", bankCode: "10050006"), "Rule D1.18"); // must fail
    XCTAssertFalse(checkAccount("9000641509", bankCode: "10050006"), "Rule D1.19"); // must fail

    // D2
    XCTAssert(checkAccount("0", bankCode: "70120500"), "Rule D2.0");

    XCTAssert(checkAccount("189912137", bankCode: "70120500"), "Rule D2.1");
    XCTAssert(checkAccount("235308215", bankCode: "70120500"), "Rule D2.2");
    XCTAssert(checkAccount("4455667784", bankCode: "70120500"), "Rule D2.3");
    XCTAssert(checkAccount("1234567897", bankCode: "70120500"), "Rule D2.4");
    XCTAssert(checkAccount("51181008", bankCode: "70120500"), "Rule D2.5");
    XCTAssert(checkAccount("71214205", bankCode: "70120500"), "Rule D2.6");
    XCTAssertFalse(checkAccount("6414241", bankCode: "70120500"), "Rule D2.7"); // must fail
    XCTAssertFalse(checkAccount("179751314", bankCode: "70120500"), "Rule D2.8"); // must fail

    // D3
    XCTAssert(checkAccount("0", bankCode: "59052020"), "Rule D3.0");

    XCTAssert(checkAccount("1600169591", bankCode: "59052020"), "Rule D3.1");
    XCTAssert(checkAccount("1600189151", bankCode: "59052020"), "Rule D3.2");
    XCTAssert(checkAccount("1800084079", bankCode: "59052020"), "Rule D3.3");
    XCTAssertFalse(checkAccount("1600166307", bankCode: "59052020"), "Rule D3.4"); // must fail

    XCTAssert(checkAccount("6019937007", bankCode: "59052020"), "Rule D3.7");
    XCTAssert(checkAccount("6021354007", bankCode: "59052020"), "Rule D3.8");
    XCTAssert(checkAccount("6030642006", bankCode: "59052020"), "Rule D3.9");
    XCTAssertFalse(checkAccount("6025017009", bankCode: "59052020"), "Rule D3.10"); // must fail
    XCTAssertFalse(checkAccount("6028267003", bankCode: "59052020"), "Rule D3.11"); // must fail
    XCTAssertFalse(checkAccount("6019835001", bankCode: "59052020"), "Rule D3.12"); // must fail

    // D4
    XCTAssertFalse(checkAccount("0", bankCode: "10050007"), "Rule D4.0");

    XCTAssert(checkAccount("1112048219", bankCode: "10050007"), "Rule D4.1");
    XCTAssert(checkAccount("2024601814", bankCode: "10050007"), "Rule D4.2");
    XCTAssert(checkAccount("3000005012", bankCode: "10050007"), "Rule D4.3");
    XCTAssert(checkAccount("4143406984", bankCode: "10050007"), "Rule D4.4");
    XCTAssert(checkAccount("5926485111", bankCode: "10050007"), "Rule D4.5");
    XCTAssert(checkAccount("6286304975", bankCode: "10050007"), "Rule D4.6");
    XCTAssert(checkAccount("7900256617", bankCode: "10050007"), "Rule D4.7");
    XCTAssert(checkAccount("8102228628", bankCode: "10050007"), "Rule D4.8");
    XCTAssert(checkAccount("9002364588", bankCode: "10050007"), "Rule D4.9");
    XCTAssertFalse(checkAccount("0359432843", bankCode: "10050007"), "Rule D4.10"); // must fail
    XCTAssertFalse(checkAccount("1000062023", bankCode: "10050007"), "Rule D4.11"); // must fail
    XCTAssertFalse(checkAccount("2204271250", bankCode: "10050007"), "Rule D4.12"); // must fail
    XCTAssertFalse(checkAccount("3051681017", bankCode: "10050007"), "Rule D4.13"); // must fail
    XCTAssertFalse(checkAccount("4000123456", bankCode: "10050007"), "Rule D4.14"); // must fail
    XCTAssertFalse(checkAccount("5212744564", bankCode: "10050007"), "Rule D4.15"); // must fail
    XCTAssertFalse(checkAccount("6286420010", bankCode: "10050007"), "Rule D4.16"); // must fail
    XCTAssertFalse(checkAccount("7859103459", bankCode: "10050007"), "Rule D4.17"); // must fail
    XCTAssertFalse(checkAccount("8003306026", bankCode: "10050007"), "Rule D4.18"); // must fail
    XCTAssertFalse(checkAccount("9916524534", bankCode: "10050007"), "Rule D4.19"); // must fail

    // D5
    XCTAssert(checkAccount("0", bankCode: "20690500"), "Rule D5.0");

    XCTAssert(checkAccount("5999718138", bankCode: "20690500"), "Rule D5.1");
    XCTAssert(checkAccount("1799222116", bankCode: "20690500"), "Rule D5.2");
    XCTAssert(checkAccount("0099632004", bankCode: "20690500"), "Rule D5.3");
    XCTAssertFalse(checkAccount("3299632008", bankCode: "20690500"), "Rule D5.4"); // must fail
    XCTAssertFalse(checkAccount("1999204293", bankCode: "20690500"), "Rule D5.5"); // must fail
    XCTAssertFalse(checkAccount("0399242139", bankCode: "20690500"), "Rule D5.6"); // must fail
    XCTAssert(checkAccount("8623410000", bankCode: "20690500"), "Rule D5.7");

    XCTAssert(checkAccount("0004711173", bankCode: "20690500"), "Rule D5.8");
    XCTAssert(checkAccount("0007093330", bankCode: "20690500"), "Rule D5.9");
    XCTAssert(checkAccount("0000127787", bankCode: "20690500"), "Rule D5.10");
    XCTAssertFalse(checkAccount("8623420004", bankCode: "20690500"), "Rule D5.11"); // must fail
    XCTAssertFalse(checkAccount("0001123458", bankCode: "20690500"), "Rule D5.12"); // must fail

    XCTAssert(checkAccount("0004711172", bankCode: "20690500"), "Rule D5.13");
    XCTAssert(checkAccount("0007093335", bankCode: "20690500"), "Rule D5.14");
    XCTAssertFalse(checkAccount("0001123458", bankCode: "20690500"), "Rule D5.15"); // must fail

    XCTAssert(checkAccount("0000100062", bankCode: "20690500"), "Rule D5.16");
    XCTAssert(checkAccount("0000100088", bankCode: "20690500"), "Rule D5.17");
    XCTAssertFalse(checkAccount("0000100084", bankCode: "20690500"), "Rule D5.18"); // must fail
    XCTAssertFalse(checkAccount("0000100085", bankCode: "20690500"), "Rule D5.19"); // must fail

    // D6
    XCTAssert(checkAccount("0", bankCode: "22151730"), "Rule D6.0");

    XCTAssert(checkAccount("3601671056", bankCode: "22151730"), "Rule D6.1");
    XCTAssert(checkAccount("4402001046", bankCode: "22151730"), "Rule D6.2");
    XCTAssert(checkAccount("6100268241", bankCode: "22151730"), "Rule D6.3");
    XCTAssertFalse(checkAccount("3615071237", bankCode: "22151730"), "Rule D6.4"); // must fail
    XCTAssertFalse(checkAccount("6039267013", bankCode: "22151730"), "Rule D6.5"); // must fail
    XCTAssertFalse(checkAccount("6039316014", bankCode: "22151730"), "Rule D6.6"); // must fail

    XCTAssert(checkAccount("7001000681", bankCode: "22151730"), "Rule D6.7");
    XCTAssert(checkAccount("9000111105", bankCode: "22151730"), "Rule D6.8");
    XCTAssert(checkAccount("9001291005", bankCode: "22151730"), "Rule D6.9");
    XCTAssertFalse(checkAccount("7004017653", bankCode: "22151730"), "Rule D6.10"); // must fail
    XCTAssertFalse(checkAccount("9002720007", bankCode: "22151730"), "Rule D6.11"); // must fail
    XCTAssertFalse(checkAccount("9017483524", bankCode: "22151730"), "Rule D6.12"); // must fail

    // D7
    XCTAssert(checkAccount("0", bankCode: "57020500"), "Rule D7.0");

    XCTAssert(checkAccount("0500018205", bankCode: "57020500"), "Rule D7.1");
    XCTAssert(checkAccount("0230103715", bankCode: "57020500"), "Rule D7.2");
    XCTAssert(checkAccount("0301000434", bankCode: "57020500"), "Rule D7.3");
    XCTAssert(checkAccount("0330035104", bankCode: "57020500"), "Rule D7.4");
    XCTAssert(checkAccount("0420001202", bankCode: "57020500"), "Rule D7.5");
    XCTAssert(checkAccount("0134637709", bankCode: "57020500"), "Rule D7.6");
    XCTAssert(checkAccount("0201005939", bankCode: "57020500"), "Rule D7.7");
    XCTAssert(checkAccount("0602006999", bankCode: "57020500"), "Rule D7.8");
    XCTAssertFalse(checkAccount("0501006102", bankCode: "57020500"), "Rule D7.9"); // must fail
    XCTAssertFalse(checkAccount("0231307867", bankCode: "57020500"), "Rule D7.10"); // must fail
    XCTAssertFalse(checkAccount("0301005331", bankCode: "57020500"), "Rule D7.11"); // must fail
    XCTAssertFalse(checkAccount("0330034104", bankCode: "57020500"), "Rule D7.12"); // must fail
    XCTAssertFalse(checkAccount("0420001302", bankCode: "57020500"), "Rule D7.13"); // must fail
    XCTAssertFalse(checkAccount("0135638809", bankCode: "57020500"), "Rule D7.14"); // must fail
    XCTAssertFalse(checkAccount("0202005939", bankCode: "57020500"), "Rule D7.15"); // must fail
    XCTAssertFalse(checkAccount("0601006977", bankCode: "57020500"), "Rule D7.16"); // must fail

    // D8
    XCTAssert(checkAccount("0", bankCode: "27020000"), "Rule D8.0");

    XCTAssert(checkAccount("1403414848", bankCode: "27020000"), "Rule D8.1");
    XCTAssert(checkAccount("6800000439", bankCode: "27020000"), "Rule D8.2");
    XCTAssert(checkAccount("6899999954", bankCode: "27020000"), "Rule D8.3");
    XCTAssertFalse(checkAccount("3012084101", bankCode: "27020000"), "Rule D8.4"); // must fail
    XCTAssertFalse(checkAccount("1062813622", bankCode: "27020000"), "Rule D8.5"); // must fail
    XCTAssertFalse(checkAccount("0000260986", bankCode: "27020000"), "Rule D8.6"); // must fail

    XCTAssert(checkAccount("0010000000", bankCode: "27020000"), "Rule D8.7");
    XCTAssert(checkAccount("0099999999", bankCode: "27020000"), "Rule D8.8");

    // D9
    XCTAssert(checkAccount("0", bankCode: "50120383"), "Rule D9.0");

    XCTAssert(checkAccount("1234567897", bankCode: "50120383"), "Rule D9.1");
    XCTAssert(checkAccount("0123456782", bankCode: "50120383"), "Rule D9.2");
    XCTAssertFalse(checkAccount("6543217890", bankCode: "50120383"), "Rule D9.5"); // must fail
    XCTAssertFalse(checkAccount("0543216789", bankCode: "50120383"), "Rule D9.6"); // must fail

    XCTAssert(checkAccount("9876543210", bankCode: "50120383"), "Rule D9.7");
    XCTAssert(checkAccount("1234567890", bankCode: "50120383"), "Rule D9.8");
    XCTAssert(checkAccount("0123456789", bankCode: "50120383"), "Rule D9.9");
    XCTAssertFalse(checkAccount("6543217890", bankCode: "50120383"), "Rule D9.10"); // must fail
    XCTAssertFalse(checkAccount("0543216789", bankCode: "50120383"), "Rule D9.11"); // must fail

    XCTAssert(checkAccount("1100132044", bankCode: "50120383"), "Rule D9.12");
    XCTAssert(checkAccount("1100669030", bankCode: "50120383"), "Rule D9.13");
    XCTAssertFalse(checkAccount("1100789043", bankCode: "50120383"), "Rule D9.14"); // must fail
    XCTAssertFalse(checkAccount("1100914032", bankCode: "50120383"), "Rule D9.15"); // must fail

    // E0
    XCTAssertFalse(checkAccount("0", bankCode: "20120400"), "Rule E0.0");

    XCTAssert(checkAccount("1234568013", bankCode: "20120400"), "Rule E0.1");
    XCTAssert(checkAccount("1534568010", bankCode: "20120400"), "Rule E0.2");
    XCTAssert(checkAccount("2610015", bankCode: "20120400"), "Rule E0.3");
    XCTAssert(checkAccount("8741013011", bankCode: "20120400"), "Rule E0.4");
    XCTAssertFalse(checkAccount("1234769013", bankCode: "20120400"), "Rule E0.5"); // must fail
    XCTAssertFalse(checkAccount("2710014", bankCode: "20120400"), "Rule E0.6"); // must fail
    XCTAssertFalse(checkAccount("9741015011", bankCode: "20120400"), "Rule E0.7"); // must fail

    // E1
    XCTAssertFalse(checkAccount("0", bankCode: "50131000"), "Rule E1.0");

    XCTAssert(checkAccount("0 1 3 4 2 1 1 9 0 9", bankCode: "50131000"), "Rule E1.1");
    XCTAssert(checkAccount("0100041104", bankCode: "50131000"), "Rule E1.2");
    XCTAssert(checkAccount("0100054106", bankCode: "50131000"), "Rule E1.3");
    XCTAssert(checkAccount("0200025107", bankCode: "50131000"), "Rule E1.4");
    XCTAssertFalse(checkAccount("0150013107", bankCode: "50131000"), "Rule E1.5"); // must fail
    XCTAssertFalse(checkAccount("0200035101", bankCode: "50131000"), "Rule E1.6"); // must fail
    XCTAssertFalse(checkAccount("0081313890", bankCode: "50131000"), "Rule E1.7"); // must fail
    XCTAssertFalse(checkAccount("4268550840", bankCode: "50131000"), "Rule E1.8"); // must fail
    XCTAssertFalse(checkAccount("0987402008", bankCode: "50131000"), "Rule E1.9"); // must fail
    
  }
}

