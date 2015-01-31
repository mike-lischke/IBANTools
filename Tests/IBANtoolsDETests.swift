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

class IBANtoolsDETests: XCTestCase {

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  func testAndCompare(account: String, _ bank: String, _ country: String,
    _ expected: (String, IBANToolsResult), _ checkAccount: Bool = false) -> Bool {
    // Account validation is switched off for dummy account numbers used in the tests..
    let result = IBANtools.convertToIBAN(account, bankCode: bank, countryCode: country, validateAccount: checkAccount);
    return result.0 == expected.0 && result.1 == expected.1;
  }

  func testAndCompare(account: String, _ bank: String, _ country: String,
    _ expected: (iban: String, bic: String, ibanResult: IBANToolsResult, bicResult: IBANToolsResult),
    _ checkAccount: Bool = false) -> Bool {

      let ibanResult = IBANtools.convertToIBAN(account, bankCode: bank, countryCode: country, validateAccount: checkAccount);
      if ibanResult.iban.utf16Count == 0 {
        return (ibanResult.iban == expected.iban) && (ibanResult.result == expected.ibanResult);
      }
      let bicResult = IBANtools.bicForBankCode(bank, countryCode: country);
      return (ibanResult.iban == expected.iban) && (ibanResult.result == expected.ibanResult) &&
        (bicResult.bic == expected.bic) && (bicResult.result == expected.bicResult);
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

    // Rule 0005. Extended tests with BIC retrieval. BIC return code is ignored if the IBAN creation already failed.
    XCTAssert(testAndCompare("732502200", "26580070", "de", ("DE32265800700732502200", "DRESDEFF265", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "5.1");
    XCTAssert(testAndCompare("7325022", "26580070", "de", ("DE32265800700732502200", "DRESDEFF265", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "5.2"); // Shifted account.
    XCTAssert(testAndCompare("8732502200", "26580070", "de", ("DE60265800708732502200", "DRESDEFF265", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "5.3"); // Standard.
    XCTAssert(testAndCompare("4820379900", "26580070", "de", ("DE37265800704820379900", "DRESDEFF265", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "5.4"); // Standard.
    XCTAssert(testAndCompare("1814706100", "50080000", "de", ("", "", .IBANToolsBadAccount, .IBANToolsOK), true), "5.5"); // Invalid account type.
    XCTAssert(testAndCompare("2814706100", "50080000", "de", ("", "", .IBANToolsBadAccount, .IBANToolsOK), true), "5.6"); // Invalid account type.
    XCTAssert(testAndCompare( "3814706100", "50080000","de", ("", "", .IBANToolsBadAccount, .IBANToolsOK), true), "5.7"); // Invalid account type.
    XCTAssert(testAndCompare("4814706100", "50080000", "de", ("DE70500800004814706100", "DRESDEFFXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "5.8"); // Standard.
    XCTAssert(testAndCompare("5814706100", "50080000", "de", ("", "", .IBANToolsBadAccount, .IBANToolsOK), true), "5.9"); // Invalid account type.
    XCTAssert(testAndCompare("6814706100", "50080000", "de", ("DE77500800006814706100", "DRESDEFFXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "5.10"); // Standard.
    XCTAssert(testAndCompare("7814706100", "50080000", "de", ("DE32500800007814706100", "DRESDEFFXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "5.11"); // Standard.
    XCTAssert(testAndCompare("8814706100", "50080000", "de", ("DE84500800008814706100", "DRESDEFFXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "5.12"); // Standard.
    XCTAssert(testAndCompare("9814706100", "50080000", "de", ("DE39500800009814706100", "DRESDEFFXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "5.13"); // Standard.
    XCTAssert(testAndCompare("23165400", "50080000", "de", ("DE42500800000023165400", "DRESDEFFXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "5.14"); // Valid 6 digit base number.
    XCTAssert(testAndCompare("231654", "50080000", "de", ("DE42500800000023165400", "DRESDEFFXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "5.15"); // Valid shifted 6 digit base number.
    XCTAssert(testAndCompare("4350300", "50080000", "de", ("DE21500800000004350300", "DRESDEFFXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "5.16"); // Valid 5 digit base number.
    XCTAssert(testAndCompare("43503", "50080000", "de", ("DE21500800000004350300", "DRESDEFFXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "5.17"); // Valid shifted 5 digit base number.
    XCTAssert(testAndCompare("526400", "50080000", "de", ("", "DRESDEFFXXX", .IBANToolsBadAccount, .IBANToolsOK), true), "5.18"); // Invalid 4 digit account without checksum.
    XCTAssert(testAndCompare("526400", "50089400", "de", ("DE49500894000000526400", "DRESDEFFI01", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "5.19"); // Valid 4 digit account without checksum.
    XCTAssert(testAndCompare("998761700", "10080000", "de", ("DE73100800000998761700", "DRESDEFF100", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "5.20"); // Valid IT account
    XCTAssert(testAndCompare("998761700", "12080000", "de", ("", "", .IBANToolsNoConv, .IBANToolsOK), true), "5.21"); // Blocked bank code/IT account.
    XCTAssert(testAndCompare("43434280", "26580070", "de", ("", "DRESDEFF265", .IBANToolsBadAccount, .IBANToolsOK), true), "5.22"); // Checksum position invalid.
    XCTAssert(testAndCompare("343428000", "26580070", "de", ("", "DRESDEFF265", .IBANToolsBadAccount, .IBANToolsOK), true), "5.23"); // Incorrectly shifted checksum position.
    XCTAssert(testAndCompare("99021000", "26580070", "de", ("DE10265800709902100000", "DRESDEFF265", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "5.24"); // Correctly shifted checksum position.
    XCTAssert(testAndCompare("4217386", "50540028", "de", ("DE24505400280421738600", "COBADEFFXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "5.25"); // SHifted account.
    XCTAssert(testAndCompare("4217387", "50540028", "de", ("", "", .IBANToolsBadAccount, .IBANToolsOK), true), "5.26"); // Shifted and wrong checksum.
    XCTAssert(testAndCompare("111198800","72040046",  "de", ("DE10720400460111198800", "COBADEFFXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "5.271"); // Standard.
    XCTAssert(testAndCompare("111198700", "72040046", "de", ("", "", .IBANToolsBadAccount, .IBANToolsOK), true), "5.28"); // Wrong checksum.
    XCTAssert(testAndCompare("420086100", "50540028", "de", ("DE46505400280420086100", "COBADEFFXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "5.29"); // Standard.
    XCTAssert(testAndCompare("421573704", "50540028", "de", ("DE13505400280421573704", "COBADEFFXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "5.30"); // Standard with sub account.
    XCTAssert(testAndCompare("421679200", "50540028", "de", ("DE26505400280421679200", "COBADEFFXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "5.31"); // Standard.
    XCTAssert(testAndCompare("130023500", "65440087", "de", ("DE63654400870130023500", "COBADEFFXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "5.32"); // Standard.
    XCTAssert(testAndCompare("104414", "23040022", "de", ("DE29230400220010441400", "COBADEFFXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "5.33"); // Shifted 6 digit number.
    XCTAssert(testAndCompare("104417", "23040022", "de", ("", "", .IBANToolsBadAccount, .IBANToolsOK), true), "5.34"); // 6 digit number with wrong checksum.
    XCTAssert(testAndCompare("40050700", "12040000", "de", ("DE27120400000040050700", "COBADEFFXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "5.35"); // Standard. Mapped BIC.
    XCTAssert(testAndCompare( "101337", "23040022","de", ("DE73230400220010133700", "COBADEFFXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "5.36"); // Valid and shifted 6 digit base number.
    XCTAssert(testAndCompare("10503101", "23040022", "de", ("DE77230400220010503101", "COBADEFFXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "5.37"); // Valid 6 digit base number.
    XCTAssert(testAndCompare("52065002", "12040000", "de", ("DE12120400000052065002", "COBADEFFXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "5.38"); // Valid 6 digit base number.
    XCTAssert(testAndCompare("930125001", "50040000", "de", ("DE97500400000930125001", "COBADEFFXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "5.39"); // Standard.
    XCTAssert(testAndCompare("930125000","70040041",  "de", ("DE89700400410930125000", "COBADEFFXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "5.40"); // Standard.
    XCTAssert(testAndCompare("930125006", "50040000", "de", ("DE59500400000930125006", "COBADEFFXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "5.41"); // Standard.
    XCTAssert(testAndCompare("930125007", "50040033", "de", ("", "", .IBANToolsNoConv, .IBANToolsOK), true), "5.42"); // Blocked bank code.
    XCTAssert(testAndCompare("130023500", "20041111", "de", ("DE81200411110130023500", "COBADEHDXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "5.43"); // comdirect
    XCTAssert(testAndCompare("111", "37080040", "de", ("DE69370800400215022000", "DRESDEFF370", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "5.44"); // Donation account.
    XCTAssert(testAndCompare("101010", "50040000", "de", ("DE46500400000311011100", "COBADEFFXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "5.45"); // Donation account.
    XCTAssert(testAndCompare("42417704", "15080000", "de", ("DE16150800004241770400", "DRESDEFF150", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "5.46"); // 8 digit base number, checksum at pos 7.
    XCTAssert(testAndCompare("70548200", "12080000", "de", ("DE41120800000070548200", "DRESDEFF120", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "5.47"); // 8 digit base number, checksum at positions 7 and 9.
    XCTAssert(testAndCompare("1186504", "21080050", "de", ("DE95210800500118650400", "DRESDEFF210", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "5.48"); // 7 digit base number, checksum at pos 7.
    XCTAssert(testAndCompare("1186103", "21080050", "de", ("DE58210800500001186103", "DRESDEFF210", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "5.49"); // 7 digit base number, checksum at positions 7 and 9.

    // Rule 0006.
    XCTAssert(testAndCompare("1111111", "70150000", "de", ("DE62701500000020228888", .IBANToolsDefaultIBAN)), "6.1");
    XCTAssert(testAndCompare("7777777", "70150000", "de", ("DE48701500000903286003", .IBANToolsDefaultIBAN)), "6.2");
    XCTAssert(testAndCompare("34343434", "70150000", "de", ("DE30701500001000506517", .IBANToolsDefaultIBAN)), "6.3");
    XCTAssert(testAndCompare("70000", "70150000", "de", ("DE64701500000018180018", .IBANToolsDefaultIBAN)), "6.4");

    // Rule 0007.
    XCTAssert(testAndCompare("111", "37050198", "de", ("DE15370501980000001115", .IBANToolsDefaultIBAN)), "7.2");
    XCTAssert(testAndCompare("221", "37050198", "de", ("DE25370501980023002157", .IBANToolsDefaultIBAN)), "7.3");
    XCTAssert(testAndCompare("1888", "37050198", "de", ("DE15370501980018882068", .IBANToolsDefaultIBAN)), "7.4");
    XCTAssert(testAndCompare("2006", "37050198", "de", ("DE57370501981900668508", .IBANToolsDefaultIBAN)), "7.5");
    XCTAssert(testAndCompare("2626", "37050198", "de", ("DE41370501981900730100", .IBANToolsDefaultIBAN)), "7.6");
    XCTAssert(testAndCompare("3004", "37050198", "de", ("DE39370501981900637016", .IBANToolsDefaultIBAN)), "7.7");
    XCTAssert(testAndCompare("3636", "37050198", "de", ("DE52370501980023002447", .IBANToolsDefaultIBAN)), "7.8");
    XCTAssert(testAndCompare("4000", "37050198", "de", ("DE31370501980000004028", .IBANToolsDefaultIBAN)), "7.9");
    XCTAssert(testAndCompare("4444", "37050198", "de", ("DE12370501980000017368", .IBANToolsDefaultIBAN)), "7.10");
    XCTAssert(testAndCompare("5050", "37050198", "de", ("DE83370501980000073999", .IBANToolsDefaultIBAN)), "7.11");
    XCTAssert(testAndCompare("8888", "37050198", "de", ("DE42370501981901335750", .IBANToolsDefaultIBAN)), "7.12");
    XCTAssert(testAndCompare("30000", "37050198", "de", ("DE22370501980009992959", .IBANToolsDefaultIBAN)), "7.13");
    XCTAssert(testAndCompare("43430", "37050198", "de", ("DE56370501981901693331", .IBANToolsDefaultIBAN)), "7.14");
    XCTAssert(testAndCompare("46664", "37050198", "de", ("DE98370501981900399856", .IBANToolsDefaultIBAN)), "7.15");
    XCTAssert(testAndCompare("55555", "37050198", "de", ("DE81370501980034407379", .IBANToolsDefaultIBAN)), "7.16");
    XCTAssert(testAndCompare("102030", "37050198", "de", ("DE17370501981900480466", .IBANToolsDefaultIBAN)), "7.17");
    XCTAssert(testAndCompare("151515", "37050198", "de", ("DE64370501980057762957", .IBANToolsDefaultIBAN)), "7.18");
    XCTAssert(testAndCompare("222222", "37050198", "de", ("DE85370501980002222222", .IBANToolsDefaultIBAN)), "7.19");
    XCTAssert(testAndCompare("300000", "37050198", "de", ("DE22370501980009992959", .IBANToolsDefaultIBAN)), "7.20");
    XCTAssert(testAndCompare("333333", "37050198", "de", ("DE53370501980000033217", .IBANToolsDefaultIBAN)), "7.21");
    XCTAssert(testAndCompare("414141", "37050198", "de", ("DE83370501980000092817", .IBANToolsDefaultIBAN)), "7.22");
    XCTAssert(testAndCompare("606060", "37050198", "de", ("DE64370501980000091025", .IBANToolsDefaultIBAN)), "7.23");
    XCTAssert(testAndCompare("909090", "37050198", "de", ("DE20370501980000090944", .IBANToolsDefaultIBAN)), "7.24");
    XCTAssert(testAndCompare("2602024", "37050198", "de", ("DE24370501980005602024", .IBANToolsDefaultIBAN)), "7.25");
    XCTAssert(testAndCompare("3000000", "37050198", "de", ("DE22370501980009992959", .IBANToolsDefaultIBAN)), "7.26");
    XCTAssert(testAndCompare("7777777", "37050198", "de", ("DE85370501980002222222", .IBANToolsDefaultIBAN)), "7.27");
    XCTAssert(testAndCompare("8090100", "37050198", "de", ("DE39370501980000038901", .IBANToolsDefaultIBAN)), "7.28");
    XCTAssert(testAndCompare("14141414", "37050198", "de", ("DE96370501980043597665", .IBANToolsDefaultIBAN)), "7.29");
    XCTAssert(testAndCompare("15000023", "37050198", "de", ("DE98370501980015002223", .IBANToolsDefaultIBAN)), "7.30");
    XCTAssert(testAndCompare("15151515", "37050198", "de", ("DE64370501980057762957", .IBANToolsDefaultIBAN)), "7.31");
    XCTAssert(testAndCompare("22222222", "37050198", "de", ("DE85370501980002222222", .IBANToolsDefaultIBAN)), "7.32");
    XCTAssert(testAndCompare("200820082", "37050198", "de", ("DE54370501981901783868", .IBANToolsDefaultIBAN)), "7.33");
    XCTAssert(testAndCompare("222220022", "37050198", "de", ("DE85370501980002222222", .IBANToolsDefaultIBAN)), "7.34");

    // Rule 0008.
    XCTAssert(testAndCompare("38000", "50020200", "de", ("DE80500202000000038000", "BHFBDEFF500", .IBANToolsDefaultIBAN, .IBANToolsOK)), "8.1");
    XCTAssert(testAndCompare("30009963", "51020000", "de", ("DE46500202000030009963", "BHFBDEFF500", .IBANToolsDefaultIBAN, .IBANToolsOK)), "8.2");
    XCTAssert(testAndCompare("40033086", "30020500", "de", ("DE02500202000040033086", "BHFBDEFF500", .IBANToolsDefaultIBAN, .IBANToolsOK)), "8.2");
    XCTAssert(testAndCompare("50017409", "20120200", "de", ("DE55500202000050017409", "BHFBDEFF500", .IBANToolsDefaultIBAN, .IBANToolsOK)), "8.4");
    XCTAssert(testAndCompare("55036107", "70220200", "de", ("DE38500202000055036107", "BHFBDEFF500", .IBANToolsDefaultIBAN, .IBANToolsOK)), "8.5");
    XCTAssert(testAndCompare("70049754", "10020200", "de", ("DE98500202000070049754", "BHFBDEFF500", .IBANToolsDefaultIBAN, .IBANToolsOK)), "8.6");

    // Rule 0009.
    XCTAssert(testAndCompare("1116232594", "683 519 76", "de", ("DE03683515573047232594", "SOLADES1SFH", .IBANToolsDefaultIBAN, .IBANToolsOK)), "9.1");
    XCTAssert(testAndCompare("0016005845", "683 519 76", "de", ("DE10683515570016005845", "SOLADES1SFH", .IBANToolsDefaultIBAN, .IBANToolsOK)), "9.2");

    // Rule 0010.
    XCTAssert(testAndCompare("2000", "500 502 01", "de", ("DE42500502010000222000", .IBANToolsDefaultIBAN)), "10.1");
    XCTAssert(testAndCompare("800000", "500 502 01", "de", ("DE89500502010000180802", .IBANToolsDefaultIBAN)), "10.2");
    XCTAssert(testAndCompare("1241539870", "500 502 22", "de", ("DE45500502011241539870", .IBANToolsDefaultIBAN)), "10.3");

  }
}
