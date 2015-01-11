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

  func testChecksums() {
    // 00
    // Tests for a 0-account mostly test if the algorithm is robust against such a corner case,
    // not so much to compute a valid account number/checksum.
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "12030000", countryCode: "de").0, "Rule 00.0");

    XCTAssert(IBANtools.isValidAccount("9290701", bankCode: "12030000", countryCode: "de").0, "Rule 00.1");
    XCTAssert(IBANtools.isValidAccount("539290858", bankCode: "12030000", countryCode: "de").0, "Rule 00.2");
    XCTAssert(IBANtools.isValidAccount("1501824", bankCode: "12030000", countryCode: "de").0, "Rule 00.3");
    XCTAssert(IBANtools.isValidAccount("1501832", bankCode: "12030000", countryCode: "de").0, "Rule 00.4");

    // 01 - no test case yet, don't include a single 0-account test, if there are no real test cases too.
    // 02 - no test case yet
    // 03 - no test case yet
    // 04 - no test case yet
    // 05 - no test case yet

    // 06
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "15091704", countryCode: "de").0, "Rule 06.0");
    XCTAssert(IBANtools.isValidAccount("94012341", bankCode: "15091704", countryCode: "de").0, "Rule 06.1");
    XCTAssert(IBANtools.isValidAccount("5073321010", bankCode: "15091704", countryCode: "de").0, "Rule 06.2");

    // 07 - no test case yet
    // 08 - no test case yet

    // 09 - no checksum check, all accounts are valid
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "16010300", countryCode: "de").0, "Rule 09.0");
    XCTAssert(IBANtools.isValidAccount("12345", bankCode: "16010300", countryCode: "de").0, "Rule 09.1");
    XCTAssert(IBANtools.isValidAccount("9999999999", bankCode: "16010300", countryCode: "de").0, "Rule 09.2");

    // 10
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "20030133", countryCode: "de").0, "Rule 10.0");
    XCTAssert(IBANtools.isValidAccount("12345008", bankCode: "20030133", countryCode: "de").0, "Rule 10.1");
    XCTAssert(IBANtools.isValidAccount("87654008", bankCode: "20030133", countryCode: "de").0, "Rule 10.2");

    // 11 - no test case yet
    // 12 - not used
    // 13 - no test case yet
    // 14 - no test case yet
    // 15 - no test case yet
    // 16 - no test case yet

    // 17
    XCTAssert(!IBANtools.isValidAccount("0", bankCode: "10110600", countryCode: "de").0, "Rule 17.0");
    XCTAssert(IBANtools.isValidAccount("0446786040", bankCode: "10110600", countryCode: "de").0, "Rule 17.1");

    // 18 - no test case yet

    // 19
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "10220600", countryCode: "de").0, "Rule 19.0");
    XCTAssert(IBANtools.isValidAccount("0240334000", bankCode: "10220600", countryCode: "de").0, "Rule 19.1");
    XCTAssert(IBANtools.isValidAccount("0200520016", bankCode: "10220600", countryCode: "de").0, "Rule 19.2");

    // 20 - no test case yet
    // 21 - no test case yet
    // 22 - used by C2 and tested by its test cases
    // 23 - no test case yet

    // 24
    XCTAssert(!IBANtools.isValidAccount("0", bankCode: "37010050", countryCode: "de").0, "Rule 24.0");
    XCTAssert(IBANtools.isValidAccount("1 3 8 3 0 1", bankCode: "37010050", countryCode: "de").0, "Rule 24.1");
    XCTAssert(IBANtools.isValidAccount("1 3 0 6 1 1 8 6 0 5", bankCode: "37010050", countryCode: "de").0, "Rule 24.2");
    XCTAssert(IBANtools.isValidAccount("3 3 0 7 1 1 8 6 0 8", bankCode: "37010050", countryCode: "de").0, "Rule 24.3");
    XCTAssert(IBANtools.isValidAccount("9 3 0 7 1 1 8 6 0 3", bankCode: "37010050", countryCode: "de").0, "Rule 24.4");

    // 25
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "42050001", countryCode: "de").0, "Rule 25.0");
    XCTAssert(IBANtools.isValidAccount("5 2 1 3 8 2 1 8 1", bankCode: "42050001", countryCode: "de").0, "Rule 25.1");

    // 26
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "72012300", countryCode: "de").0, "Rule 26.0");
    XCTAssert(IBANtools.isValidAccount("0520309001", bankCode: "72012300", countryCode: "de").0, "Rule 26.1");
    XCTAssert(IBANtools.isValidAccount("1111118111", bankCode: "72012300", countryCode: "de").0, "Rule 26.2");
    XCTAssert(IBANtools.isValidAccount("0005501024", bankCode: "72012300", countryCode: "de").0, "Rule 26.3");

    // 27
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "25050000", countryCode: "de").0, "Rule 27.0");
    XCTAssert(IBANtools.isValidAccount("12344", bankCode: "25050000", countryCode: "de").0, "Rule 27.1");
    XCTAssert(IBANtools.isValidAccount("2847169488", bankCode: "25050000", countryCode: "de").0, "Rule 27.2");

    // 28
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "16062008", countryCode: "de").0, "Rule 28.0");
    XCTAssert(IBANtools.isValidAccount("19999000", bankCode: "16062008", countryCode: "de").0, "Rule 28.1");
    XCTAssert(IBANtools.isValidAccount("9130000201", bankCode: "16062008", countryCode: "de").0, "Rule 28.2");

    // 29
    XCTAssert(!IBANtools.isValidAccount("0", bankCode: "29050000", countryCode: "de").0, "Rule 29.0");
    XCTAssert(IBANtools.isValidAccount("3 1 4 5 8 6 3 0 2 9", bankCode: "29050000", countryCode: "de").0, "Rule 29.1");

    // 30 - no test case yet

    // 31
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "50324000", countryCode: "de").0, "Rule 31.0");
    XCTAssert(IBANtools.isValidAccount("1000000524", bankCode: "50324000", countryCode: "de").0, "Rule 31.1");
    XCTAssert(IBANtools.isValidAccount("1000000583", bankCode: "50324000", countryCode: "de").0, "Rule 31.2");

    // 32
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "50560102", countryCode: "de").0, "Rule 32.0");
    XCTAssert(IBANtools.isValidAccount("9141405", bankCode: "50560102", countryCode: "de").0, "Rule 32.1");
    XCTAssert(IBANtools.isValidAccount("1709107983", bankCode: "50560102", countryCode: "de").0, "Rule 32.2");
    XCTAssert(IBANtools.isValidAccount("0122116979", bankCode: "50560102", countryCode: "de").0, "Rule 32.3");
    XCTAssert(IBANtools.isValidAccount("0121114867", bankCode: "50560102", countryCode: "de").0, "Rule 32.4");
    XCTAssert(IBANtools.isValidAccount("9030101192", bankCode: "50560102", countryCode: "de").0, "Rule 32.5");
    XCTAssert(IBANtools.isValidAccount("9245500460", bankCode: "50560102", countryCode: "de").0, "Rule 32.6");

    // 33
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "10060237", countryCode: "de").0, "Rule 33.0");
    XCTAssert(IBANtools.isValidAccount("48658", bankCode: "10060237", countryCode: "de").0, "Rule 33.1");
    XCTAssert(IBANtools.isValidAccount("84956", bankCode: "10060237", countryCode: "de").0, "Rule 33.2");

    // 34
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "36060488", countryCode: "de").0, "Rule 34.0");
    XCTAssert(IBANtools.isValidAccount("9913000700", bankCode: "36060488", countryCode: "de").0, "Rule 34.1");
    XCTAssert(IBANtools.isValidAccount("9914001000", bankCode: "36060488", countryCode: "de").0, "Rule 34.2");

    // 35 - defined but not used it seems. Use dummy bank codes for these tests.
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "11111111", countryCode: "de").0, "Rule 35.0");
    XCTAssert(IBANtools.isValidAccount("0000108443", bankCode: "11111111", countryCode: "de").0, "Rule 35.1");
    XCTAssert(IBANtools.isValidAccount("0000107451", bankCode: "11111111", countryCode: "de").0, "Rule 35.2");
    XCTAssert(IBANtools.isValidAccount("0000102921", bankCode: "11111111", countryCode: "de").0, "Rule 35.3");
    XCTAssert(IBANtools.isValidAccount("0000102349", bankCode: "11111111", countryCode: "de").0, "Rule 35.4");
    XCTAssert(IBANtools.isValidAccount("0000101709", bankCode: "11111111", countryCode: "de").0, "Rule 35.5");
    XCTAssert(IBANtools.isValidAccount("0000101599", bankCode: "11111111", countryCode: "de").0, "Rule 35.6");
    
    // 36 - same as for 35
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "11111112", countryCode: "de").0, "Rule 36.0");
    XCTAssert(IBANtools.isValidAccount("113178", bankCode: "11111112", countryCode: "de").0, "Rule 36.1");
    XCTAssert(IBANtools.isValidAccount("146666", bankCode: "11111112", countryCode: "de").0, "Rule 36.2");

    // 37 - same as for 35
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "11111113", countryCode: "de").0, "Rule 37.0");
    XCTAssert(IBANtools.isValidAccount("624315", bankCode: "11111113", countryCode: "de").0, "Rule 37.1");
    XCTAssert(IBANtools.isValidAccount("632500", bankCode: "11111113", countryCode: "de").0, "Rule 37.2");

    // 38
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "38621500", countryCode: "de").0, "Rule 38.0");
    XCTAssert(IBANtools.isValidAccount("191919", bankCode: "38621500", countryCode: "de").0, "Rule 38.1");
    XCTAssert(IBANtools.isValidAccount("1100660", bankCode: "38621500", countryCode: "de").0, "Rule 38.2");

    // 39 - same as for 35
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "11111114", countryCode: "de").0, "Rule 39.0");
    XCTAssert(IBANtools.isValidAccount("624315", bankCode: "11111114", countryCode: "de").0, "Rule 39.1");
    XCTAssert(IBANtools.isValidAccount("632500", bankCode: "11111114", countryCode: "de").0, "Rule 39.2");

    // 40
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "56062227", countryCode: "de").0, "Rule 40.0");
    XCTAssert(IBANtools.isValidAccount("1258345", bankCode: "56062227", countryCode: "de").0, "Rule 40.1");
    XCTAssert(IBANtools.isValidAccount("3231963", bankCode: "56062227", countryCode: "de").0, "Rule 40.2");

    // 41
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "25020600", countryCode: "de").0, "Rule 41.0");
    XCTAssert(IBANtools.isValidAccount("4013410024", bankCode: "25020600", countryCode: "de").0, "Rule 41.1");
    XCTAssert(IBANtools.isValidAccount("4016660195", bankCode: "25020600", countryCode: "de").0, "Rule 41.2");
    XCTAssert(IBANtools.isValidAccount("0166805317", bankCode: "25020600", countryCode: "de").0, "Rule 41.3");
    XCTAssert(IBANtools.isValidAccount("4029310079", bankCode: "25020600", countryCode: "de").0, "Rule 41.4");
    XCTAssert(IBANtools.isValidAccount("4029340829", bankCode: "25020600", countryCode: "de").0, "Rule 41.5");
    XCTAssert(IBANtools.isValidAccount("4029151002", bankCode: "25020600", countryCode: "de").0, "Rule 41.6");

    // 42
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "66661454", countryCode: "de").0, "Rule 42.0");
    XCTAssert(IBANtools.isValidAccount("59498", bankCode: "66661454", countryCode: "de").0, "Rule 42.1");
    XCTAssert(IBANtools.isValidAccount("59510", bankCode: "66661454", countryCode: "de").0, "Rule 42.2");

    // 43
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "66690000", countryCode: "de").0, "Rule 43.0");
    XCTAssert(IBANtools.isValidAccount("6135244", bankCode: "66690000", countryCode: "de").0, "Rule 43.1");
    XCTAssert(IBANtools.isValidAccount("9516893476", bankCode: "66690000", countryCode: "de").0, "Rule 43.2");

    // 44
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "30060010", countryCode: "de").0, "Rule 44.0");
    XCTAssert(IBANtools.isValidAccount("889006", bankCode: "30060010", countryCode: "de").0, "Rule 44.1");
    XCTAssert(IBANtools.isValidAccount("2618040504", bankCode: "30060010", countryCode: "de").0, "Rule 44.2");

    // 45
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "29020000", countryCode: "de").0, "Rule 45.0");
    XCTAssert(IBANtools.isValidAccount("3545343232", bankCode: "29020000", countryCode: "de").0, "Rule 45.1");
    XCTAssert(IBANtools.isValidAccount("4013410024", bankCode: "29020000", countryCode: "de").0, "Rule 45.2");
    XCTAssert(IBANtools.isValidAccount("0994681254", bankCode: "29020000", countryCode: "de").0, "Rule 45.3");
    XCTAssert(IBANtools.isValidAccount("0000012340", bankCode: "29020000", countryCode: "de").0, "Rule 45.4");
    XCTAssert(IBANtools.isValidAccount("1000199999", bankCode: "29020000", countryCode: "de").0, "Rule 45.5");
    XCTAssert(IBANtools.isValidAccount("0100114240", bankCode: "29020000", countryCode: "de").0, "Rule 45.6");

    // 46
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "50310400", countryCode: "de").0, "Rule 46.0");
    XCTAssert(IBANtools.isValidAccount("0235468612", bankCode: "50310400", countryCode: "de").0, "Rule 46.1");
    XCTAssert(IBANtools.isValidAccount("0837890901", bankCode: "50310400", countryCode: "de").0, "Rule 46.2");
    XCTAssert(IBANtools.isValidAccount("1041447600", bankCode: "50310400", countryCode: "de").0, "Rule 46.3");

    // 47
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "27290087", countryCode: "de").0, "Rule 47.0");
    XCTAssert(IBANtools.isValidAccount("1018000", bankCode: "27290087", countryCode: "de").0, "Rule 47.1");
    XCTAssert(IBANtools.isValidAccount("1003554450", bankCode: "27290087", countryCode: "de").0, "Rule 47.2");

    // 48 - no test case yet
    // 49 - no test case yet

    // 50
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "51220910", countryCode: "de").0, "Rule 50.0");
    XCTAssert(IBANtools.isValidAccount("4000005001", bankCode: "51220910", countryCode: "de").0, "Rule 50.1");
    XCTAssert(IBANtools.isValidAccount("4444442001", bankCode: "51220910", countryCode: "de").0, "Rule 50.2");
    XCTAssert(IBANtools.isValidAccount("4444442", bankCode: "51220910", countryCode: "de").0, "Rule 50.3");

    // 51 - this one is crazy: 4 different approaches used until one succeeds + 2 special cases.
    // The cases that must fail are probably meant to fail the specific sub check, but may succeed in
    // a following one. So, some of the fail values are not included here.
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "33060592", countryCode: "de").0, "Rule 51.0");
    XCTAssert(IBANtools.isValidAccount("0001156071", bankCode: "33060592", countryCode: "de").0, "Rule 51.1");
    XCTAssert(IBANtools.isValidAccount("0001156136", bankCode: "33060592", countryCode: "de").0, "Rule 51.2");
    XCTAssert(!IBANtools.isValidAccount("0000156079", bankCode: "33060592", countryCode: "de").0, "Rule 51.4"); // must fail
    XCTAssert(IBANtools.isValidAccount("0001156078", bankCode: "33060592", countryCode: "de").0, "Rule 51.5");
    XCTAssert(IBANtools.isValidAccount("0001234567", bankCode: "33060592", countryCode: "de").0, "Rule 51.6");
    XCTAssert(!IBANtools.isValidAccount("0012345678", bankCode: "33060592", countryCode: "de").0, "Rule 51.8"); // must fail
    XCTAssert(IBANtools.isValidAccount("340968", bankCode: "33060592", countryCode: "de").0, "Rule 51.9");
    XCTAssert(IBANtools.isValidAccount("201178", bankCode: "33060592", countryCode: "de").0, "Rule 51.10");
    XCTAssert(IBANtools.isValidAccount("1009588", bankCode: "33060592", countryCode: "de").0, "Rule 51.10");
    XCTAssert(!IBANtools.isValidAccount("0023456783", bankCode: "33060592", countryCode: "de").0, "Rule 51.11"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0076543211", bankCode: "33060592", countryCode: "de").0, "Rule 51.12"); // must fail
    XCTAssert(IBANtools.isValidAccount("0000156071", bankCode: "33060592", countryCode: "de").0, "Rule 51.13");
    XCTAssert(IBANtools.isValidAccount("101356073", bankCode: "33060592", countryCode: "de").0, "Rule 51.14");
    XCTAssert(!IBANtools.isValidAccount("0123412345", bankCode: "33060592", countryCode: "de").0, "Rule 51.15"); // must fail
    XCTAssert(!IBANtools.isValidAccount("67493647", bankCode: "33060592", countryCode: "de").0, "Rule 51.16"); // must fail

    // Special cases
    XCTAssert(IBANtools.isValidAccount("0199100002", bankCode: "33060592", countryCode: "de").0, "Rule 51.17");
    XCTAssert(IBANtools.isValidAccount("0099100010", bankCode: "33060592", countryCode: "de").0, "Rule 51.18");
    XCTAssert(IBANtools.isValidAccount("2599100002", bankCode: "33060592", countryCode: "de").0, "Rule 51.19");
    XCTAssert(!IBANtools.isValidAccount("0099345678", bankCode: "33060592", countryCode: "de").0, "Rule 51.22"); // must fail
    XCTAssert(IBANtools.isValidAccount("0199100004", bankCode: "33060592", countryCode: "de").0, "Rule 51.23");
    XCTAssert(IBANtools.isValidAccount("2599100003", bankCode: "33060592", countryCode: "de").0, "Rule 51.24");
    XCTAssert(IBANtools.isValidAccount("3199204090", bankCode: "33060592", countryCode: "de").0, "Rule 51.25");
    XCTAssert(!IBANtools.isValidAccount("0099345678", bankCode: "33060592", countryCode: "de").0, "Rule 51.26"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0099100110", bankCode: "33060592", countryCode: "de").0, "Rule 51.27"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0199100040", bankCode: "33060592", countryCode: "de").0, "Rule 51.28"); // must fail

    // 52
    XCTAssert(!IBANtools.isValidAccount("0", bankCode: "13051172", countryCode: "de").0, "Rule 52.0");
    XCTAssert(IBANtools.isValidAccount("43001500", bankCode: "13051172", countryCode: "de").0, "Rule 52.1");

    // 53 - used as second chance by method B6
    XCTAssert(!IBANtools.isValidAccount("0", bankCode: "16052072", countryCode: "de").0, "Rule 53.0");
    XCTAssert(IBANtools.isValidAccount("382432256", bankCode: "16052082", countryCode: "de").0, "Rule 53.1");

    // 54
    XCTAssert(!IBANtools.isValidAccount("0", bankCode: "11111115", countryCode: "de").0, "Rule 54.0");
    XCTAssert(IBANtools.isValidAccount("49 64137395", bankCode: "11111115", countryCode: "de").0, "Rule 54.1");
    XCTAssert(IBANtools.isValidAccount("49 00010987", bankCode: "11111115", countryCode: "de").0, "Rule 54.2");

    // 55 - no test case yet

    // 56
    XCTAssert(!IBANtools.isValidAccount("0", bankCode: "51051000", countryCode: "de").0, "Rule 56.0");
    XCTAssert(IBANtools.isValidAccount("0 2 9 0 5 4 5 0 0 5", bankCode: "51051000", countryCode: "de").0, "Rule 56.1");
    XCTAssert(IBANtools.isValidAccount("9718304037", bankCode: "51051000", countryCode: "de").0, "Rule 56.2");

    // 57 - also here multiple variants.
    XCTAssert(!IBANtools.isValidAccount("0", bankCode: "30020900", countryCode: "de").0, "Rule 57.0");
    XCTAssert(IBANtools.isValidAccount("7500021766", bankCode: "30020900", countryCode: "de").0, "Rule 57.1");
    XCTAssert(IBANtools.isValidAccount("9400001734", bankCode: "30020900", countryCode: "de").0, "Rule 57.2");
    XCTAssert(IBANtools.isValidAccount("7800028282", bankCode: "30020900", countryCode: "de").0, "Rule 57.3");
    XCTAssert(IBANtools.isValidAccount("8100244186", bankCode: "30020900", countryCode: "de").0, "Rule 57.4");
    XCTAssert(IBANtools.isValidAccount("3251080371", bankCode: "30020900", countryCode: "de").0, "Rule 57.5");
    XCTAssert(IBANtools.isValidAccount("3891234567", bankCode: "30020900", countryCode: "de").0, "Rule 57.6");
    XCTAssert(IBANtools.isValidAccount("7777778800", bankCode: "30020900", countryCode: "de").0, "Rule 57.7");
    XCTAssert(IBANtools.isValidAccount("5001050352", bankCode: "30020900", countryCode: "de").0, "Rule 57.8");
    XCTAssert(IBANtools.isValidAccount("5045090090", bankCode: "30020900", countryCode: "de").0, "Rule 57.9");
    XCTAssert(IBANtools.isValidAccount("1909700805", bankCode: "30020900", countryCode: "de").0, "Rule 57.10");
    XCTAssert(IBANtools.isValidAccount("9322111030", bankCode: "30020900", countryCode: "de").0, "Rule 57.11");
    XCTAssert(IBANtools.isValidAccount("7400060823", bankCode: "30020900", countryCode: "de").0, "Rule 57.12");

    XCTAssert(!IBANtools.isValidAccount("5302707782", bankCode: "30020900", countryCode: "de").0, "Rule 57.13"); // must fail
    XCTAssert(!IBANtools.isValidAccount("6412121212", bankCode: "30020900", countryCode: "de").0, "Rule 57.14"); // must fail
    XCTAssert(!IBANtools.isValidAccount("1813499124", bankCode: "30020900", countryCode: "de").0, "Rule 57.15"); // must fail
    XCTAssert(!IBANtools.isValidAccount("2206735010", bankCode: "30020900", countryCode: "de").0, "Rule 57.16"); // must fail

    // 58
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "20120100", countryCode: "de").0, "Rule 58.0");
    XCTAssert(IBANtools.isValidAccount("1800881120", bankCode: "20120100", countryCode: "de").0, "Rule 58.1");
    XCTAssert(IBANtools.isValidAccount("9200654108", bankCode: "20120100", countryCode: "de").0, "Rule 58.2");
    XCTAssert(IBANtools.isValidAccount("1015222224", bankCode: "20120100", countryCode: "de").0, "Rule 58.3");
    XCTAssert(IBANtools.isValidAccount("3703169668", bankCode: "20120100", countryCode: "de").0, "Rule 58.4");

    // 59 - no test case yet
    // 60 - no test case yet

    // 61
    XCTAssert(!IBANtools.isValidAccount("0", bankCode: "25621327", countryCode: "de").0, "Rule 61.0");
    XCTAssert(IBANtools.isValidAccount("2 0 6 3 0 9 9 2 0 0", bankCode: "25621327", countryCode: "de").0, "Rule 61.1");
    XCTAssert(IBANtools.isValidAccount("0 2 6 0 7 6 0 2 8 2", bankCode: "25621327", countryCode: "de").0, "Rule 61.2");

    // 62
    XCTAssert(!IBANtools.isValidAccount("0", bankCode: "11111116", countryCode: "de").0, "Rule 62.0");
    XCTAssert(IBANtools.isValidAccount("5 0 2 9 0 7 6 7 0 1", bankCode: "11111116", countryCode: "de").0, "Rule 62.1");

    // 63
    XCTAssert(!IBANtools.isValidAccount("0", bankCode: "25770024", countryCode: "de").0, "Rule 63.0");
    XCTAssert(IBANtools.isValidAccount("1 2 3 4 5 6 6 0 0", bankCode: "25770024", countryCode: "de").0, "Rule 63.1");
    XCTAssert(IBANtools.isValidAccount("0 0 0 1 2 3 4 5 6 6", bankCode: "25770024", countryCode: "de").0, "Rule 63.2");

    // 64
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "57090000", countryCode: "de").0, "Rule 64.0");
    XCTAssert(IBANtools.isValidAccount("1206473010", bankCode: "57090000", countryCode: "de").0, "Rule 64.1");
    XCTAssert(IBANtools.isValidAccount("5016511020", bankCode: "57090000", countryCode: "de").0, "Rule 64.2");

    // 65
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "60020030", countryCode: "de").0, "Rule 65.0");
    XCTAssert(IBANtools.isValidAccount("1 2 3 4 5 6 7 4 0 0", bankCode: "60020030", countryCode: "de").0, "Rule 65.1");
    XCTAssert(IBANtools.isValidAccount("1 2 3 4 5 6 7 5 9 0", bankCode: "60020030", countryCode: "de").0, "Rule 65.2");

    // 66
    XCTAssert(!IBANtools.isValidAccount("0", bankCode: "50120500", countryCode: "de").0, "Rule 66.0");
    XCTAssert(IBANtools.isValidAccount("100150502", bankCode: "50120500", countryCode: "de").0, "Rule 66.1");
    XCTAssert(IBANtools.isValidAccount("100154508", bankCode: "50120500", countryCode: "de").0, "Rule 66.2");
    XCTAssert(IBANtools.isValidAccount("101154508", bankCode: "50120500", countryCode: "de").0, "Rule 66.3");
    XCTAssert(IBANtools.isValidAccount("100154516", bankCode: "50120500", countryCode: "de").0, "Rule 66.4");
    XCTAssert(IBANtools.isValidAccount("101154516", bankCode: "50120500", countryCode: "de").0, "Rule 66.5");
    XCTAssert(IBANtools.isValidAccount("0983393104", bankCode: "50120500", countryCode: "de").0, "Rule 66.6");

    // 67 - no test case yet

    // 68
    XCTAssert(!IBANtools.isValidAccount("0", bankCode: "20030000", countryCode: "de").0, "Rule 68.0");

    XCTAssert(IBANtools.isValidAccount("8 8 8 9 6 5 4 3 2 8", bankCode: "20030000", countryCode: "de").0, "Rule 68.1");
    XCTAssert(IBANtools.isValidAccount("9 8 7 6 5 4 3 2 4", bankCode: "20030000", countryCode: "de").0, "Rule 68.2");
    XCTAssert(IBANtools.isValidAccount("9 8 7 6 5 4 3 2 8", bankCode: "20030000", countryCode: "de").0, "Rule 68.3");
    XCTAssert(IBANtools.isValidAccount("400 000 000", bankCode: "20030000", countryCode: "de").0, "Rule 68.4");

    // 69
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "11111117", countryCode: "de").0, "Rule 69.0");
    XCTAssert(IBANtools.isValidAccount("9 7 2 1 1 3 4 8 6 9", bankCode: "11111117", countryCode: "de").0, "Rule 69.1");
    XCTAssert(IBANtools.isValidAccount("1234567900", bankCode: "11111117", countryCode: "de").0, "Rule 69.2");
    XCTAssert(IBANtools.isValidAccount("1234567006", bankCode: "11111117", countryCode: "de").0, "Rule 69.3");
    XCTAssert(IBANtools.isValidAccount("9 300 000 000", bankCode: "11111117", countryCode: "de").0, "Rule 69.4");

    // 70 - not used and no test case yet

    // 71
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "65110200", countryCode: "de").0, "Rule 71.0");
    XCTAssert(IBANtools.isValidAccount("7 1 0 1 2 3 4 0 0 7", bankCode: "65110200", countryCode: "de").0, "Rule 71.1");

    // 72 - not used and no test case yet

    // 73 - also here multiple variants.
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "50090500", countryCode: "de").0, "Rule 73.0");
    XCTAssert(IBANtools.isValidAccount("0003503398", bankCode: "50090500", countryCode: "de").0, "Rule 73.1");
    XCTAssert(IBANtools.isValidAccount("0001340967", bankCode: "50090500", countryCode: "de").0, "Rule 73.2");
    XCTAssert(IBANtools.isValidAccount("0003503391", bankCode: "50090500", countryCode: "de").0, "Rule 73.3");
    XCTAssert(IBANtools.isValidAccount("0001340968", bankCode: "50090500", countryCode: "de").0, "Rule 73.4");
    XCTAssert(IBANtools.isValidAccount("0003503392", bankCode: "50090500", countryCode: "de").0, "Rule 73.5");
    XCTAssert(IBANtools.isValidAccount("0001340966", bankCode: "50090500", countryCode: "de").0, "Rule 73.6");
    XCTAssert(IBANtools.isValidAccount("123456", bankCode: "50090500", countryCode: "de").0, "Rule 73.7");
    XCTAssert(IBANtools.isValidAccount("0199100002", bankCode: "50090500", countryCode: "de").0, "Rule 73.8");
    XCTAssert(IBANtools.isValidAccount("0099100010", bankCode: "50090500", countryCode: "de").0, "Rule 73.9");
    XCTAssert(IBANtools.isValidAccount("2599100002", bankCode: "50090500", countryCode: "de").0, "Rule 73.10");
    XCTAssert(IBANtools.isValidAccount("0199100004", bankCode: "50090500", countryCode: "de").0, "Rule 73.11");
    XCTAssert(IBANtools.isValidAccount("2599100003", bankCode: "50090500", countryCode: "de").0, "Rule 73.12");
    XCTAssert(IBANtools.isValidAccount("3199204090", bankCode: "50090500", countryCode: "de").0, "Rule 73.13");

    XCTAssert(!IBANtools.isValidAccount("121212", bankCode: "50090500", countryCode: "de").0, "Rule 73.14"); // must fail
    XCTAssert(!IBANtools.isValidAccount("987654321", bankCode: "50090500", countryCode: "de").0, "Rule 73.15"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0099345678", bankCode: "50090500", countryCode: "de").0, "Rule 73.16"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0099100110", bankCode: "50090500", countryCode: "de").0, "Rule 73.17"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0199100040", bankCode: "50090500", countryCode: "de").0, "Rule 73.18"); // must fail

    // 74 - also here multiple variants.
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "21050170", countryCode: "de").0, "Rule 74.0");
    XCTAssert(IBANtools.isValidAccount("1016", bankCode: "21050170", countryCode: "de").0, "Rule 74.1");
    XCTAssert(IBANtools.isValidAccount("26260", bankCode: "21050170", countryCode: "de").0, "Rule 74.2");
    XCTAssert(IBANtools.isValidAccount("242243", bankCode: "21050170", countryCode: "de").0, "Rule 74.3");
    XCTAssert(IBANtools.isValidAccount("242248", bankCode: "21050170", countryCode: "de").0, "Rule 74.4");
    XCTAssert(IBANtools.isValidAccount("18002113", bankCode: "21050170", countryCode: "de").0, "Rule 74.5");
    XCTAssert(IBANtools.isValidAccount("1821200043", bankCode: "21050170", countryCode: "de").0, "Rule 74.6");

    XCTAssert(!IBANtools.isValidAccount("1011", bankCode: "21050170", countryCode: "de").0, "Rule 74.7"); // must fail
    XCTAssert(!IBANtools.isValidAccount("26265", bankCode: "21050170", countryCode: "de").0, "Rule 74.8"); // must fail
    XCTAssert(!IBANtools.isValidAccount("18002118", bankCode: "21050170", countryCode: "de").0, "Rule 74.9"); // must fail
    XCTAssert(!IBANtools.isValidAccount("6160000024", bankCode: "21050170", countryCode: "de").0, "Rule 74.10"); // must fail

    // 75 - used by method C5 and tested by its test cases

    // 76
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "21080050", countryCode: "de").0, "Rule 76.0");
    XCTAssert(IBANtools.isValidAccount("0006543200", bankCode: "21080050", countryCode: "de").0, "Rule 76.1");
    XCTAssert(IBANtools.isValidAccount("9012345600", bankCode: "21080050", countryCode: "de").0, "Rule 76.2");
    XCTAssert(IBANtools.isValidAccount("7876543100", bankCode: "21080050", countryCode: "de").0, "Rule 76.3");
    XCTAssert(IBANtools.isValidAccount("78765431", bankCode: "21080050", countryCode: "de").0, "Rule 76.4");

    // 77
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "11111118", countryCode: "de").0, "Rule 77.0");
    XCTAssert(IBANtools.isValidAccount("10338", bankCode: "11111118", countryCode: "de").0, "Rule 77.1");
    XCTAssert(IBANtools.isValidAccount("13844", bankCode: "11111118", countryCode: "de").0, "Rule 77.2");
    XCTAssert(IBANtools.isValidAccount("65354", bankCode: "11111118", countryCode: "de").0, "Rule 77.3");
    XCTAssert(IBANtools.isValidAccount("69258", bankCode: "11111118", countryCode: "de").0, "Rule 77.4");

    // 78
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "36050105", countryCode: "de").0, "Rule 78.0");
    XCTAssert(IBANtools.isValidAccount("7581499", bankCode: "36050105", countryCode: "de").0, "Rule 78.1");
    XCTAssert(IBANtools.isValidAccount("9999999981", bankCode: "36050105", countryCode: "de").0, "Rule 78.2");
    XCTAssert(IBANtools.isValidAccount("12345678", bankCode: "36050105", countryCode: "de").0, "Rule 78.3");

    // 79
    XCTAssert(!IBANtools.isValidAccount("0", bankCode: "11111119", countryCode: "de").0, "Rule 79.0");
    XCTAssert(IBANtools.isValidAccount("3230012688", bankCode: "11111119", countryCode: "de").0, "Rule 79.1");
    XCTAssert(IBANtools.isValidAccount("4230028872", bankCode: "11111119", countryCode: "de").0, "Rule 79.2");
    XCTAssert(IBANtools.isValidAccount("5440001898", bankCode: "11111119", countryCode: "de").0, "Rule 79.3");
    XCTAssert(IBANtools.isValidAccount("6330001063", bankCode: "11111119", countryCode: "de").0, "Rule 79.4");
    XCTAssert(IBANtools.isValidAccount("7000149349", bankCode: "11111119", countryCode: "de").0, "Rule 79.5");
    XCTAssert(IBANtools.isValidAccount("8000003577", bankCode: "11111119", countryCode: "de").0, "Rule 79.6");
    XCTAssert(IBANtools.isValidAccount("1550167850", bankCode: "11111119", countryCode: "de").0, "Rule 79.7");
    XCTAssert(IBANtools.isValidAccount("9011200140", bankCode: "11111119", countryCode: "de").0, "Rule 79.8");

    // 80
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "11111120", countryCode: "de").0, "Rule 80.0");
    XCTAssert(IBANtools.isValidAccount("340968", bankCode: "11111120", countryCode: "de").0, "Rule 80.1");
    XCTAssert(IBANtools.isValidAccount("340966", bankCode: "11111120", countryCode: "de").0, "Rule 80.2");

    // Special cases (like in rule 51)
    XCTAssert(IBANtools.isValidAccount("0199100002", bankCode: "11111120", countryCode: "de").0, "Rule 80.3");
    XCTAssert(IBANtools.isValidAccount("0099100010", bankCode: "11111120", countryCode: "de").0, "Rule 80.4");
    XCTAssert(IBANtools.isValidAccount("2599100002", bankCode: "11111120", countryCode: "de").0, "Rule 80.5");
    XCTAssert(!IBANtools.isValidAccount("0099345678", bankCode: "11111120", countryCode: "de").0, "Rule 80.6"); // must fail
    XCTAssert(IBANtools.isValidAccount("0199100004", bankCode: "11111120", countryCode: "de").0, "Rule 80.7");
    XCTAssert(IBANtools.isValidAccount("2599100003", bankCode: "11111120", countryCode: "de").0, "Rule 80.8");
    XCTAssert(IBANtools.isValidAccount("3199204090", bankCode: "11111120", countryCode: "de").0, "Rule 80.9");
    XCTAssert(!IBANtools.isValidAccount("0099345678", bankCode: "11111120", countryCode: "de").0, "Rule 80.10"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0099100110", bankCode: "11111120", countryCode: "de").0, "Rule 80.11"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0199100040", bankCode: "11111120", countryCode: "de").0, "Rule 80.12"); // must fail

    // 81
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "70090500", countryCode: "de").0, "Rule 81.0");
    XCTAssert(IBANtools.isValidAccount("0646440", bankCode: "70090500", countryCode: "de").0, "Rule 81.1");
    XCTAssert(IBANtools.isValidAccount("1359100", bankCode: "70090500", countryCode: "de").0, "Rule 81.2");

    // Special cases (like in rule 51)
    XCTAssert(IBANtools.isValidAccount("0199100002", bankCode: "70090500", countryCode: "de").0, "Rule 81.3");
    XCTAssert(IBANtools.isValidAccount("0099100010", bankCode: "70090500", countryCode: "de").0, "Rule 81.4");
    XCTAssert(IBANtools.isValidAccount("2599100002", bankCode: "70090500", countryCode: "de").0, "Rule 81.5");
    XCTAssert(!IBANtools.isValidAccount("0099345678", bankCode: "70090500", countryCode: "de").0, "Rule 81.6"); // must fail
    XCTAssert(IBANtools.isValidAccount("0199100004", bankCode: "70090500", countryCode: "de").0, "Rule 81.7");
    XCTAssert(IBANtools.isValidAccount("2599100003", bankCode: "70090500", countryCode: "de").0, "Rule 81.8");
    XCTAssert(IBANtools.isValidAccount("3199204090", bankCode: "70090500", countryCode: "de").0, "Rule 81.9");
    XCTAssert(!IBANtools.isValidAccount("0099345678", bankCode: "70090500", countryCode: "de").0, "Rule 81.10"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0099100110", bankCode: "70090500", countryCode: "de").0, "Rule 81.11"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0199100040", bankCode: "70090500", countryCode: "de").0, "Rule 81.12"); // must fail
    
    // 82
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "11111121", countryCode: "de").0, "Rule 82.0");
    XCTAssert(IBANtools.isValidAccount("123897", bankCode: "11111121", countryCode: "de").0, "Rule 82.1");
    XCTAssert(IBANtools.isValidAccount("3199500501", bankCode: "11111121", countryCode: "de").0, "Rule 82.2");

    // 83
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "11111122", countryCode: "de").0, "Rule 83.0");
    XCTAssert(IBANtools.isValidAccount("0001156071", bankCode: "11111122", countryCode: "de").0, "Rule 83.1");
    XCTAssert(IBANtools.isValidAccount("0001156136", bankCode: "11111122", countryCode: "de").0, "Rule 83.2");
    XCTAssert(IBANtools.isValidAccount("0000156078", bankCode: "11111122", countryCode: "de").0, "Rule 83.3");
    XCTAssert(IBANtools.isValidAccount("0000156071", bankCode: "11111122", countryCode: "de").0, "Rule 83.4");
    XCTAssert(IBANtools.isValidAccount("0099100002", bankCode: "11111122", countryCode: "de").0, "Rule 83.5");

    // 84
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "72090500", countryCode: "de").0, "Rule 84.0");
    XCTAssert(IBANtools.isValidAccount("240699", bankCode: "72090500", countryCode: "de").0, "Rule 84.1");
    XCTAssert(IBANtools.isValidAccount("350982", bankCode: "72090500", countryCode: "de").0, "Rule 84.2");
    XCTAssert(IBANtools.isValidAccount("461059", bankCode: "72090500", countryCode: "de").0, "Rule 84.3");
    XCTAssert(!IBANtools.isValidAccount("240965", bankCode: "72090500", countryCode: "de").0, "Rule 84.4"); // must fail
    XCTAssert(!IBANtools.isValidAccount("350980", bankCode: "72090500", countryCode: "de").0, "Rule 84.5"); // must fail
    XCTAssert(!IBANtools.isValidAccount("461053", bankCode: "72090500", countryCode: "de").0, "Rule 84.6"); // must fail
    XCTAssert(IBANtools.isValidAccount("240692", bankCode: "72090500", countryCode: "de").0, "Rule 84.7");
    XCTAssert(IBANtools.isValidAccount("350985", bankCode: "72090500", countryCode: "de").0, "Rule 84.8");
    XCTAssert(IBANtools.isValidAccount("461052", bankCode: "72090500", countryCode: "de").0, "Rule 84.9");
    XCTAssert(!IBANtools.isValidAccount("240965", bankCode: "72090500", countryCode: "de").0, "Rule 84.10"); // must fail
    XCTAssert(!IBANtools.isValidAccount("350980", bankCode: "72090500", countryCode: "de").0, "Rule 84.11"); // must fail
    XCTAssert(!IBANtools.isValidAccount("461053", bankCode: "72090500", countryCode: "de").0, "Rule 84.12"); // must fail
    XCTAssert(IBANtools.isValidAccount("240961", bankCode: "72090500", countryCode: "de").0, "Rule 84.13");
    XCTAssert(IBANtools.isValidAccount("350984", bankCode: "72090500", countryCode: "de").0, "Rule 84.14");
    XCTAssert(IBANtools.isValidAccount("461054", bankCode: "72090500", countryCode: "de").0, "Rule 84.15");
    XCTAssert(!IBANtools.isValidAccount("240965", bankCode: "72090500", countryCode: "de").0, "Rule 84.16"); // must fail
    XCTAssert(!IBANtools.isValidAccount("350980", bankCode: "72090500", countryCode: "de").0, "Rule 84.17"); // must fail
    XCTAssert(!IBANtools.isValidAccount("461053", bankCode: "72090500", countryCode: "de").0, "Rule 84.18"); // must fail

    // Special cases (like in rule 51)
    XCTAssert(IBANtools.isValidAccount("0199100002", bankCode: "72090500", countryCode: "de").0, "Rule 84.3");
    XCTAssert(IBANtools.isValidAccount("0099100010", bankCode: "72090500", countryCode: "de").0, "Rule 84.4");
    XCTAssert(IBANtools.isValidAccount("2599100002", bankCode: "72090500", countryCode: "de").0, "Rule 84.5");
    XCTAssert(!IBANtools.isValidAccount("0099345678", bankCode: "72090500", countryCode: "de").0, "Rule 84.6"); // must fail
    XCTAssert(IBANtools.isValidAccount("0199100004", bankCode: "72090500", countryCode: "de").0, "Rule 84.7");
    XCTAssert(IBANtools.isValidAccount("2599100003", bankCode: "72090500", countryCode: "de").0, "Rule 84.8");
    XCTAssert(IBANtools.isValidAccount("3199204090", bankCode: "72090500", countryCode: "de").0, "Rule 84.9");
    XCTAssert(!IBANtools.isValidAccount("0099345678", bankCode: "72090500", countryCode: "de").0, "Rule 84.10"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0099100110", bankCode: "72090500", countryCode: "de").0, "Rule 84.11"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0199100040", bankCode: "72090500", countryCode: "de").0, "Rule 84.12"); // must fail

    // 85
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "40060560", countryCode: "de").0, "Rule 85.0");
    XCTAssert(IBANtools.isValidAccount("0001156071", bankCode: "40060560", countryCode: "de").0, "Rule 85.1");
    XCTAssert(IBANtools.isValidAccount("0001156136", bankCode: "40060560", countryCode: "de").0, "Rule 85.2");
    XCTAssert(IBANtools.isValidAccount("0000156078", bankCode: "40060560", countryCode: "de").0, "Rule 85.3");
    XCTAssert(IBANtools.isValidAccount("0000156071", bankCode: "40060560", countryCode: "de").0, "Rule 85.4");
    XCTAssert(IBANtools.isValidAccount("3199100002", bankCode: "40060560", countryCode: "de").0, "Rule 85.5");

    // 86
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "11111123", countryCode: "de").0, "Rule 84.0");
    XCTAssert(IBANtools.isValidAccount("340968", bankCode: "11111123", countryCode: "de").0, "Rule 84.1");
    XCTAssert(IBANtools.isValidAccount("1001171", bankCode: "11111123", countryCode: "de").0, "Rule 84.2");
    XCTAssert(IBANtools.isValidAccount("1009588", bankCode: "11111123", countryCode: "de").0, "Rule 84.3");
    XCTAssert(IBANtools.isValidAccount("123897", bankCode: "11111123", countryCode: "de").0, "Rule 84.4");
    XCTAssert(IBANtools.isValidAccount("340960", bankCode: "11111123", countryCode: "de").0, "Rule 84.5");

    // Special cases (like in rule 51)
    XCTAssert(IBANtools.isValidAccount("0199100002", bankCode: "11111123", countryCode: "de").0, "Rule 84.3");
    XCTAssert(IBANtools.isValidAccount("0099100010", bankCode: "11111123", countryCode: "de").0, "Rule 84.4");
    XCTAssert(IBANtools.isValidAccount("2599100002", bankCode: "11111123", countryCode: "de").0, "Rule 84.5");
    XCTAssert(!IBANtools.isValidAccount("0099345678", bankCode: "11111123", countryCode: "de").0, "Rule 84.6"); // must fail
    XCTAssert(IBANtools.isValidAccount("0199100004", bankCode: "11111123", countryCode: "de").0, "Rule 84.7");
    XCTAssert(IBANtools.isValidAccount("2599100003", bankCode: "11111123", countryCode: "de").0, "Rule 84.8");
    XCTAssert(IBANtools.isValidAccount("3199204090", bankCode: "11111123", countryCode: "de").0, "Rule 84.9");
    XCTAssert(!IBANtools.isValidAccount("0099345678", bankCode: "11111123", countryCode: "de").0, "Rule 84.10"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0099100110", bankCode: "11111123", countryCode: "de").0, "Rule 84.11"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0199100040", bankCode: "11111123", countryCode: "de").0, "Rule 84.12"); // must fail
    
    // 87
    XCTAssert(!IBANtools.isValidAccount("0", bankCode: "60090800", countryCode: "de").0, "Rule 84.0");

    XCTAssert(IBANtools.isValidAccount("0000000406", bankCode: "60090800", countryCode: "de").0, "Rule 84.1");
    XCTAssert(IBANtools.isValidAccount("0000051768", bankCode: "60090800", countryCode: "de").0, "Rule 84.2");
    XCTAssert(IBANtools.isValidAccount("0010701590", bankCode: "60090800", countryCode: "de").0, "Rule 84.3");
    XCTAssert(IBANtools.isValidAccount("0010720185", bankCode: "60090800", countryCode: "de").0, "Rule 84.4");

    XCTAssert(IBANtools.isValidAccount("0000100005", bankCode: "60090800", countryCode: "de").0, "Rule 84.5");
    XCTAssert(IBANtools.isValidAccount("0000393814", bankCode: "60090800", countryCode: "de").0, "Rule 84.6");
    XCTAssert(IBANtools.isValidAccount("0000950360", bankCode: "60090800", countryCode: "de").0, "Rule 84.7");
    XCTAssert(IBANtools.isValidAccount("3199500501", bankCode: "60090800", countryCode: "de").0, "Rule 84.8");

    // Special cases (like in rule 51)
    XCTAssert(IBANtools.isValidAccount("0199100002", bankCode: "60090800", countryCode: "de").0, "Rule 84.9");
    XCTAssert(IBANtools.isValidAccount("0099100010", bankCode: "60090800", countryCode: "de").0, "Rule 84.10");
    XCTAssert(IBANtools.isValidAccount("2599100002", bankCode: "60090800", countryCode: "de").0, "Rule 84.11");
    XCTAssert(!IBANtools.isValidAccount("0099345678", bankCode: "60090800", countryCode: "de").0, "Rule 84.12"); // must fail
    XCTAssert(IBANtools.isValidAccount("0199100004", bankCode: "60090800", countryCode: "de").0, "Rule 84.13");
    XCTAssert(IBANtools.isValidAccount("2599100003", bankCode: "60090800", countryCode: "de").0, "Rule 84.14");
    XCTAssert(IBANtools.isValidAccount("3199204090", bankCode: "60090800", countryCode: "de").0, "Rule 84.15");
    XCTAssert(!IBANtools.isValidAccount("0099345678", bankCode: "60090800", countryCode: "de").0, "Rule 84.16"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0099100110", bankCode: "60090800", countryCode: "de").0, "Rule 84.17"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0199100040", bankCode: "60090800", countryCode: "de").0, "Rule 84.18"); // must fail

    // 88
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "70090100", countryCode: "de").0, "Rule 88.0");
    XCTAssert(IBANtools.isValidAccount("2525259", bankCode: "70090100", countryCode: "de").0, "Rule 88.1");
    XCTAssert(IBANtools.isValidAccount("1000500", bankCode: "70090100", countryCode: "de").0, "Rule 88.2");
    XCTAssert(IBANtools.isValidAccount("90013000", bankCode: "70090100", countryCode: "de").0, "Rule 88.3");
    XCTAssert(IBANtools.isValidAccount("92525253", bankCode: "70090100", countryCode: "de").0, "Rule 88.4");
    XCTAssert(IBANtools.isValidAccount("99913003", bankCode: "70090100", countryCode: "de").0, "Rule 88.5");

    // 89
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "11111124", countryCode: "de").0, "Rule 89.0");
    XCTAssert(IBANtools.isValidAccount("1098506", bankCode: "11111124", countryCode: "de").0, "Rule 89.1");
    XCTAssert(IBANtools.isValidAccount("32028008", bankCode: "11111124", countryCode: "de").0, "Rule 89.2");
    XCTAssert(IBANtools.isValidAccount("218433000", bankCode: "11111124", countryCode: "de").0, "Rule 89.3");

    // 90
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "55090500", countryCode: "de").0, "Rule 90.0");
    XCTAssert(IBANtools.isValidAccount("0001975641", bankCode: "55090500", countryCode: "de").0, "Rule 90.1"); // method A
    XCTAssert(IBANtools.isValidAccount("0001988654", bankCode: "55090500", countryCode: "de").0, "Rule 90.2");
    XCTAssert(!IBANtools.isValidAccount("0001924592", bankCode: "55090500", countryCode: "de").0, "Rule 90.3"); // must fail
    XCTAssert(IBANtools.isValidAccount("0001863530", bankCode: "55090500", countryCode: "de").0, "Rule 90.4"); // method B
    XCTAssert(IBANtools.isValidAccount("0001784451", bankCode: "55090500", countryCode: "de").0, "Rule 90.5");
    XCTAssert(!IBANtools.isValidAccount("0000901568", bankCode: "55090500", countryCode: "de").0, "Rule 90.6"); // must fail
    XCTAssert(IBANtools.isValidAccount("0000654321", bankCode: "55090500", countryCode: "de").0, "Rule 90.7"); // method C
    XCTAssert(IBANtools.isValidAccount("0000824491", bankCode: "55090500", countryCode: "de").0, "Rule 90.8");
    XCTAssert(!IBANtools.isValidAccount("0000820487", bankCode: "55090500", countryCode: "de").0, "Rule 90.9"); // must fail
    XCTAssert(IBANtools.isValidAccount("0000677747", bankCode: "55090500", countryCode: "de").0, "Rule 90.10"); // method D
    XCTAssert(IBANtools.isValidAccount("0000840507", bankCode: "55090500", countryCode: "de").0, "Rule 90.11");
    XCTAssert(!IBANtools.isValidAccount("0000726393", bankCode: "55090500", countryCode: "de").0, "Rule 90.12"); // must fail
    XCTAssert(IBANtools.isValidAccount("0000996663", bankCode: "55090500", countryCode: "de").0, "Rule 90.13"); // method E
    XCTAssert(IBANtools.isValidAccount("0000666034", bankCode: "55090500", countryCode: "de").0, "Rule 90.14");
    XCTAssert(!IBANtools.isValidAccount("0000924591", bankCode: "55090500", countryCode: "de").0, "Rule 90.15"); // must fail
    XCTAssert(IBANtools.isValidAccount("0004923250", bankCode: "55090500", countryCode: "de").0, "Rule 90.16"); // method G
    XCTAssert(IBANtools.isValidAccount("0003865960", bankCode: "55090500", countryCode: "de").0, "Rule 90.17");
    XCTAssert(!IBANtools.isValidAccount("0003865964", bankCode: "55090500", countryCode: "de").0, "Rule 90.18"); // must fail
    XCTAssert(IBANtools.isValidAccount("0099100002", bankCode: "55090500", countryCode: "de").0, "Rule 90.19"); // method F
    XCTAssert(!IBANtools.isValidAccount("0099100007", bankCode: "55090500", countryCode: "de").0, "Rule 90.20"); // must fail

    // 91
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "57090900", countryCode: "de").0, "Rule 91.0");

    XCTAssert(IBANtools.isValidAccount("2974118000", bankCode: "57090900", countryCode: "de").0, "Rule 91.1");
    XCTAssert(IBANtools.isValidAccount("5281741000", bankCode: "57090900", countryCode: "de").0, "Rule 91.2");
    XCTAssert(IBANtools.isValidAccount("9952810000", bankCode: "57090900", countryCode: "de").0, "Rule 91.3");
    XCTAssert(!IBANtools.isValidAccount("8840017000", bankCode: "57090900", countryCode: "de").0, "Rule 91.4"); // must fail
    XCTAssert(!IBANtools.isValidAccount("8840023000", bankCode: "57090900", countryCode: "de").0, "Rule 91.5"); // must fail
    XCTAssert(!IBANtools.isValidAccount("8840041000", bankCode: "57090900", countryCode: "de").0, "Rule 91.6"); // must fail

    XCTAssert(IBANtools.isValidAccount("2974117000", bankCode: "57090900", countryCode: "de").0, "Rule 91.7");
    XCTAssert(IBANtools.isValidAccount("5281770000", bankCode: "57090900", countryCode: "de").0, "Rule 91.8");
    XCTAssert(IBANtools.isValidAccount("9952812000", bankCode: "57090900", countryCode: "de").0, "Rule 91.9");
    XCTAssert(!IBANtools.isValidAccount("8840014000", bankCode: "57090900", countryCode: "de").0, "Rule 91.10"); // must fail
    XCTAssert(!IBANtools.isValidAccount("8840026000", bankCode: "57090900", countryCode: "de").0, "Rule 91.11"); // must fail

    XCTAssert(IBANtools.isValidAccount("8840019000", bankCode: "57090900", countryCode: "de").0, "Rule 91.13");
    XCTAssert(IBANtools.isValidAccount("8840050000", bankCode: "57090900", countryCode: "de").0, "Rule 91.14");
    XCTAssert(IBANtools.isValidAccount("8840087000", bankCode: "57090900", countryCode: "de").0, "Rule 91.15");
    XCTAssert(IBANtools.isValidAccount("8840045000", bankCode: "57090900", countryCode: "de").0, "Rule 91.16");
    XCTAssert(!IBANtools.isValidAccount("8840011000", bankCode: "57090900", countryCode: "de").0, "Rule 91.17"); // must fail
    XCTAssert(!IBANtools.isValidAccount("8840025000", bankCode: "57090900", countryCode: "de").0, "Rule 91.18"); // must fail
    XCTAssert(!IBANtools.isValidAccount("8840062000", bankCode: "57090900", countryCode: "de").0, "Rule 91.19"); // must fail

    XCTAssert(IBANtools.isValidAccount("8840012000", bankCode: "57090900", countryCode: "de").0, "Rule 91.20");
    XCTAssert(IBANtools.isValidAccount("8840055000", bankCode: "57090900", countryCode: "de").0, "Rule 91.21");
    XCTAssert(IBANtools.isValidAccount("8840080000", bankCode: "57090900", countryCode: "de").0, "Rule 91.22");
    XCTAssert(!IBANtools.isValidAccount("8840010000", bankCode: "57090900", countryCode: "de").0, "Rule 91.23"); // must fail
    XCTAssert(!IBANtools.isValidAccount("8840057000", bankCode: "57090900", countryCode: "de").0, "Rule 91.24"); // must fail

    // 92 - not used and no test case yet

    // 93
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "11111125", countryCode: "de").0, "Rule 93.0");
    XCTAssert(IBANtools.isValidAccount("6714790000", bankCode: "11111125", countryCode: "de").0, "Rule 93.1");
    XCTAssert(IBANtools.isValidAccount("0000671479", bankCode: "11111125", countryCode: "de").0, "Rule 93.2");
    XCTAssert(IBANtools.isValidAccount("1277830000", bankCode: "11111125", countryCode: "de").0, "Rule 93.3");
    XCTAssert(IBANtools.isValidAccount("0000127783", bankCode: "11111125", countryCode: "de").0, "Rule 93.4");
    XCTAssert(IBANtools.isValidAccount("1277910000", bankCode: "11111125", countryCode: "de").0, "Rule 93.5");
    XCTAssert(IBANtools.isValidAccount("0000127791", bankCode: "11111125", countryCode: "de").0, "Rule 93.6");
    XCTAssert(IBANtools.isValidAccount("3067540000", bankCode: "11111125", countryCode: "de").0, "Rule 93.7");
    XCTAssert(IBANtools.isValidAccount("0000306754", bankCode: "11111125", countryCode: "de").0, "Rule 93.8");

    // 94
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "10120100", countryCode: "de").0, "Rule 94.0");
    XCTAssert(IBANtools.isValidAccount("6782533003", bankCode: "10120100", countryCode: "de").0, "Rule 94.1");

    // 95
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "70020270", countryCode: "de").0, "Rule 95.0");
    XCTAssert(IBANtools.isValidAccount("0068007003", bankCode: "70020270", countryCode: "de").0, "Rule 95.1");
    XCTAssert(IBANtools.isValidAccount("0847321750", bankCode: "70020270", countryCode: "de").0, "Rule 95.2");
    XCTAssert(IBANtools.isValidAccount("6450060494", bankCode: "70020270", countryCode: "de").0, "Rule 95.3");
    XCTAssert(IBANtools.isValidAccount("6454000003", bankCode: "70020270", countryCode: "de").0, "Rule 95.4");
    XCTAssert(IBANtools.isValidAccount("0000000001", bankCode: "70020270", countryCode: "de").0, "Rule 95.5");
    XCTAssert(IBANtools.isValidAccount("0009000000", bankCode: "70020270", countryCode: "de").0, "Rule 95.6");
    XCTAssert(IBANtools.isValidAccount("0396000000", bankCode: "70020270", countryCode: "de").0, "Rule 95.7");
    XCTAssert(IBANtools.isValidAccount("0700000000", bankCode: "70020270", countryCode: "de").0, "Rule 95.8");
    XCTAssert(IBANtools.isValidAccount("0910000000", bankCode: "70020270", countryCode: "de").0, "Rule 95.9");

    // 96
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "50050201", countryCode: "de").0, "Rule 96.0");
    XCTAssert(IBANtools.isValidAccount("0000254100", bankCode: "50050201", countryCode: "de").0, "Rule 96.1");
    XCTAssert(IBANtools.isValidAccount("9421000009", bankCode: "50050201", countryCode: "de").0, "Rule 96.2");
    XCTAssert(IBANtools.isValidAccount("0000000208", bankCode: "50050201", countryCode: "de").0, "Rule 96.3");
    XCTAssert(IBANtools.isValidAccount("0101115152", bankCode: "50050201", countryCode: "de").0, "Rule 96.4");
    XCTAssert(IBANtools.isValidAccount("0301204301", bankCode: "50050201", countryCode: "de").0, "Rule 96.5");
    XCTAssert(IBANtools.isValidAccount("0001300000", bankCode: "50050201", countryCode: "de").0, "Rule 96.6");

    // 97
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "11111126", countryCode: "de").0, "Rule 97.0");
    XCTAssert(IBANtools.isValidAccount("2 4 0 1 0 0 1 9", bankCode: "11111126", countryCode: "de").0, "Rule 97.1");

    // 98
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "74290100", countryCode: "de").0, "Rule 98.0");
    XCTAssert(IBANtools.isValidAccount("9619439213", bankCode: "74290100", countryCode: "de").0, "Rule 98.1");
    XCTAssert(IBANtools.isValidAccount("3009800016", bankCode: "74290100", countryCode: "de").0, "Rule 98.2");
    XCTAssert(IBANtools.isValidAccount("9619509976", bankCode: "74290100", countryCode: "de").0, "Rule 98.3");
    XCTAssert(IBANtools.isValidAccount("9619319999", bankCode: "74290100", countryCode: "de").0, "Rule 98.4");
    XCTAssert(IBANtools.isValidAccount("9619319999", bankCode: "74290100", countryCode: "de").0, "Rule 98.5");
    XCTAssert(IBANtools.isValidAccount("6719430018", bankCode: "74290100", countryCode: "de").0, "Rule 98.6");

    // 99
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "74320073", countryCode: "de").0, "Rule 99.0");
    XCTAssert(IBANtools.isValidAccount("0068007003", bankCode: "74320073", countryCode: "de").0, "Rule 99.1");
    XCTAssert(IBANtools.isValidAccount("0847321750", bankCode: "74320073", countryCode: "de").0, "Rule 99.2");
    XCTAssert(IBANtools.isValidAccount("0396000000", bankCode: "74320073", countryCode: "de").0, "Rule 99.3");

    // A0
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "11111127", countryCode: "de").0, "Rule A0.0");
    XCTAssert(IBANtools.isValidAccount("521003287", bankCode: "11111127", countryCode: "de").0, "Rule A0.1");
    XCTAssert(IBANtools.isValidAccount("54500", bankCode: "11111127", countryCode: "de").0, "Rule A0.2");
    XCTAssert(IBANtools.isValidAccount("3287", bankCode: "11111127", countryCode: "de").0, "Rule A0.3");
    XCTAssert(IBANtools.isValidAccount("18761", bankCode: "11111127", countryCode: "de").0, "Rule A0.4");
    XCTAssert(IBANtools.isValidAccount("28290", bankCode: "11111127", countryCode: "de").0, "Rule A0.5");
    XCTAssert(!IBANtools.isValidAccount("42", bankCode: "11111127", countryCode: "de").0, "Rule A0.6"); // Must fail
    XCTAssert(IBANtools.isValidAccount("142", bankCode: "11111127", countryCode: "de").0, "Rule A0.6");

    // A1
    XCTAssert(!IBANtools.isValidAccount("0", bankCode: "73362500", countryCode: "de").0, "Rule A1.0");
    XCTAssert(IBANtools.isValidAccount("0010030005", bankCode: "73362500", countryCode: "de").0, "Rule A1.1");
    XCTAssert(IBANtools.isValidAccount("0010030997", bankCode: "73362500", countryCode: "de").0, "Rule A1.2");
    XCTAssert(IBANtools.isValidAccount("1010030054", bankCode: "73362500", countryCode: "de").0, "Rule A1.3");
    XCTAssert(!IBANtools.isValidAccount("0110030005", bankCode: "73362500", countryCode: "de").0, "Rule A1.4"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0010030998", bankCode: "73362500", countryCode: "de").0, "Rule A1.5"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0000030005", bankCode: "73362500", countryCode: "de").0, "Rule A1.6"); // must fail

    // A2
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "21051275", countryCode: "de").0, "Rule A2.0");
    XCTAssert(IBANtools.isValidAccount("3456789019", bankCode: "21051275", countryCode: "de").0, "Rule A2.1");
    XCTAssert(IBANtools.isValidAccount("5678901231", bankCode: "21051275", countryCode: "de").0, "Rule A2.2");
    XCTAssert(IBANtools.isValidAccount("6789012348", bankCode: "21051275", countryCode: "de").0, "Rule A2.3");
    XCTAssert(IBANtools.isValidAccount("3456789012", bankCode: "21051275", countryCode: "de").0, "Rule A2.4");
    XCTAssert(!IBANtools.isValidAccount("1234567890", bankCode: "21051275", countryCode: "de").0, "Rule A2.5"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0123456789", bankCode: "21051275", countryCode: "de").0, "Rule A2.6"); // must fail

    // A3
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "25050180", countryCode: "de").0, "Rule A3.0");
    XCTAssert(IBANtools.isValidAccount("1234567897", bankCode: "25050180", countryCode: "de").0, "Rule A3.1");
    XCTAssert(IBANtools.isValidAccount("0123456782", bankCode: "25050180", countryCode: "de").0, "Rule A3.2");
    XCTAssert(!IBANtools.isValidAccount("6543217890", bankCode: "25050180", countryCode: "de").0, "Rule A3.5"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0543216789", bankCode: "25050180", countryCode: "de").0, "Rule A3.6"); // must fail
    XCTAssert(IBANtools.isValidAccount("9876543210", bankCode: "25050180", countryCode: "de").0, "Rule A3.7");
    XCTAssert(IBANtools.isValidAccount("1234567890", bankCode: "25050180", countryCode: "de").0, "Rule A3.8");
    XCTAssert(IBANtools.isValidAccount("0123456789", bankCode: "25050180", countryCode: "de").0, "Rule A3.9");
    XCTAssert(!IBANtools.isValidAccount("6543217890", bankCode: "25050180", countryCode: "de").0, "Rule A3.10"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0543216789", bankCode: "25050180", countryCode: "de").0, "Rule A3.11"); // must fail

    // A4
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "25090608", countryCode: "de").0, "Rule A4.0");

    XCTAssert(IBANtools.isValidAccount("0004711173", bankCode: "25090608", countryCode: "de").0, "Rule A4.1");
    XCTAssert(IBANtools.isValidAccount("0007093330", bankCode: "25090608", countryCode: "de").0, "Rule A4.2");
    XCTAssert(!IBANtools.isValidAccount("8623420004,", bankCode: "25090608", countryCode: "de").0, "Rule A4.3"); // must fail

    XCTAssert(IBANtools.isValidAccount("0004711172", bankCode: "25090608", countryCode: "de").0, "Rule A4.4");
    XCTAssert(IBANtools.isValidAccount("0007093335", bankCode: "25090608", countryCode: "de").0, "Rule A4.5");
    XCTAssert(!IBANtools.isValidAccount("8623420000,", bankCode: "25090608", countryCode: "de").0, "Rule A4.6"); // must fail

    XCTAssert(IBANtools.isValidAccount("1199503010", bankCode: "25090608", countryCode: "de").0, "Rule A4.7");
    XCTAssert(IBANtools.isValidAccount("8499421235", bankCode: "25090608", countryCode: "de").0, "Rule A4.8");

    XCTAssert(IBANtools.isValidAccount("6099702031", bankCode: "25090608", countryCode: "de").0, "Rule A4.9");
    XCTAssert(IBANtools.isValidAccount("0000862342", bankCode: "25090608", countryCode: "de").0, "Rule A4.10");
    XCTAssert(IBANtools.isValidAccount("8997710000", bankCode: "25090608", countryCode: "de").0, "Rule A4.11");
    XCTAssert(IBANtools.isValidAccount("0664040000", bankCode: "25090608", countryCode: "de").0, "Rule A4.12");
    XCTAssert(IBANtools.isValidAccount("0000905844", bankCode: "25090608", countryCode: "de").0, "Rule A4.13");
    XCTAssert(IBANtools.isValidAccount("5030101099", bankCode: "25090608", countryCode: "de").0, "Rule A4.14");
    XCTAssert(IBANtools.isValidAccount("0001123458", bankCode: "25090608", countryCode: "de").0, "Rule A4.15");
    XCTAssert(IBANtools.isValidAccount("1299503117", bankCode: "25090608", countryCode: "de").0, "Rule A4.16");
    XCTAssert(!IBANtools.isValidAccount("0000399443", bankCode: "25090608", countryCode: "de").0, "Rule A4.17"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0000553313", bankCode: "25090608", countryCode: "de").0, "Rule A4.18"); // must fail

    // A5
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "76450000", countryCode: "de").0, "Rule A5.0");

    XCTAssert(IBANtools.isValidAccount("9941510001", bankCode: "76450000", countryCode: "de").0, "Rule A5.1");
    XCTAssert(IBANtools.isValidAccount("9961230019", bankCode: "76450000", countryCode: "de").0, "Rule A5.2");
    XCTAssert(IBANtools.isValidAccount("9380027210", bankCode: "76450000", countryCode: "de").0, "Rule A5.3");
    XCTAssert(IBANtools.isValidAccount("9932290910", bankCode: "76450000", countryCode: "de").0, "Rule A5.4");
    XCTAssert(!IBANtools.isValidAccount("9941510002,", bankCode: "76450000", countryCode: "de").0, "Rule A5.5"); // must fail
    XCTAssert(!IBANtools.isValidAccount("9961230020,", bankCode: "76450000", countryCode: "de").0, "Rule A5.6"); // must fail

    XCTAssert(IBANtools.isValidAccount("0000251437", bankCode: "76450000", countryCode: "de").0, "Rule A5.7");
    XCTAssert(IBANtools.isValidAccount("0007948344", bankCode: "76450000", countryCode: "de").0, "Rule A5.8");
    XCTAssert(IBANtools.isValidAccount("0000159590", bankCode: "76450000", countryCode: "de").0, "Rule A5.9");
    XCTAssert(IBANtools.isValidAccount("0000051640", bankCode: "76450000", countryCode: "de").0, "Rule A5.10");
    XCTAssert(!IBANtools.isValidAccount("0000251438", bankCode: "76450000", countryCode: "de").0, "Rule A5.11"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0007948345", bankCode: "76450000", countryCode: "de").0, "Rule A5.12"); // must fail

    // A6
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "11111128", countryCode: "de").0, "Rule A6.0");

    XCTAssert(IBANtools.isValidAccount("800048548", bankCode: "11111128", countryCode: "de").0, "Rule A6.1");
    XCTAssert(IBANtools.isValidAccount("0855000014", bankCode: "11111128", countryCode: "de").0, "Rule A6.2");
    XCTAssert(!IBANtools.isValidAccount("860000817,", bankCode: "11111128", countryCode: "de").0, "Rule A6.3"); // must fail
    XCTAssert(!IBANtools.isValidAccount("810033652,", bankCode: "11111128", countryCode: "de").0, "Rule A6.4"); // must fail

    XCTAssert(IBANtools.isValidAccount("17", bankCode: "11111128", countryCode: "de").0, "Rule A6.5");
    XCTAssert(IBANtools.isValidAccount("55300030", bankCode: "11111128", countryCode: "de").0, "Rule A6.6");
    XCTAssert(IBANtools.isValidAccount("150178033", bankCode: "11111128", countryCode: "de").0, "Rule A6.7");
    XCTAssert(IBANtools.isValidAccount("600003555", bankCode: "11111128", countryCode: "de").0, "Rule A6.8");
    XCTAssert(IBANtools.isValidAccount("900291823", bankCode: "11111128", countryCode: "de").0, "Rule A6.9");
    XCTAssert(!IBANtools.isValidAccount("305888", bankCode: "11111128", countryCode: "de").0, "Rule A6.10"); // must fail
    XCTAssert(!IBANtools.isValidAccount("200071280", bankCode: "11111128", countryCode: "de").0, "Rule A6.11"); // must fail

    // A7
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "11111129", countryCode: "de").0, "Rule A7.0");

    XCTAssert(IBANtools.isValidAccount("19010008", bankCode: "11111129", countryCode: "de").0, "Rule A7.1");
    XCTAssert(IBANtools.isValidAccount("19010438", bankCode: "11111129", countryCode: "de").0, "Rule A7.2");
    XCTAssert(!IBANtools.isValidAccount("209010892,", bankCode: "11111129", countryCode: "de").0, "Rule A7.3"); // must fail
    XCTAssert(!IBANtools.isValidAccount("209010893,", bankCode: "11111129", countryCode: "de").0, "Rule A7.4"); // must fail

    XCTAssert(IBANtools.isValidAccount("19010660", bankCode: "11111129", countryCode: "de").0, "Rule A7.5");
    XCTAssert(IBANtools.isValidAccount("19010876", bankCode: "11111129", countryCode: "de").0, "Rule A7.6");
    XCTAssert(IBANtools.isValidAccount("209010892", bankCode: "11111129", countryCode: "de").0, "Rule A7.7");
    XCTAssert(!IBANtools.isValidAccount("209010893", bankCode: "11111129", countryCode: "de").0, "Rule A7.8"); // must fail

    // A8
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "11111130", countryCode: "de").0, "Rule A8.0");

    XCTAssert(IBANtools.isValidAccount("7436661", bankCode: "11111130", countryCode: "de").0, "Rule A8.1");
    XCTAssert(IBANtools.isValidAccount("7436670", bankCode: "11111130", countryCode: "de").0, "Rule A8.2");
    XCTAssert(IBANtools.isValidAccount("1359100", bankCode: "11111130", countryCode: "de").0, "Rule A8.3");

    XCTAssert(IBANtools.isValidAccount("7436660", bankCode: "11111130", countryCode: "de").0, "Rule A8.6");
    XCTAssert(IBANtools.isValidAccount("7436678", bankCode: "11111130", countryCode: "de").0, "Rule A8.7");
    XCTAssert(IBANtools.isValidAccount("0003503398", bankCode: "11111130", countryCode: "de").0, "Rule A8.8");
    XCTAssert(IBANtools.isValidAccount("0001340967", bankCode: "11111130", countryCode: "de").0, "Rule A8.9");
    XCTAssert(!IBANtools.isValidAccount("7436666", bankCode: "11111130", countryCode: "de").0, "Rule A8.10"); // must fail
    XCTAssert(!IBANtools.isValidAccount("7436677", bankCode: "11111130", countryCode: "de").0, "Rule A8.11"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0003503391", bankCode: "11111130", countryCode: "de").0, "Rule A8.12"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0001340966", bankCode: "11111130", countryCode: "de").0, "Rule A8.13"); // must fail

    // Special cases (like in rule 51)
    XCTAssert(IBANtools.isValidAccount("0199100002", bankCode: "11111130", countryCode: "de").0, "Rule A8.14");
    XCTAssert(IBANtools.isValidAccount("0099100010", bankCode: "11111130", countryCode: "de").0, "Rule A8.15");
    XCTAssert(IBANtools.isValidAccount("2599100002", bankCode: "11111130", countryCode: "de").0, "Rule A8.16");
    XCTAssert(!IBANtools.isValidAccount("0099345678", bankCode: "11111130", countryCode: "de").0, "Rule A8.17"); // must fail
    XCTAssert(IBANtools.isValidAccount("0199100004", bankCode: "11111130", countryCode: "de").0, "Rule A8.18");
    XCTAssert(IBANtools.isValidAccount("2599100003", bankCode: "11111130", countryCode: "de").0, "Rule A8.19");
    XCTAssert(IBANtools.isValidAccount("3199204090", bankCode: "11111130", countryCode: "de").0, "Rule A8.20");
    XCTAssert(!IBANtools.isValidAccount("0099345678", bankCode: "11111130", countryCode: "de").0, "Rule A8.21"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0099100110", bankCode: "11111130", countryCode: "de").0, "Rule A8.22"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0199100040", bankCode: "11111130", countryCode: "de").0, "Rule A8.23"); // must fail

    // A9
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "11111131", countryCode: "de").0, "Rule A9.0");

    XCTAssert(IBANtools.isValidAccount("5043608", bankCode: "11111131", countryCode: "de").0, "Rule A9.1");
    XCTAssert(IBANtools.isValidAccount("86725", bankCode: "11111131", countryCode: "de").0, "Rule A9.2");
    XCTAssert(!IBANtools.isValidAccount("86724,", bankCode: "11111131", countryCode: "de").0, "Rule A9.3"); // must fail

    XCTAssert(IBANtools.isValidAccount("504360", bankCode: "11111131", countryCode: "de").0, "Rule A9.4");
    XCTAssert(IBANtools.isValidAccount("822035", bankCode: "11111131", countryCode: "de").0, "Rule A9.5");
    XCTAssert(IBANtools.isValidAccount("32577083", bankCode: "11111131", countryCode: "de").0, "Rule A9.6");
    XCTAssert(!IBANtools.isValidAccount("86724", bankCode: "11111131", countryCode: "de").0, "Rule A9.7"); // must fail
    XCTAssert(!IBANtools.isValidAccount("292497", bankCode: "11111131", countryCode: "de").0, "Rule A9.8"); // must fail
    XCTAssert(!IBANtools.isValidAccount("30767208", bankCode: "11111131", countryCode: "de").0, "Rule A9.9"); // must fail

    // B0
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "11111131", countryCode: "de").0, "Rule B0.0");

    XCTAssert(IBANtools.isValidAccount("1197423162", bankCode: "11111132", countryCode: "de").0, "Rule B0.1");
    XCTAssert(IBANtools.isValidAccount("1000000606", bankCode: "11111132", countryCode: "de").0, "Rule B0.2");
    XCTAssert(!IBANtools.isValidAccount("600000606,", bankCode: "11111132", countryCode: "de").0, "Rule B0.4"); // must fail

    XCTAssert(IBANtools.isValidAccount("1000000406", bankCode: "11111132", countryCode: "de").0, "Rule B0.6");
    XCTAssert(IBANtools.isValidAccount("1035791538", bankCode: "11111132", countryCode: "de").0, "Rule B0.7");
    XCTAssert(IBANtools.isValidAccount("1126939724", bankCode: "11111132", countryCode: "de").0, "Rule B0.8");
    XCTAssert(IBANtools.isValidAccount("1197423460", bankCode: "11111132", countryCode: "de").0, "Rule B0.9");
    XCTAssert(!IBANtools.isValidAccount("1000000405", bankCode: "11111132", countryCode: "de").0, "Rule B0.10"); // must fail
    XCTAssert(!IBANtools.isValidAccount("1035791539", bankCode: "11111132", countryCode: "de").0, "Rule B0.11"); // must fail

    // B1
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "25950001", countryCode: "de").0, "Rule B1.0");

    XCTAssert(IBANtools.isValidAccount("1434253150", bankCode: "25950001", countryCode: "de").0, "Rule B1.1");
    XCTAssert(IBANtools.isValidAccount("2746315471", bankCode: "25950001", countryCode: "de").0, "Rule B1.2");
    XCTAssert(!IBANtools.isValidAccount("7414398260,", bankCode: "25950001", countryCode: "de").0, "Rule B1.3"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0123456789", bankCode: "25950001", countryCode: "de").0, "Rule B1.5"); // must fail
    XCTAssert(!IBANtools.isValidAccount("2345678901,", bankCode: "25950001", countryCode: "de").0, "Rule B1.6"); // must fail
    XCTAssert(!IBANtools.isValidAccount("5678901234,", bankCode: "25950001", countryCode: "de").0, "Rule B1.7"); // must fail

    XCTAssert(IBANtools.isValidAccount("7414398260", bankCode: "25950001", countryCode: "de").0, "Rule B1.8");
    XCTAssert(IBANtools.isValidAccount("8347251693", bankCode: "25950001", countryCode: "de").0, "Rule B1.9");
    XCTAssert(!IBANtools.isValidAccount("0123456789", bankCode: "25950001", countryCode: "de").0, "Rule B1.10"); // must fail
    XCTAssert(!IBANtools.isValidAccount("2345678901", bankCode: "25950001", countryCode: "de").0, "Rule B1.11"); // must fail
    XCTAssert(!IBANtools.isValidAccount("5678901234", bankCode: "25950001", countryCode: "de").0, "Rule B1.12"); // must fail

    // B2
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "54051660", countryCode: "de").0, "Rule B2.0");

    XCTAssert(IBANtools.isValidAccount("0020012357", bankCode: "54051660", countryCode: "de").0, "Rule B2.1");
    XCTAssert(IBANtools.isValidAccount("0080012345", bankCode: "54051660", countryCode: "de").0, "Rule B2.2");
    XCTAssert(IBANtools.isValidAccount("0926801910", bankCode: "54051660", countryCode: "de").0, "Rule B2.3");
    XCTAssert(IBANtools.isValidAccount("1002345674", bankCode: "54051660", countryCode: "de").0, "Rule B2.4");
    XCTAssert(!IBANtools.isValidAccount("0020012399", bankCode: "54051660", countryCode: "de").0, "Rule B2.5"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0080012347", bankCode: "54051660", countryCode: "de").0, "Rule B2.6"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0080012370,", bankCode: "54051660", countryCode: "de").0, "Rule B2.7"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0932100027,", bankCode: "54051660", countryCode: "de").0, "Rule B2.8"); // must fail
    XCTAssert(!IBANtools.isValidAccount("3310123454,", bankCode: "54051660", countryCode: "de").0, "Rule B2.9"); // must fail

    XCTAssert(IBANtools.isValidAccount("8000990054", bankCode: "54051660", countryCode: "de").0, "Rule B2.10");
    XCTAssert(IBANtools.isValidAccount("9000481805", bankCode: "54051660", countryCode: "de").0, "Rule B2.11");
    XCTAssert(!IBANtools.isValidAccount("8000990057", bankCode: "54051660", countryCode: "de").0, "Rule B2.12"); // must fail
    XCTAssert(!IBANtools.isValidAccount("8011000126", bankCode: "54051660", countryCode: "de").0, "Rule B2.13"); // must fail
    XCTAssert(!IBANtools.isValidAccount("9000481800", bankCode: "54051660", countryCode: "de").0, "Rule B2.14"); // must fail
    XCTAssert(!IBANtools.isValidAccount("9980480111", bankCode: "54051660", countryCode: "de").0, "Rule B2.15"); // must fail

    // B3
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "66090800", countryCode: "de").0, "Rule B3.0");

    XCTAssert(IBANtools.isValidAccount("1000000060", bankCode: "66090800", countryCode: "de").0, "Rule B3.1");
    XCTAssert(IBANtools.isValidAccount("0000000140", bankCode: "66090800", countryCode: "de").0, "Rule B3.2");
    XCTAssert(IBANtools.isValidAccount("0000000019", bankCode: "66090800", countryCode: "de").0, "Rule B3.3");
    XCTAssert(IBANtools.isValidAccount("1002798417", bankCode: "66090800", countryCode: "de").0, "Rule B3.4");
    XCTAssert(IBANtools.isValidAccount("8409915001", bankCode: "66090800", countryCode: "de").0, "Rule B3.5");
    XCTAssert(!IBANtools.isValidAccount("0002799899", bankCode: "66090800", countryCode: "de").0, "Rule B3.6"); // must fail
    XCTAssert(!IBANtools.isValidAccount("1000000111", bankCode: "66090800", countryCode: "de").0, "Rule B3.7"); // must fail

    XCTAssert(IBANtools.isValidAccount("9635000101", bankCode: "66090800", countryCode: "de").0, "Rule B3.8");
    XCTAssert(IBANtools.isValidAccount("9730200100", bankCode: "66090800", countryCode: "de").0, "Rule B3.9");
    XCTAssert(!IBANtools.isValidAccount("9635100101", bankCode: "66090800", countryCode: "de").0, "Rule B3.10"); // must fail
    XCTAssert(!IBANtools.isValidAccount("9730300100", bankCode: "66090800", countryCode: "de").0, "Rule B3.11"); // must fail

    // B4
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "11111133", countryCode: "de").0, "Rule B4.0");

    XCTAssert(IBANtools.isValidAccount("9941510001", bankCode: "11111133", countryCode: "de").0, "Rule B4.1");
    XCTAssert(IBANtools.isValidAccount("9961230019", bankCode: "11111133", countryCode: "de").0, "Rule B4.2");
    XCTAssert(IBANtools.isValidAccount("9380027210", bankCode: "11111133", countryCode: "de").0, "Rule B4.3");
    XCTAssert(IBANtools.isValidAccount("9932290910", bankCode: "11111133", countryCode: "de").0, "Rule B4.4");
    XCTAssert(!IBANtools.isValidAccount("9941510002", bankCode: "11111133", countryCode: "de").0, "Rule B4.5"); // must fail
    XCTAssert(!IBANtools.isValidAccount("9961230020", bankCode: "11111133", countryCode: "de").0, "Rule B4.6"); // must fail

    XCTAssert(IBANtools.isValidAccount("0000251437", bankCode: "11111133", countryCode: "de").0, "Rule B4.7");
    XCTAssert(IBANtools.isValidAccount("0007948344", bankCode: "11111133", countryCode: "de").0, "Rule B4.8");
    XCTAssert(IBANtools.isValidAccount("0000051640", bankCode: "11111133", countryCode: "de").0, "Rule B4.9");
    XCTAssert(!IBANtools.isValidAccount("0000251438", bankCode: "11111133", countryCode: "de").0, "Rule B4.10"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0007948345", bankCode: "11111133", countryCode: "de").0, "Rule B4.11"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0000159590", bankCode: "11111133", countryCode: "de").0, "Rule B4.12"); // must fail

    // B5
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "37050299", countryCode: "de").0, "Rule B5.0");

    XCTAssert(IBANtools.isValidAccount("0159006955", bankCode: "37050299", countryCode: "de").0, "Rule B5.1");
    XCTAssert(IBANtools.isValidAccount("2000123451", bankCode: "37050299", countryCode: "de").0, "Rule B5.2");
    XCTAssert(IBANtools.isValidAccount("1151043216", bankCode: "37050299", countryCode: "de").0, "Rule B5.3");
    XCTAssert(IBANtools.isValidAccount("9000939033", bankCode: "37050299", countryCode: "de").0, "Rule B5.4");
    XCTAssert(!IBANtools.isValidAccount("7414398260", bankCode: "37050299", countryCode: "de").0, "Rule B5.5"); // must fail
    XCTAssert(!IBANtools.isValidAccount("8347251693", bankCode: "37050299", countryCode: "de").0, "Rule B5.6"); // must fail
    XCTAssert(!IBANtools.isValidAccount("2345678901", bankCode: "37050299", countryCode: "de").0, "Rule B5.8"); // must fail
    XCTAssert(!IBANtools.isValidAccount("5678901234", bankCode: "37050299", countryCode: "de").0, "Rule B5.9"); // must fail
    XCTAssert(!IBANtools.isValidAccount("9000293707", bankCode: "37050299", countryCode: "de").0, "Rule B5.10"); // must fail

    XCTAssert(IBANtools.isValidAccount("0123456782", bankCode: "37050299", countryCode: "de").0, "Rule B5.11");
    XCTAssert(IBANtools.isValidAccount("0130098767", bankCode: "37050299", countryCode: "de").0, "Rule B5.12");
    XCTAssert(IBANtools.isValidAccount("1045000252", bankCode: "37050299", countryCode: "de").0, "Rule B5.13");
    XCTAssert(!IBANtools.isValidAccount("0159004165", bankCode: "37050299", countryCode: "de").0, "Rule B5.14"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0023456787", bankCode: "37050299", countryCode: "de").0, "Rule B5.15"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0056789018", bankCode: "37050299", countryCode: "de").0, "Rule B5.16"); // must fail
    XCTAssert(!IBANtools.isValidAccount("3045000333", bankCode: "37050299", countryCode: "de").0, "Rule B6.17"); // must fail

    // B6
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "80053762", countryCode: "de").0, "Rule B6.0");

    XCTAssert(IBANtools.isValidAccount("9110000000", bankCode: "80053762", countryCode: "de").0, "Rule B6.1");
    XCTAssert(IBANtools.isValidAccount("0269876545", bankCode: "80053762", countryCode: "de").0, "Rule B6.2");
    XCTAssert(!IBANtools.isValidAccount("9111000000", bankCode: "80053762", countryCode: "de").0, "Rule B6.35"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0269456780", bankCode: "80053762", countryCode: "de").0, "Rule B6.4"); // must fail

    XCTAssert(IBANtools.isValidAccount("487310018", bankCode: "80053782", countryCode: "de").0, "Rule B6.5");
    XCTAssert(!IBANtools.isValidAccount("477310018", bankCode: "80053762", countryCode: "de").0, "Rule B6.6"); // must fail

    // B7
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "50010700", countryCode: "de").0, "Rule B7.0");

    XCTAssert(IBANtools.isValidAccount("0700001529", bankCode: "50010700", countryCode: "de").0, "Rule B7.1");
    XCTAssert(IBANtools.isValidAccount("0730000019", bankCode: "50010700", countryCode: "de").0, "Rule B7.2");
    XCTAssert(IBANtools.isValidAccount("0001001008", bankCode: "50010700", countryCode: "de").0, "Rule B7.3");
    XCTAssert(IBANtools.isValidAccount("0001057887", bankCode: "50010700", countryCode: "de").0, "Rule B7.4");
    XCTAssert(IBANtools.isValidAccount("0001007222", bankCode: "50010700", countryCode: "de").0, "Rule B7.5");
    XCTAssert(IBANtools.isValidAccount("0810011825", bankCode: "50010700", countryCode: "de").0, "Rule B7.6");
    XCTAssert(IBANtools.isValidAccount("0800107653", bankCode: "50010700", countryCode: "de").0, "Rule B7.7");
    XCTAssert(IBANtools.isValidAccount("0005922372", bankCode: "50010700", countryCode: "de").0, "Rule B7.8");
    XCTAssert(IBANtools.isValidAccount("0006000000", bankCode: "50010700", countryCode: "de").0, "Rule B7.9");
    XCTAssert(!IBANtools.isValidAccount("0001057886", bankCode: "50010700", countryCode: "de").0, "Rule B7.10"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0003815570", bankCode: "50010700", countryCode: "de").0, "Rule B7.11"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0005620516", bankCode: "50010700", countryCode: "de").0, "Rule B7.12"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0740912243", bankCode: "50010700", countryCode: "de").0, "Rule B7.13"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0893524479", bankCode: "50010700", countryCode: "de").0, "Rule B7.14"); // must fail
    
    // B8
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "10050000", countryCode: "de").0, "Rule B8.0");

    XCTAssert(IBANtools.isValidAccount("0734192657", bankCode: "10050000", countryCode: "de").0, "Rule B8.1");
    XCTAssert(IBANtools.isValidAccount("6932875274", bankCode: "10050000", countryCode: "de").0, "Rule B8.2");
    XCTAssert(IBANtools.isValidAccount("5011654366", bankCode: "10050000", countryCode: "de").0, "Rule B8.3");
    XCTAssert(!IBANtools.isValidAccount("0132572975", bankCode: "10050000", countryCode: "de").0, "Rule B8.5"); // must fail
    XCTAssert(!IBANtools.isValidAccount("9000412340", bankCode: "10050000", countryCode: "de").0, "Rule B8.9"); // must fail
    XCTAssert(!IBANtools.isValidAccount("9310305011", bankCode: "10050000", countryCode: "de").0, "Rule B8.10"); // must fail
    XCTAssert(IBANtools.isValidAccount("3145863029", bankCode: "10050000", countryCode: "de").0, "Rule B8.11");
    XCTAssert(IBANtools.isValidAccount("2938692523", bankCode: "10050000", countryCode: "de").0, "Rule B8.12");
    XCTAssert(IBANtools.isValidAccount("5432198760", bankCode: "10050000", countryCode: "de").0, "Rule B8.13");
    XCTAssert(IBANtools.isValidAccount("9070873333", bankCode: "10050000", countryCode: "de").0, "Rule B8.14");
    XCTAssert(!IBANtools.isValidAccount("0132572975", bankCode: "10050000", countryCode: "de").0, "Rule B8.15"); // must fail
    XCTAssert(!IBANtools.isValidAccount("9000412340", bankCode: "10050000", countryCode: "de").0, "Rule B8.16"); // must fail
    XCTAssert(!IBANtools.isValidAccount("9310305011", bankCode: "10050000", countryCode: "de").0, "Rule B8.17"); // must fail

    // B9
    XCTAssert(!IBANtools.isValidAccount("0", bankCode: "11111134", countryCode: "de").0, "Rule B9.0");

    XCTAssert(IBANtools.isValidAccount("87920187", bankCode: "11111134", countryCode: "de").0, "Rule B9.1");
    XCTAssert(IBANtools.isValidAccount("41203755", bankCode: "11111134", countryCode: "de").0, "Rule B9.2");
    XCTAssert(IBANtools.isValidAccount("81069577", bankCode: "11111134", countryCode: "de").0, "Rule B9.3");
    XCTAssert(IBANtools.isValidAccount("61287958", bankCode: "11111134", countryCode: "de").0, "Rule B9.4");
    XCTAssert(IBANtools.isValidAccount("58467232", bankCode: "11111134", countryCode: "de").0, "Rule B9.5");
    XCTAssert(!IBANtools.isValidAccount("43025432", bankCode: "11111134", countryCode: "de").0, "Rule B9.7"); // must fail
    XCTAssert(!IBANtools.isValidAccount("61256523", bankCode: "11111134", countryCode: "de").0, "Rule B9.9"); // must fail
    XCTAssert(!IBANtools.isValidAccount("54352684", bankCode: "11111134", countryCode: "de").0, "Rule B9.10"); // must fail
    XCTAssert(IBANtools.isValidAccount("7125633", bankCode: "11111134", countryCode: "de").0, "Rule B9.11");
    XCTAssert(IBANtools.isValidAccount("1253657", bankCode: "11111134", countryCode: "de").0, "Rule B9.12");
    XCTAssert(IBANtools.isValidAccount("4353631", bankCode: "11111134", countryCode: "de").0, "Rule B9.13");
    XCTAssert(!IBANtools.isValidAccount("2356412", bankCode: "11111134", countryCode: "de").0, "Rule B9.14"); // must fail
    XCTAssert(!IBANtools.isValidAccount("5435886", bankCode: "11111134", countryCode: "de").0, "Rule B9.15"); // must fail
    XCTAssert(!IBANtools.isValidAccount("9435414", bankCode: "11111134", countryCode: "de").0, "Rule B9.16"); // must fail

    // C0
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "13051042", countryCode: "de").0, "Rule C0.0");

    // The documentation includes some test cases that use an old bank code which is already in our list for method 52.
    // However these test cases are made to use method 52 anyway. So we are fine with that.
    XCTAssert(IBANtools.isValidAccount("43001500", bankCode: "130 511 72", countryCode: "de").0, "Rule C0.1");
    XCTAssert(IBANtools.isValidAccount("48726458", bankCode: "130 511 72", countryCode: "de").0, "Rule C0.2");
    XCTAssert(!IBANtools.isValidAccount("82335729", bankCode: "130 511 72", countryCode: "de").0, "Rule C0.3"); // must fail
    XCTAssert(!IBANtools.isValidAccount("29837521", bankCode: "130 511 72", countryCode: "de").0, "Rule C0.4"); // must fail
    XCTAssert(IBANtools.isValidAccount("0082335729", bankCode: "13051042", countryCode: "de").0, "Rule C0.5");
    XCTAssert(IBANtools.isValidAccount("0734192657", bankCode: "13051042", countryCode: "de").0, "Rule C0.6");
    XCTAssert(IBANtools.isValidAccount("6932875274", bankCode: "13051042", countryCode: "de").0, "Rule C0.7");
    XCTAssert(!IBANtools.isValidAccount("0132572975", bankCode: "13051042", countryCode: "de").0, "Rule C0.8"); // must fail
    XCTAssert(!IBANtools.isValidAccount("3038752371", bankCode: "13051042", countryCode: "de").0, "Rule C0.9"); // must fail

    // C1
    XCTAssert(!IBANtools.isValidAccount("0", bankCode: "50010517", countryCode: "de").0, "Rule C1.0");

    XCTAssert(IBANtools.isValidAccount("0446786040", bankCode: "50010517", countryCode: "de").0, "Rule C1.1");
    XCTAssert(IBANtools.isValidAccount("0478046940", bankCode: "50010517", countryCode: "de").0, "Rule C1.2");
    XCTAssert(IBANtools.isValidAccount("0701625830", bankCode: "50010517", countryCode: "de").0, "Rule C1.3");
    XCTAssert(IBANtools.isValidAccount("0701625840", bankCode: "50010517", countryCode: "de").0, "Rule C1.4");
    XCTAssert(IBANtools.isValidAccount("0882095630", bankCode: "50010517", countryCode: "de").0, "Rule C1.5");
    XCTAssert(!IBANtools.isValidAccount("0478046340", bankCode: "50010517", countryCode: "de").0, "Rule C1.7"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0701625730", bankCode: "50010517", countryCode: "de").0, "Rule C1.8"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0701625440", bankCode: "50010517", countryCode: "de").0, "Rule C1.9"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0882095130", bankCode: "50010517", countryCode: "de").0, "Rule C1.10"); // must fail

    XCTAssert(IBANtools.isValidAccount("5432112349", bankCode: "50010517", countryCode: "de").0, "Rule C1.11");
    XCTAssert(IBANtools.isValidAccount("5543223456", bankCode: "50010517", countryCode: "de").0, "Rule C1.12");
    XCTAssert(IBANtools.isValidAccount("5654334563", bankCode: "50010517", countryCode: "de").0, "Rule C1.13");
    XCTAssert(IBANtools.isValidAccount("5765445670", bankCode: "50010517", countryCode: "de").0, "Rule C1.14");
    XCTAssert(IBANtools.isValidAccount("5876556788", bankCode: "50010517", countryCode: "de").0, "Rule C1.15");
    XCTAssert(!IBANtools.isValidAccount("5432112341", bankCode: "50010517", countryCode: "de").0, "Rule C1.16"); // must fail
    XCTAssert(!IBANtools.isValidAccount("5543223458", bankCode: "50010517", countryCode: "de").0, "Rule C1.17"); // must fail
    XCTAssert(!IBANtools.isValidAccount("5654334565", bankCode: "50010517", countryCode: "de").0, "Rule C1.18"); // must fail
    XCTAssert(!IBANtools.isValidAccount("5765445672", bankCode: "50010517", countryCode: "de").0, "Rule C1.19"); // must fail
    XCTAssert(!IBANtools.isValidAccount("5876556780", bankCode: "50010517", countryCode: "de").0, "Rule C1.20"); // must fail

    // C2
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "21450000", countryCode: "de").0, "Rule C2.0");

    XCTAssert(IBANtools.isValidAccount("2394871426", bankCode: "21450000", countryCode: "de").0, "Rule C2.1");
    XCTAssert(IBANtools.isValidAccount("4218461950", bankCode: "21450000", countryCode: "de").0, "Rule C2.2");
    XCTAssert(IBANtools.isValidAccount("7352569148", bankCode: "21450000", countryCode: "de").0, "Rule C2.3");
    XCTAssert(!IBANtools.isValidAccount("0328705282", bankCode: "21450000", countryCode: "de").0, "Rule C2.6"); // must fail
    XCTAssert(!IBANtools.isValidAccount("9024675131", bankCode: "21450000", countryCode: "de").0, "Rule C2.7"); // must fail

    XCTAssert(IBANtools.isValidAccount("5127485166", bankCode: "21450000", countryCode: "de").0, "Rule C2.8");
    XCTAssert(IBANtools.isValidAccount("8738142564", bankCode: "21450000", countryCode: "de").0, "Rule C2.9");
    XCTAssert(!IBANtools.isValidAccount("0328705282", bankCode: "21450000", countryCode: "de").0, "Rule C2.10"); // must fail
    XCTAssert(!IBANtools.isValidAccount("9024675131", bankCode: "21450000", countryCode: "de").0, "Rule C2.11"); // must fail

    // C3
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "25060180", countryCode: "de").0, "Rule C3.0");

    XCTAssert(IBANtools.isValidAccount("9294182", bankCode: "25060180", countryCode: "de").0, "Rule C3.1");
    XCTAssert(IBANtools.isValidAccount("4431276", bankCode: "25060180", countryCode: "de").0, "Rule C3.2");
    XCTAssert(IBANtools.isValidAccount("19919", bankCode: "25060180", countryCode: "de").0, "Rule C3.3");
    XCTAssert(!IBANtools.isValidAccount("17002", bankCode: "25060180", countryCode: "de").0, "Rule C3.4"); // must fail
    XCTAssert(!IBANtools.isValidAccount("123451", bankCode: "25060180", countryCode: "de").0, "Rule C3.5"); // must fail
    XCTAssert(!IBANtools.isValidAccount("122448", bankCode: "25060180", countryCode: "de").0, "Rule C3.6"); // must fail

    XCTAssert(IBANtools.isValidAccount("9000420530", bankCode: "25060180", countryCode: "de").0, "Rule C3.7");
    XCTAssert(IBANtools.isValidAccount("9000010006", bankCode: "25060180", countryCode: "de").0, "Rule C3.8");
    XCTAssert(IBANtools.isValidAccount("9000577650", bankCode: "25060180", countryCode: "de").0, "Rule C3.9");
    XCTAssert(!IBANtools.isValidAccount("9000734028", bankCode: "25060180", countryCode: "de").0, "Rule C3.10"); // must fail
    XCTAssert(!IBANtools.isValidAccount("9000733227", bankCode: "25060180", countryCode: "de").0, "Rule C3.11"); // must fail
    XCTAssert(!IBANtools.isValidAccount("9000731120", bankCode: "25060180", countryCode: "de").0, "Rule C3.12"); // must fail

    // C4
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "29030400", countryCode: "de").0, "Rule C4.0");

    XCTAssert(IBANtools.isValidAccount("0000000019", bankCode: "29030400", countryCode: "de").0, "Rule C4.1");
    XCTAssert(IBANtools.isValidAccount("0000292932", bankCode: "29030400", countryCode: "de").0, "Rule C4.2");
    XCTAssert(IBANtools.isValidAccount("0000094455", bankCode: "29030400", countryCode: "de").0, "Rule C4.3");
    XCTAssert(!IBANtools.isValidAccount("0000000017", bankCode: "29030400", countryCode: "de").0, "Rule C4.4"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0000292933", bankCode: "29030400", countryCode: "de").0, "Rule C4.5"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0000094459", bankCode: "29030400", countryCode: "de").0, "Rule C4.6"); // must fail

    XCTAssert(IBANtools.isValidAccount("9000420530", bankCode: "29030400", countryCode: "de").0, "Rule C4.7");
    XCTAssert(IBANtools.isValidAccount("9000010006", bankCode: "29030400", countryCode: "de").0, "Rule C4.8");
    XCTAssert(IBANtools.isValidAccount("9000577650", bankCode: "29030400", countryCode: "de").0, "Rule C4.9");
    XCTAssert(!IBANtools.isValidAccount("9000726558", bankCode: "29030400", countryCode: "de").0, "Rule C4.10"); // must fail
    XCTAssert(!IBANtools.isValidAccount("9001733457", bankCode: "29030400", countryCode: "de").0, "Rule C4.11"); // must fail
    XCTAssert(!IBANtools.isValidAccount("9000732000", bankCode: "29030400", countryCode: "de").0, "Rule C4.12"); // must fail
    
    // C5
    XCTAssert(!IBANtools.isValidAccount("0", bankCode: "20050000", countryCode: "de").0, "Rule C5.0");

    XCTAssert(IBANtools.isValidAccount("0000301168", bankCode: "20050000", countryCode: "de").0, "Rule C5.1");
    XCTAssert(IBANtools.isValidAccount("0000302554", bankCode: "20050000", countryCode: "de").0, "Rule C5.2");
    XCTAssert(!IBANtools.isValidAccount("0000302589", bankCode: "20050000", countryCode: "de").0, "Rule C5.3"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0000507336", bankCode: "20050000", countryCode: "de").0, "Rule C5.4"); // must fail

    XCTAssert(IBANtools.isValidAccount("0300020050", bankCode: "20050000", countryCode: "de").0, "Rule C5.5");
    XCTAssert(IBANtools.isValidAccount("0300566000", bankCode: "20050000", countryCode: "de").0, "Rule C5.6");
    XCTAssert(!IBANtools.isValidAccount("0302555000", bankCode: "20050000", countryCode: "de").0, "Rule C5.7"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0302589000", bankCode: "20050000", countryCode: "de").0, "Rule C5.8"); // must fail

    XCTAssert(IBANtools.isValidAccount("1000061378", bankCode: "20050000", countryCode: "de").0, "Rule C5.9");
    XCTAssert(IBANtools.isValidAccount("1000061412", bankCode: "20050000", countryCode: "de").0, "Rule C5.10");
    XCTAssert(IBANtools.isValidAccount("4450164064", bankCode: "20050000", countryCode: "de").0, "Rule C5.11");
    XCTAssert(IBANtools.isValidAccount("4863476104", bankCode: "20050000", countryCode: "de").0, "Rule C5.12");
    XCTAssert(IBANtools.isValidAccount("5000000028", bankCode: "20050000", countryCode: "de").0, "Rule C5.13");
    XCTAssert(IBANtools.isValidAccount("5000000391", bankCode: "20050000", countryCode: "de").0, "Rule C5.14");
    XCTAssert(IBANtools.isValidAccount("6450008149", bankCode: "20050000", countryCode: "de").0, "Rule C5.15");
    XCTAssert(IBANtools.isValidAccount("6800001016", bankCode: "20050000", countryCode: "de").0, "Rule C5.16");
    XCTAssert(IBANtools.isValidAccount("9000100012", bankCode: "20050000", countryCode: "de").0, "Rule C5.17");
    XCTAssert(IBANtools.isValidAccount("9000210017", bankCode: "20050000", countryCode: "de").0, "Rule C5.18");
    XCTAssert(!IBANtools.isValidAccount("1000061457", bankCode: "20050000", countryCode: "de").0, "Rule C5.19"); // must fail
    XCTAssert(!IBANtools.isValidAccount("1000061498", bankCode: "20050000", countryCode: "de").0, "Rule C5.20"); // must fail
    XCTAssert(!IBANtools.isValidAccount("4864446015", bankCode: "20050000", countryCode: "de").0, "Rule C5.21"); // must fail
    XCTAssert(!IBANtools.isValidAccount("4865038012", bankCode: "20050000", countryCode: "de").0, "Rule C5.22"); // must fail
    XCTAssert(!IBANtools.isValidAccount("5000001028", bankCode: "20050000", countryCode: "de").0, "Rule C5.23"); // must fail
    XCTAssert(!IBANtools.isValidAccount("5000001075", bankCode: "20050000", countryCode: "de").0, "Rule C5.24"); // must fail
    XCTAssert(!IBANtools.isValidAccount("6450008150", bankCode: "20050000", countryCode: "de").0, "Rule C5.25"); // must fail
    XCTAssert(!IBANtools.isValidAccount("6542812818", bankCode: "20050000", countryCode: "de").0, "Rule C5.26"); // must fail
    XCTAssert(!IBANtools.isValidAccount("9000110012", bankCode: "20050000", countryCode: "de").0, "Rule C5.27"); // must fail
    XCTAssert(!IBANtools.isValidAccount("9000300310", bankCode: "20050000", countryCode: "de").0, "Rule C5.28"); // must fail

    XCTAssert(IBANtools.isValidAccount("3060188103", bankCode: "20050000", countryCode: "de").0, "Rule C5.29");
    XCTAssert(IBANtools.isValidAccount("3070402023", bankCode: "20050000", countryCode: "de").0, "Rule C5.30");
    XCTAssert(!IBANtools.isValidAccount("3081000783", bankCode: "20050000", countryCode: "de").0, "Rule C5.31"); // must fail
    XCTAssert(!IBANtools.isValidAccount("3081308871", bankCode: "20050000", countryCode: "de").0, "Rule C5.32"); // must fail

    XCTAssert(IBANtools.isValidAccount("0030000000", bankCode: "20050000", countryCode: "de").0, "Rule C5.33");
    XCTAssert(IBANtools.isValidAccount("7000000000", bankCode: "20050000", countryCode: "de").0, "Rule C5.34");
    XCTAssert(IBANtools.isValidAccount("8500000000", bankCode: "20050000", countryCode: "de").0, "Rule C5.35");

    // C6
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "10050005", countryCode: "de").0, "Rule C6.0");

    XCTAssert(IBANtools.isValidAccount("0000065516", bankCode: "10050005", countryCode: "de").0, "Rule C6.1");
    XCTAssert(IBANtools.isValidAccount("0203178249", bankCode: "10050005", countryCode: "de").0, "Rule C6.2");
    XCTAssert(IBANtools.isValidAccount("1031405209", bankCode: "10050005", countryCode: "de").0, "Rule C6.3");
    XCTAssert(IBANtools.isValidAccount("1082012201", bankCode: "10050005", countryCode: "de").0, "Rule C6.4");
    XCTAssert(IBANtools.isValidAccount("2003455189", bankCode: "10050005", countryCode: "de").0, "Rule C6.5");
    XCTAssert(IBANtools.isValidAccount("2004001016", bankCode: "10050005", countryCode: "de").0, "Rule C6.6");
    XCTAssert(IBANtools.isValidAccount("3110150986", bankCode: "10050005", countryCode: "de").0, "Rule C6.7");
    XCTAssert(IBANtools.isValidAccount("3068459207", bankCode: "10050005", countryCode: "de").0, "Rule C6.8");
    XCTAssert(IBANtools.isValidAccount("5035105948", bankCode: "10050005", countryCode: "de").0, "Rule C6.9");
    XCTAssert(IBANtools.isValidAccount("5286102149", bankCode: "10050005", countryCode: "de").0, "Rule C6.10");
    XCTAssert(IBANtools.isValidAccount("4012660028", bankCode: "10050005", countryCode: "de").0, "Rule C6.11");
    XCTAssert(IBANtools.isValidAccount("4100235626", bankCode: "10050005", countryCode: "de").0, "Rule C6.12");
    XCTAssert(IBANtools.isValidAccount("6028426119", bankCode: "10050005", countryCode: "de").0, "Rule C6.13");
    XCTAssert(IBANtools.isValidAccount("6861001755", bankCode: "10050005", countryCode: "de").0, "Rule C6.14");
    XCTAssert(IBANtools.isValidAccount("7008199027", bankCode: "10050005", countryCode: "de").0, "Rule C6.15");
    XCTAssert(IBANtools.isValidAccount("7002000023", bankCode: "10050005", countryCode: "de").0, "Rule C6.16");
    XCTAssert(IBANtools.isValidAccount("8526080015", bankCode: "10050005", countryCode: "de").0, "Rule C6.17");
    XCTAssert(IBANtools.isValidAccount("8711072264", bankCode: "10050005", countryCode: "de").0, "Rule C6.18");
    XCTAssert(IBANtools.isValidAccount("9000430223", bankCode: "10050005", countryCode: "de").0, "Rule C6.19");
    XCTAssert(IBANtools.isValidAccount("9000781153", bankCode: "10050005", countryCode: "de").0, "Rule C6.20");
    XCTAssert(!IBANtools.isValidAccount("0525111212", bankCode: "10050005", countryCode: "de").0, "Rule C6.21"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0091423614", bankCode: "10050005", countryCode: "de").0, "Rule C6.22"); // must fail
    XCTAssert(!IBANtools.isValidAccount("1082311275", bankCode: "10050005", countryCode: "de").0, "Rule C6.23"); // must fail
    XCTAssert(!IBANtools.isValidAccount("1000118821", bankCode: "10050005", countryCode: "de").0, "Rule C6.24"); // must fail
    XCTAssert(!IBANtools.isValidAccount("2004306518", bankCode: "10050005", countryCode: "de").0, "Rule C6.25"); // must fail
    XCTAssert(!IBANtools.isValidAccount("2016001206", bankCode: "10050005", countryCode: "de").0, "Rule C6.26"); // must fail
    XCTAssert(!IBANtools.isValidAccount("3462816371", bankCode: "10050005", countryCode: "de").0, "Rule C6.27"); // must fail
    XCTAssert(!IBANtools.isValidAccount("3622548632", bankCode: "10050005", countryCode: "de").0, "Rule C6.28"); // must fail
    XCTAssert(!IBANtools.isValidAccount("4232300158", bankCode: "10050005", countryCode: "de").0, "Rule C6.29"); // must fail
    XCTAssert(!IBANtools.isValidAccount("4000456126", bankCode: "10050005", countryCode: "de").0, "Rule C6.30"); // must fail
    XCTAssert(!IBANtools.isValidAccount("5002684526", bankCode: "10050005", countryCode: "de").0, "Rule C6.31"); // must fail
    XCTAssert(!IBANtools.isValidAccount("5564123850", bankCode: "10050005", countryCode: "de").0, "Rule C6.32"); // must fail
    XCTAssert(!IBANtools.isValidAccount("6295473774", bankCode: "10050005", countryCode: "de").0, "Rule C6.33"); // must fail
    XCTAssert(!IBANtools.isValidAccount("6640806317", bankCode: "10050005", countryCode: "de").0, "Rule C6.34"); // must fail
    XCTAssert(!IBANtools.isValidAccount("7000062022", bankCode: "10050005", countryCode: "de").0, "Rule C6.35"); // must fail
    XCTAssert(!IBANtools.isValidAccount("7006003027", bankCode: "10050005", countryCode: "de").0, "Rule C6.36"); // must fail
    XCTAssert(!IBANtools.isValidAccount("8348300002", bankCode: "10050005", countryCode: "de").0, "Rule C6.37"); // must fail
    XCTAssert(!IBANtools.isValidAccount("8654216984", bankCode: "10050005", countryCode: "de").0, "Rule C6.38"); // must fail
    XCTAssert(!IBANtools.isValidAccount("9000641509", bankCode: "10050005", countryCode: "de").0, "Rule C6.39"); // must fail
    XCTAssert(!IBANtools.isValidAccount("9000260986", bankCode: "10050005", countryCode: "de").0, "Rule C6.40"); // must fail

    // C7
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "76026000", countryCode: "de").0, "Rule C7.0");

    XCTAssert(IBANtools.isValidAccount("3500022", bankCode: "76026000", countryCode: "de").0, "Rule C7.1");
    XCTAssert(IBANtools.isValidAccount("38150900", bankCode: "76026000", countryCode: "de").0, "Rule C7.2");
    XCTAssert(IBANtools.isValidAccount("600103660", bankCode: "76026000", countryCode: "de").0, "Rule C7.3");
    XCTAssert(IBANtools.isValidAccount("39101181", bankCode: "76026000", countryCode: "de").0, "Rule C7.4");

    XCTAssert(IBANtools.isValidAccount("94012341", bankCode: "76026000", countryCode: "de").0, "Rule C7.7");
    XCTAssert(IBANtools.isValidAccount("5073321010", bankCode: "76026000", countryCode: "de").0, "Rule C7.8");
    XCTAssert(!IBANtools.isValidAccount("1234517892", bankCode: "76026000", countryCode: "de").0, "Rule C7.9"); // must fail
    XCTAssert(!IBANtools.isValidAccount("987614325", bankCode: "76026000", countryCode: "de").0, "Rule C7.10"); // must fail
    
    // C8
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "21750000", countryCode: "de").0, "Rule C8.0");

    XCTAssert(IBANtools.isValidAccount("3456789019", bankCode: "21750000", countryCode: "de").0, "Rule C8.1");
    XCTAssert(IBANtools.isValidAccount("5678901231", bankCode: "21750000", countryCode: "de").0, "Rule C8.2");
    XCTAssert(!IBANtools.isValidAccount("1234567890", bankCode: "21750000", countryCode: "de").0, "Rule C8.5"); // must fail
    XCTAssert(!IBANtools.isValidAccount("9012345678", bankCode: "21750000", countryCode: "de").0, "Rule C8.6"); // must fail

    XCTAssert(IBANtools.isValidAccount("3456789012", bankCode: "21750000", countryCode: "de").0, "Rule C8.7");
    XCTAssert(IBANtools.isValidAccount("0022007130", bankCode: "21750000", countryCode: "de").0, "Rule C8.8");
    XCTAssert(!IBANtools.isValidAccount("1234567890", bankCode: "21750000", countryCode: "de").0, "Rule C8.10"); // must fail
    XCTAssert(!IBANtools.isValidAccount("9012345678", bankCode: "21750000", countryCode: "de").0, "Rule C8.11"); // must fail

    XCTAssert(IBANtools.isValidAccount("0123456789", bankCode: "21750000", countryCode: "de").0, "Rule C8.12");
    XCTAssert(IBANtools.isValidAccount("0552071285", bankCode: "21750000", countryCode: "de").0, "Rule C8.13");
    XCTAssert(!IBANtools.isValidAccount("1234567890", bankCode: "21750000", countryCode: "de").0, "Rule C8.14"); // must fail
    XCTAssert(!IBANtools.isValidAccount("9012345678", bankCode: "21750000", countryCode: "de").0, "Rule C8.15"); // must fail

    // C9
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "59252046", countryCode: "de").0, "Rule C9.0");

    XCTAssert(IBANtools.isValidAccount("3456789019", bankCode: "59252046", countryCode: "de").0, "Rule C9.1");
    XCTAssert(IBANtools.isValidAccount("5678901231", bankCode: "59252046", countryCode: "de").0, "Rule C9.2");
    XCTAssert(!IBANtools.isValidAccount("3456789012", bankCode: "59252046", countryCode: "de").0, "Rule C9.3"); // must fail

    XCTAssert(IBANtools.isValidAccount("0123456789", bankCode: "59252046", countryCode: "de").0, "Rule C9.6");
    XCTAssert(!IBANtools.isValidAccount("1234567890", bankCode: "59252046", countryCode: "de").0, "Rule C9.7"); // must fail
    XCTAssert(!IBANtools.isValidAccount("9012345678", bankCode: "59252046", countryCode: "de").0, "Rule C9.8"); // must fail
    
    // D0
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "86055592", countryCode: "de").0, "Rule D0.0");

    XCTAssert(IBANtools.isValidAccount("6100272324", bankCode: "86055592", countryCode: "de").0, "Rule D0.1");
    XCTAssert(IBANtools.isValidAccount("6100273479", bankCode: "86055592", countryCode: "de").0, "Rule D0.2");
    XCTAssert(IBANtools.isValidAccount("5700000000", bankCode: "86055592", countryCode: "de").0, "Rule D0.3");
    XCTAssert(!IBANtools.isValidAccount("6100272885", bankCode: "86055592", countryCode: "de").0, "Rule D0.4"); // must fail
    XCTAssert(!IBANtools.isValidAccount("6100273377", bankCode: "86055592", countryCode: "de").0, "Rule D0.5"); // must fail
    XCTAssert(!IBANtools.isValidAccount("6100274012", bankCode: "86055592", countryCode: "de").0, "Rule D0.6"); // must fail

    // D1
    XCTAssert(!IBANtools.isValidAccount("0", bankCode: "10050006", countryCode: "de").0, "Rule D1.0");

    XCTAssert(IBANtools.isValidAccount("0082012203", bankCode: "10050006", countryCode: "de").0, "Rule D1.1");
    XCTAssert(IBANtools.isValidAccount("1452683581", bankCode: "10050006", countryCode: "de").0, "Rule D1.2");
    XCTAssert(IBANtools.isValidAccount("2129642505", bankCode: "10050006", countryCode: "de").0, "Rule D1.3");
    XCTAssert(IBANtools.isValidAccount("3002000027", bankCode: "10050006", countryCode: "de").0, "Rule D1.4");
    XCTAssert(IBANtools.isValidAccount("4230001407", bankCode: "10050006", countryCode: "de").0, "Rule D1.5");
    XCTAssert(IBANtools.isValidAccount("5000065514", bankCode: "10050006", countryCode: "de").0, "Rule D1.6");
    XCTAssert(IBANtools.isValidAccount("6001526215", bankCode: "10050006", countryCode: "de").0, "Rule D1.7");
    XCTAssert(IBANtools.isValidAccount("7126502149", bankCode: "10050006", countryCode: "de").0, "Rule D1.8");
    XCTAssert(IBANtools.isValidAccount("9000430223", bankCode: "10050006", countryCode: "de").0, "Rule D1.9");
    XCTAssert(!IBANtools.isValidAccount("0000260986", bankCode: "10050006", countryCode: "de").0, "Rule D1.10"); // must fail
    XCTAssert(!IBANtools.isValidAccount("1062813622", bankCode: "10050006", countryCode: "de").0, "Rule D1.11"); // must fail
    XCTAssert(!IBANtools.isValidAccount("2256412314", bankCode: "10050006", countryCode: "de").0, "Rule D1.12"); // must fail
    XCTAssert(!IBANtools.isValidAccount("3012084101", bankCode: "10050006", countryCode: "de").0, "Rule D1.13"); // must fail
    XCTAssert(!IBANtools.isValidAccount("4006003027", bankCode: "10050006", countryCode: "de").0, "Rule D1.14"); // must fail
    XCTAssert(!IBANtools.isValidAccount("5814500990", bankCode: "10050006", countryCode: "de").0, "Rule D1.15"); // must fail
    XCTAssert(!IBANtools.isValidAccount("6128462594", bankCode: "10050006", countryCode: "de").0, "Rule D1.16"); // must fail
    XCTAssert(!IBANtools.isValidAccount("7000062035", bankCode: "10050006", countryCode: "de").0, "Rule D1.17"); // must fail
    XCTAssert(!IBANtools.isValidAccount("8003306026", bankCode: "10050006", countryCode: "de").0, "Rule D1.18"); // must fail
    XCTAssert(!IBANtools.isValidAccount("9000641509", bankCode: "10050006", countryCode: "de").0, "Rule D1.19"); // must fail

    // D2
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "70120500", countryCode: "de").0, "Rule D2.0");

    XCTAssert(IBANtools.isValidAccount("189912137", bankCode: "70120500", countryCode: "de").0, "Rule D2.1");
    XCTAssert(IBANtools.isValidAccount("235308215", bankCode: "70120500", countryCode: "de").0, "Rule D2.2");
    XCTAssert(IBANtools.isValidAccount("4455667784", bankCode: "70120500", countryCode: "de").0, "Rule D2.3");
    XCTAssert(IBANtools.isValidAccount("1234567897", bankCode: "70120500", countryCode: "de").0, "Rule D2.4");
    XCTAssert(IBANtools.isValidAccount("51181008", bankCode: "70120500", countryCode: "de").0, "Rule D2.5");
    XCTAssert(IBANtools.isValidAccount("71214205", bankCode: "70120500", countryCode: "de").0, "Rule D2.6");
    XCTAssert(!IBANtools.isValidAccount("6414241", bankCode: "70120500", countryCode: "de").0, "Rule D2.7"); // must fail
    XCTAssert(!IBANtools.isValidAccount("179751314", bankCode: "70120500", countryCode: "de").0, "Rule D2.8"); // must fail

    // D3
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "59052020", countryCode: "de").0, "Rule D3.0");

    XCTAssert(IBANtools.isValidAccount("1600169591", bankCode: "59052020", countryCode: "de").0, "Rule D3.1");
    XCTAssert(IBANtools.isValidAccount("1600189151", bankCode: "59052020", countryCode: "de").0, "Rule D3.2");
    XCTAssert(IBANtools.isValidAccount("1800084079", bankCode: "59052020", countryCode: "de").0, "Rule D3.3");
    XCTAssert(!IBANtools.isValidAccount("1600166307", bankCode: "59052020", countryCode: "de").0, "Rule D3.4"); // must fail
    
    XCTAssert(IBANtools.isValidAccount("6019937007", bankCode: "59052020", countryCode: "de").0, "Rule D3.7");
    XCTAssert(IBANtools.isValidAccount("6021354007", bankCode: "59052020", countryCode: "de").0, "Rule D3.8");
    XCTAssert(IBANtools.isValidAccount("6030642006", bankCode: "59052020", countryCode: "de").0, "Rule D3.9");
    XCTAssert(!IBANtools.isValidAccount("6025017009", bankCode: "59052020", countryCode: "de").0, "Rule D3.10"); // must fail
    XCTAssert(!IBANtools.isValidAccount("6028267003", bankCode: "59052020", countryCode: "de").0, "Rule D3.11"); // must fail
    XCTAssert(!IBANtools.isValidAccount("6019835001", bankCode: "59052020", countryCode: "de").0, "Rule D3.12"); // must fail

    // D4
    XCTAssert(!IBANtools.isValidAccount("0", bankCode: "10050007", countryCode: "de").0, "Rule D4.0");

    XCTAssert(IBANtools.isValidAccount("1112048219", bankCode: "10050007", countryCode: "de").0, "Rule D4.1");
    XCTAssert(IBANtools.isValidAccount("2024601814", bankCode: "10050007", countryCode: "de").0, "Rule D4.2");
    XCTAssert(IBANtools.isValidAccount("3000005012", bankCode: "10050007", countryCode: "de").0, "Rule D4.3");
    XCTAssert(IBANtools.isValidAccount("4143406984", bankCode: "10050007", countryCode: "de").0, "Rule D4.4");
    XCTAssert(IBANtools.isValidAccount("5926485111", bankCode: "10050007", countryCode: "de").0, "Rule D4.5");
    XCTAssert(IBANtools.isValidAccount("6286304975", bankCode: "10050007", countryCode: "de").0, "Rule D4.6");
    XCTAssert(IBANtools.isValidAccount("7900256617", bankCode: "10050007", countryCode: "de").0, "Rule D4.7");
    XCTAssert(IBANtools.isValidAccount("8102228628", bankCode: "10050007", countryCode: "de").0, "Rule D4.8");
    XCTAssert(IBANtools.isValidAccount("9002364588", bankCode: "10050007", countryCode: "de").0, "Rule D4.9");
    XCTAssert(!IBANtools.isValidAccount("0359432843", bankCode: "10050007", countryCode: "de").0, "Rule D4.10"); // must fail
    XCTAssert(!IBANtools.isValidAccount("1000062023", bankCode: "10050007", countryCode: "de").0, "Rule D4.11"); // must fail
    XCTAssert(!IBANtools.isValidAccount("2204271250", bankCode: "10050007", countryCode: "de").0, "Rule D4.12"); // must fail
    XCTAssert(!IBANtools.isValidAccount("3051681017", bankCode: "10050007", countryCode: "de").0, "Rule D4.13"); // must fail
    XCTAssert(!IBANtools.isValidAccount("4000123456", bankCode: "10050007", countryCode: "de").0, "Rule D4.14"); // must fail
    XCTAssert(!IBANtools.isValidAccount("5212744564", bankCode: "10050007", countryCode: "de").0, "Rule D4.15"); // must fail
    XCTAssert(!IBANtools.isValidAccount("6286420010", bankCode: "10050007", countryCode: "de").0, "Rule D4.16"); // must fail
    XCTAssert(!IBANtools.isValidAccount("7859103459", bankCode: "10050007", countryCode: "de").0, "Rule D4.17"); // must fail
    XCTAssert(!IBANtools.isValidAccount("8003306026", bankCode: "10050007", countryCode: "de").0, "Rule D4.18"); // must fail
    XCTAssert(!IBANtools.isValidAccount("9916524534", bankCode: "10050007", countryCode: "de").0, "Rule D4.19"); // must fail

    // D5
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "20690500", countryCode: "de").0, "Rule D5.0");

    XCTAssert(IBANtools.isValidAccount("5999718138", bankCode: "20690500", countryCode: "de").0, "Rule D5.1");
    XCTAssert(IBANtools.isValidAccount("1799222116", bankCode: "20690500", countryCode: "de").0, "Rule D5.2");
    XCTAssert(IBANtools.isValidAccount("0099632004", bankCode: "20690500", countryCode: "de").0, "Rule D5.3");
    XCTAssert(!IBANtools.isValidAccount("3299632008", bankCode: "20690500", countryCode: "de").0, "Rule D5.4"); // must fail
    XCTAssert(!IBANtools.isValidAccount("1999204293", bankCode: "20690500", countryCode: "de").0, "Rule D5.5"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0399242139", bankCode: "20690500", countryCode: "de").0, "Rule D5.6"); // must fail
    XCTAssert(IBANtools.isValidAccount("8623410000", bankCode: "20690500", countryCode: "de").0, "Rule D5.7");

    XCTAssert(IBANtools.isValidAccount("0004711173", bankCode: "20690500", countryCode: "de").0, "Rule D5.8");
    XCTAssert(IBANtools.isValidAccount("0007093330", bankCode: "20690500", countryCode: "de").0, "Rule D5.9");
    XCTAssert(IBANtools.isValidAccount("0000127787", bankCode: "20690500", countryCode: "de").0, "Rule D5.10");
    XCTAssert(!IBANtools.isValidAccount("8623420004", bankCode: "20690500", countryCode: "de").0, "Rule D5.11"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0001123458", bankCode: "20690500", countryCode: "de").0, "Rule D5.12"); // must fail

    XCTAssert(IBANtools.isValidAccount("0004711172", bankCode: "20690500", countryCode: "de").0, "Rule D5.13");
    XCTAssert(IBANtools.isValidAccount("0007093335", bankCode: "20690500", countryCode: "de").0, "Rule D5.14");
    XCTAssert(!IBANtools.isValidAccount("0001123458", bankCode: "20690500", countryCode: "de").0, "Rule D5.15"); // must fail

    XCTAssert(IBANtools.isValidAccount("0000100062", bankCode: "20690500", countryCode: "de").0, "Rule D5.16");
    XCTAssert(IBANtools.isValidAccount("0000100088", bankCode: "20690500", countryCode: "de").0, "Rule D5.17");
    XCTAssert(!IBANtools.isValidAccount("0000100084", bankCode: "20690500", countryCode: "de").0, "Rule D5.18"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0000100085", bankCode: "20690500", countryCode: "de").0, "Rule D5.19"); // must fail

    // D6
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "22151730", countryCode: "de").0, "Rule D6.0");

    XCTAssert(IBANtools.isValidAccount("3601671056", bankCode: "22151730", countryCode: "de").0, "Rule D6.1");
    XCTAssert(IBANtools.isValidAccount("4402001046", bankCode: "22151730", countryCode: "de").0, "Rule D6.2");
    XCTAssert(IBANtools.isValidAccount("6100268241", bankCode: "22151730", countryCode: "de").0, "Rule D6.3");
    XCTAssert(!IBANtools.isValidAccount("3615071237", bankCode: "22151730", countryCode: "de").0, "Rule D6.4"); // must fail
    XCTAssert(!IBANtools.isValidAccount("6039267013", bankCode: "22151730", countryCode: "de").0, "Rule D6.5"); // must fail
    XCTAssert(!IBANtools.isValidAccount("6039316014", bankCode: "22151730", countryCode: "de").0, "Rule D6.6"); // must fail

    XCTAssert(IBANtools.isValidAccount("7001000681", bankCode: "22151730", countryCode: "de").0, "Rule D6.7");
    XCTAssert(IBANtools.isValidAccount("9000111105", bankCode: "22151730", countryCode: "de").0, "Rule D6.8");
    XCTAssert(IBANtools.isValidAccount("9001291005", bankCode: "22151730", countryCode: "de").0, "Rule D6.9");
    XCTAssert(!IBANtools.isValidAccount("7004017653", bankCode: "22151730", countryCode: "de").0, "Rule D6.10"); // must fail
    XCTAssert(!IBANtools.isValidAccount("9002720007", bankCode: "22151730", countryCode: "de").0, "Rule D6.11"); // must fail
    XCTAssert(!IBANtools.isValidAccount("9017483524", bankCode: "22151730", countryCode: "de").0, "Rule D6.12"); // must fail

    // D7
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "57020500", countryCode: "de").0, "Rule D7.0");

    XCTAssert(IBANtools.isValidAccount("0500018205", bankCode: "57020500", countryCode: "de").0, "Rule D7.1");
    XCTAssert(IBANtools.isValidAccount("0230103715", bankCode: "57020500", countryCode: "de").0, "Rule D7.2");
    XCTAssert(IBANtools.isValidAccount("0301000434", bankCode: "57020500", countryCode: "de").0, "Rule D7.3");
    XCTAssert(IBANtools.isValidAccount("0330035104", bankCode: "57020500", countryCode: "de").0, "Rule D7.4");
    XCTAssert(IBANtools.isValidAccount("0420001202", bankCode: "57020500", countryCode: "de").0, "Rule D7.5");
    XCTAssert(IBANtools.isValidAccount("0134637709", bankCode: "57020500", countryCode: "de").0, "Rule D7.6");
    XCTAssert(IBANtools.isValidAccount("0201005939", bankCode: "57020500", countryCode: "de").0, "Rule D7.7");
    XCTAssert(IBANtools.isValidAccount("0602006999", bankCode: "57020500", countryCode: "de").0, "Rule D7.8");
    XCTAssert(!IBANtools.isValidAccount("0501006102", bankCode: "57020500", countryCode: "de").0, "Rule D7.9"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0231307867", bankCode: "57020500", countryCode: "de").0, "Rule D7.10"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0301005331", bankCode: "57020500", countryCode: "de").0, "Rule D7.11"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0330034104", bankCode: "57020500", countryCode: "de").0, "Rule D7.12"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0420001302", bankCode: "57020500", countryCode: "de").0, "Rule D7.13"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0135638809", bankCode: "57020500", countryCode: "de").0, "Rule D7.14"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0202005939", bankCode: "57020500", countryCode: "de").0, "Rule D7.15"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0601006977", bankCode: "57020500", countryCode: "de").0, "Rule D7.16"); // must fail

    // D8
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "27020000", countryCode: "de").0, "Rule D8.0");

    XCTAssert(IBANtools.isValidAccount("1403414848", bankCode: "27020000", countryCode: "de").0, "Rule D8.1");
    XCTAssert(IBANtools.isValidAccount("6800000439", bankCode: "27020000", countryCode: "de").0, "Rule D8.2");
    XCTAssert(IBANtools.isValidAccount("6899999954", bankCode: "27020000", countryCode: "de").0, "Rule D8.3");
    XCTAssert(!IBANtools.isValidAccount("3012084101", bankCode: "27020000", countryCode: "de").0, "Rule D8.4"); // must fail
    XCTAssert(!IBANtools.isValidAccount("1062813622", bankCode: "27020000", countryCode: "de").0, "Rule D8.5"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0000260986", bankCode: "27020000", countryCode: "de").0, "Rule D8.6"); // must fail
    
    XCTAssert(IBANtools.isValidAccount("0010000000", bankCode: "27020000", countryCode: "de").0, "Rule D8.7");
    XCTAssert(IBANtools.isValidAccount("0099999999", bankCode: "27020000", countryCode: "de").0, "Rule D8.8");

    // D9
    XCTAssert(IBANtools.isValidAccount("0", bankCode: "50120383", countryCode: "de").0, "Rule D9.0");

    XCTAssert(IBANtools.isValidAccount("1234567897", bankCode: "50120383", countryCode: "de").0, "Rule D9.1");
    XCTAssert(IBANtools.isValidAccount("0123456782", bankCode: "50120383", countryCode: "de").0, "Rule D9.2");
    XCTAssert(!IBANtools.isValidAccount("6543217890", bankCode: "50120383", countryCode: "de").0, "Rule D9.5"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0543216789", bankCode: "50120383", countryCode: "de").0, "Rule D9.6"); // must fail

    XCTAssert(IBANtools.isValidAccount("9876543210", bankCode: "50120383", countryCode: "de").0, "Rule D9.7");
    XCTAssert(IBANtools.isValidAccount("1234567890", bankCode: "50120383", countryCode: "de").0, "Rule D9.8");
    XCTAssert(IBANtools.isValidAccount("0123456789", bankCode: "50120383", countryCode: "de").0, "Rule D9.9");
    XCTAssert(!IBANtools.isValidAccount("6543217890", bankCode: "50120383", countryCode: "de").0, "Rule D9.10"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0543216789", bankCode: "50120383", countryCode: "de").0, "Rule D9.11"); // must fail

    XCTAssert(IBANtools.isValidAccount("1100132044", bankCode: "50120383", countryCode: "de").0, "Rule D9.12");
    XCTAssert(IBANtools.isValidAccount("1100669030", bankCode: "50120383", countryCode: "de").0, "Rule D9.13");
    XCTAssert(!IBANtools.isValidAccount("1100789043", bankCode: "50120383", countryCode: "de").0, "Rule D9.14"); // must fail
    XCTAssert(!IBANtools.isValidAccount("1100914032", bankCode: "50120383", countryCode: "de").0, "Rule D9.15"); // must fail

    // E0
    XCTAssert(!IBANtools.isValidAccount("0", bankCode: "20120400", countryCode: "de").0, "Rule E0.0");

    XCTAssert(IBANtools.isValidAccount("1234568013", bankCode: "20120400", countryCode: "de").0, "Rule E0.1");
    XCTAssert(IBANtools.isValidAccount("1534568010", bankCode: "20120400", countryCode: "de").0, "Rule E0.2");
    XCTAssert(IBANtools.isValidAccount("2610015", bankCode: "20120400", countryCode: "de").0, "Rule E0.3");
    XCTAssert(IBANtools.isValidAccount("8741013011", bankCode: "20120400", countryCode: "de").0, "Rule E0.4");
    XCTAssert(!IBANtools.isValidAccount("1234769013", bankCode: "20120400", countryCode: "de").0, "Rule E0.5"); // must fail
    XCTAssert(!IBANtools.isValidAccount("2710014", bankCode: "20120400", countryCode: "de").0, "Rule E0.6"); // must fail
    XCTAssert(!IBANtools.isValidAccount("9741015011", bankCode: "20120400", countryCode: "de").0, "Rule E0.7"); // must fail

    // E1
    XCTAssert(!IBANtools.isValidAccount("0", bankCode: "50131000", countryCode: "de").0, "Rule E1.0");

    XCTAssert(IBANtools.isValidAccount("0 1 3 4 2 1 1 9 0 9", bankCode: "50131000", countryCode: "de").0, "Rule E1.1");
    XCTAssert(IBANtools.isValidAccount("0100041104", bankCode: "50131000", countryCode: "de").0, "Rule E1.2");
    XCTAssert(IBANtools.isValidAccount("0100054106", bankCode: "50131000", countryCode: "de").0, "Rule E1.3");
    XCTAssert(IBANtools.isValidAccount("0200025107", bankCode: "50131000", countryCode: "de").0, "Rule E1.4");
    XCTAssert(!IBANtools.isValidAccount("0150013107", bankCode: "50131000", countryCode: "de").0, "Rule E1.5"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0200035101", bankCode: "50131000", countryCode: "de").0, "Rule E1.6"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0081313890", bankCode: "50131000", countryCode: "de").0, "Rule E1.7"); // must fail
    XCTAssert(!IBANtools.isValidAccount("4268550840", bankCode: "50131000", countryCode: "de").0, "Rule E1.8"); // must fail
    XCTAssert(!IBANtools.isValidAccount("0987402008", bankCode: "50131000", countryCode: "de").0, "Rule E1.9"); // must fail

  }
}

