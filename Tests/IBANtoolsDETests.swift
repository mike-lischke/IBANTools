/**
* Copyright (c) 2014, Mike Lischke. All rights reserved.
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

class IBANtoolsDETests: XCTestCase {

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  func testAndCompare(account: String, _ bank: String, _ country: String, _ expected: (String, IBANToolsResult), _ checkAccount: Bool = false) -> Bool {
    // Account validation is switched off for dummy account numbers used in the tests..
    let result = IBANtools.convertToIBAN(account, bankCode: bank, countryCode: country, validateAccount: checkAccount);
    return result.0 == expected.0 && result.1 == expected.1;
  }

  func testIBANs() {

    // Rule 0000. Uses the default IBAN conversion rule. There are other tests for the default rule.
    XCTAssert(testAndCompare("12345", "10010424", "de", ("DE77100104240000012345", .IBANToolsDefaultIBAN)), "1");
    XCTAssert(testAndCompare("12345", "20010424", "de", ("DE21200104240000012345", .IBANToolsDefaultIBAN)), "2");
    XCTAssert(testAndCompare("12345", "36010424", "de", ("DE09360104240000012345", .IBANToolsDefaultIBAN)), "3");
    XCTAssert(testAndCompare("12345", "50010424", "de", ("DE47500104240000012345", .IBANToolsDefaultIBAN)), "4");
    XCTAssert(testAndCompare("12345", "51010400", "de", ("DE55510104000000012345", .IBANToolsDefaultIBAN)), "5");
    XCTAssert(testAndCompare("12345", "51010800", "de", ("DE87510108000000012345", .IBANToolsDefaultIBAN)), "6");
    XCTAssert(testAndCompare("12345", "55010400", "de", ("DE52550104000000012345", .IBANToolsDefaultIBAN)), "7");
    XCTAssert(testAndCompare("12345", "55010424", "de", ("DE19550104240000012345", .IBANToolsDefaultIBAN)), "8");
    XCTAssert(testAndCompare("12345", "55010625", "de", ("DE70550106250000012345", .IBANToolsDefaultIBAN)), "9");
    XCTAssert(testAndCompare("12345", "60010424", "de", ("DE88600104240000012345", .IBANToolsDefaultIBAN)), "10");
    XCTAssert(testAndCompare("12345", "70010424", "de", ("DE32700104240000012345", .IBANToolsDefaultIBAN)), "11");
    XCTAssert(testAndCompare("12345", "86010424", "de", ("DE20860104240000012345", .IBANToolsDefaultIBAN)), "12");

    // Rule 0001.
    XCTAssert(testAndCompare("532013018", "10050005", "dE", ("", .IBANToolsNoConv)), "1.1");
    XCTAssert(testAndCompare("532013018", "25451450", "dE", ("", .IBANToolsNoConv)), "1.2");

    // Rule 0002.
    XCTAssert(testAndCompare("532013018", "72020700", "dE", ("DE09720207000532013018", .IBANToolsDefaultIBAN)), "2.1");
    XCTAssert(testAndCompare("12345", "72020700", "de", ("DE63720207000000012345", .IBANToolsDefaultIBAN)), "2.2");
    XCTAssert(testAndCompare("12645", "72020700", "de", ( "", .IBANToolsNoConv)), "2.3");
    XCTAssert(testAndCompare("12865", "72020700", "de", ("", .IBANToolsNoConv)), "2.4");

    // Rule 0003.
    XCTAssert(testAndCompare("6161604670", "51010800", "dE", ("", .IBANToolsNoConv)), "3.1");
    XCTAssert(testAndCompare("12345", "51010800", "de", ("DE87510108000000012345", .IBANToolsDefaultIBAN)), "3.2");

    // Rule 0004.
    XCTAssert(testAndCompare("135", "10050000", "dE", ("DE86100500000990021440", .IBANToolsDefaultIBAN)), "4.1");
    XCTAssert(testAndCompare("1111", "10050000", "de", ("DE19100500006600012020", .IBANToolsDefaultIBAN)), "4.2");
    XCTAssert(testAndCompare("1900", "10050000", "dE", ("DE73100500000920019005", .IBANToolsDefaultIBAN)), "4.3");
    XCTAssert(testAndCompare("7878", "10050000", "de", ("DE48100500000780008006", .IBANToolsDefaultIBAN)), "4.4");
    XCTAssert(testAndCompare("8888", "10050000", "dE", ("DE43100500000250030942", .IBANToolsDefaultIBAN)), "4.5");
    XCTAssert(testAndCompare("9595", "10050000", "de", ("DE60100500001653524703", .IBANToolsDefaultIBAN)), "4.6");
    XCTAssert(testAndCompare("97097", "10050000", "dE", ("DE15100500000013044150", .IBANToolsDefaultIBAN)), "4.7");
    XCTAssert(testAndCompare("112233", "10050000", "de", ("DE54100500000630025819", .IBANToolsDefaultIBAN)), "4.8");
    XCTAssert(testAndCompare("336666", "10050000", "dE", ("DE22100500006604058903", .IBANToolsDefaultIBAN)), "4.9");
    XCTAssert(testAndCompare("484848", "10050000", "de", ("DE43100500000920018963", .IBANToolsDefaultIBAN)), "4.10");
    XCTAssert(testAndCompare("12345", "10050000", "de", ("DE77100500000000012345", .IBANToolsDefaultIBAN)), "4.11");

    // Rule 0005.
    /*
    26580070 732502200 DRESDEFF265 DE32265800700732502200 Standard
    26580070 7325022 DRESDEFF265 DE32265800700732502200 verschobenes Konto
    26580070 8732502200 DRESDEFF265 DE60265800708732502200 gültige Kontoart
    26580070 4820379900 DRESDEFF265 DE37265800704820379900 gültige Kontoart
    50080000 1814706100 ungültig Kontoart
    50080000 2814706100 ungültig Kontoart
    50080000 3814706100 ungültig Kontoart
    50080000 4814706100 DRESDEFFXXX DE70500800004814706100 gültige Kontoart
    50080000 5814706100 ungültig Kontoart
    50080000 6814706100 DRESDEFFXXX DE77500800006814706100 gültige Kontoart
    50080000 7814706100 DRESDEFFXXX DE32500800007814706100 gültige Kontoart
    50080000 8814706100 DRESDEFFXXX DE84500800008814706100 gültige Kontoart
    50080000 9814706100 DRESDEFFXXX DE39500800009814706100 gültige Kontoart
    50080000 23165400 DRESDEFFXXX DE42500800000023165400 gültige 6-stellige StammNr
    50080000 231654 DRESDEFFXXX DE42500800000023165400 verschobene 6-stellige St.Nr
    50080000 4350300 DRESDEFFXXX DE21500800000004350300 gültige 5-stellige StammNr
    50080000 43503 DRESDEFFXXX DE21500800000004350300 verschobene 5-stellige St.Nr
    50080000 526400 DRESDEFFXXX ungültig 4-stellige St.Nr
    50089400 526400 DRESDEFFI01 DE49500894000000526400 4-stellige St.Nr, o. PZiffer
    10080000 998761700 DRESDEFF100 D E73100800000998761700 gültiges IT-Konto
    12080000 998761700 gesperrte BLZ/ITKonto
    26580070 43434280 DRESDEFF265 Prüfziffer 10 unzulässig
    26580070 343428000 DRESDEFF265 Prüfziff 10 geschoben unzul.
    26580070 99021000 DRESDEFF265 DE10265800709902100000 Prüfziffer 0 geschoben
    50540028 4217386 COBADEFFXXX DE24505400280421738600 verschobenes Konto
    50540028 4217387 verschoben falsche PZ
    72040046 111198800 COBADEFFXXX DE10720400460111198800 Standard
    72040046 111198700 falsche Prüfziffer
    50540028 420086100 COBADEFFXXX DE46505400280420086100 Standard
    50540028 421573704 COBADEFFXXX DE13505400280421573704 Standard mit U-Kto
    50540028 421679200 COBADEFFXXX DE26505400280421679200 Standard
    65440087 130023500 COBADEFFXXX DE63654400870130023500 Standard
    23040022 104414 COBADEFFXXX DE29230400220010441400 verschobene 6-stellige St.Nr
    23040022 104417 6-stellige St.Nr falsche PZ
    12040000 40050700 COBADEFFXXX DE27120400000040050700 Standard
    23040022 101337 COBADEFFXXX DE73230400220010133700 verschobene 6-stellige St.Nr
    23040022 10503101 COBADEFFXXX DE77230400220010503101 gültige 6-stellige StammNr
    12040000 52065002 COBADEFFXXX DE12120400000052065002 gültige 6-stellige StammNr
    50040000 930125001 COBADEFFXXX DE97500400000930125001 Standard
    70040041 930125000 COBADEFFXXX DE89700400410930125000 Standard
    50040000 930125006 COBADEFFXXX DE59500400000930125006 Standard
    10045050 930125001 gesperrte BLZ
    50040033 930125004 gesperrte BLZ
    70045050 930125007 gesperrte BLZ
    20041111 130023500 COBADEHDXXX DE81200411110130023500 comdirect
    37080040 111 DRESDEFF370 DE69370800400215022000 Spendenkontonummer
    50040000 101010 COBADEFFXXX DE46500400000311011100 Spendenkontonummer
    */
  }
}
