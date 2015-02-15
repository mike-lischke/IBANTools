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

  func testAndCompare(var account: String, var _ bank: String, _ country: String,
    _ expected: (String, IBANToolsResult), _ checkAccount: Bool = false) -> Bool {
    // Account validation is switched off for dummy account numbers used in the tests..
    let conversionResult = IBANtools.convertToIBAN(&account, bankCode: &bank, countryCode: country, validateAccount: checkAccount);
    let result = conversionResult.0 == expected.0 && conversionResult.1 == expected.1;
    if !result {
      println("\naccount: \(account), bank: \(bank), expected: (\(expected.0), " +
        "\(expected.1.description())), actual: (\(conversionResult.iban), " +
        "\(conversionResult.result.description()))\n");
    }
    return result;
  }

  func testAndCompare(var account: String, var _ bank: String, _ country: String,
    _ expected: (iban: String, bic: String, ibanResult: IBANToolsResult, bicResult: IBANToolsResult),
    _ checkAccount: Bool = false) -> Bool {

      let ibanResult = IBANtools.convertToIBAN(&account, bankCode: &bank, countryCode: country, validateAccount: checkAccount);
      if ibanResult.iban.utf16Count == 0 {
        let result = (ibanResult.iban == expected.iban) && (ibanResult.result == expected.ibanResult);
        if !result {
          println("\naccount: \(account), bank: \(bank), expected: (\(expected.0), " +
            "\(expected.ibanResult.description())), actual: (\(ibanResult.iban), " +
            "\(ibanResult.result.description()))\n");
        }
        return result;
      }

      let bicResult = IBANtools.bicForBankCode(bank, countryCode: country);
      let result = (ibanResult.iban == expected.iban) && (ibanResult.result == expected.ibanResult) &&
        (bicResult.bic == expected.bic) && (bicResult.result == expected.bicResult);

      if !result {
        println("\naccount: \(account), bank: \(bank), expected: (\(expected.iban), \(expected.bic), " +
          "\(expected.ibanResult.description()), \(expected.bicResult.description())), " +
          "actual: (\(ibanResult.iban), \(bicResult.bic), \(ibanResult.result.description()), " +
          "\(bicResult.result.description()))\n");
      }
      return result;
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
    XCTAssert(testAndCompare("12645", "72020700", "de", ("", .IBANToolsNoConv)), "2.3");
    XCTAssert(testAndCompare("12865", "72020700", "de", ("", .IBANToolsNoConv)), "2.4");

    // Rule 0003.
    XCTAssert(testAndCompare("6161604670", "51010800", "dE", ("", .IBANToolsNoConv)), "3.1");
    XCTAssert(testAndCompare("12345", "51010800", "de", ("DE87510108000000012345", .IBANToolsDefaultIBAN)), "3.2");

    // Rule 0004.
    XCTAssert(testAndCompare("135", "10050000", "dE", ("DE86100500000990021440", .IBANToolsDefaultIBAN), true), "4.1");
    XCTAssert(testAndCompare("1111", "10050000", "de", ("DE19100500006600012020", .IBANToolsDefaultIBAN), true), "4.2");
    XCTAssert(testAndCompare("1900", "10050000", "dE", ("DE73100500000920019005", .IBANToolsDefaultIBAN), true), "4.3");
    XCTAssert(testAndCompare("7878", "10050000", "de", ("DE48100500000780008006", .IBANToolsDefaultIBAN), true), "4.4");
    XCTAssert(testAndCompare("8888", "10050000", "dE", ("DE43100500000250030942", .IBANToolsDefaultIBAN), true), "4.5");
    XCTAssert(testAndCompare("9595", "10050000", "de", ("DE60100500001653524703", .IBANToolsDefaultIBAN), true), "4.6");
    XCTAssert(testAndCompare("97097", "10050000", "dE", ("DE15100500000013044150", .IBANToolsDefaultIBAN), true), "4.7");
    XCTAssert(testAndCompare("112233", "10050000", "de", ("DE54100500000630025819", .IBANToolsDefaultIBAN), true), "4.8");
    XCTAssert(testAndCompare("336666", "10050000", "dE", ("DE22100500006604058903", .IBANToolsDefaultIBAN), true), "4.9");
    XCTAssert(testAndCompare("484848", "10050000", "de", ("DE43100500000920018963", .IBANToolsDefaultIBAN), true), "4.10");

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
    XCTAssert(testAndCompare("1111111", "70150000", "de", ("DE62701500000020228888", .IBANToolsDefaultIBAN), true), "6.1");
    XCTAssert(testAndCompare("7777777", "70150000", "de", ("DE48701500000903286003", .IBANToolsDefaultIBAN), true), "6.2");
    XCTAssert(testAndCompare("34343434", "70150000", "de", ("DE30701500001000506517", .IBANToolsDefaultIBAN), true), "6.3");
    XCTAssert(testAndCompare("70000", "70150000", "de", ("DE64701500000018180018", .IBANToolsDefaultIBAN), true), "6.4");

    // Rule 0007.
    XCTAssert(testAndCompare("111", "37050198", "de", ("DE15370501980000001115", .IBANToolsDefaultIBAN), true), "7.2");
    XCTAssert(testAndCompare("221", "37050198", "de", ("DE25370501980023002157", .IBANToolsDefaultIBAN), true), "7.3");
    XCTAssert(testAndCompare("1888", "37050198", "de", ("DE15370501980018882068", .IBANToolsDefaultIBAN), true), "7.4");
    XCTAssert(testAndCompare("2006", "37050198", "de", ("DE57370501981900668508", .IBANToolsDefaultIBAN), true), "7.5");
    XCTAssert(testAndCompare("2626", "37050198", "de", ("DE41370501981900730100", .IBANToolsDefaultIBAN), true), "7.6");
    XCTAssert(testAndCompare("3004", "37050198", "de", ("DE39370501981900637016", .IBANToolsDefaultIBAN), true), "7.7");
    XCTAssert(testAndCompare("3636", "37050198", "de", ("DE52370501980023002447", .IBANToolsDefaultIBAN), true), "7.8");
    XCTAssert(testAndCompare("4000", "37050198", "de", ("DE31370501980000004028", .IBANToolsDefaultIBAN), true), "7.9");
    XCTAssert(testAndCompare("4444", "37050198", "de", ("DE12370501980000017368", .IBANToolsDefaultIBAN), true), "7.10");
    XCTAssert(testAndCompare("5050", "37050198", "de", ("DE83370501980000073999", .IBANToolsDefaultIBAN), true), "7.11");
    XCTAssert(testAndCompare("8888", "37050198", "de", ("DE42370501981901335750", .IBANToolsDefaultIBAN), true), "7.12");
    XCTAssert(testAndCompare("30000", "37050198", "de", ("DE22370501980009992959", .IBANToolsDefaultIBAN), true), "7.13");
    XCTAssert(testAndCompare("43430", "37050198", "de", ("DE56370501981901693331", .IBANToolsDefaultIBAN), true), "7.14");
    XCTAssert(testAndCompare("46664", "37050198", "de", ("DE98370501981900399856", .IBANToolsDefaultIBAN), true), "7.15");
    XCTAssert(testAndCompare("55555", "37050198", "de", ("DE81370501980034407379", .IBANToolsDefaultIBAN), true), "7.16");
    XCTAssert(testAndCompare("102030", "37050198", "de", ("DE17370501981900480466", .IBANToolsDefaultIBAN), true), "7.17");
    XCTAssert(testAndCompare("151515", "37050198", "de", ("DE64370501980057762957", .IBANToolsDefaultIBAN), true), "7.18");
    XCTAssert(testAndCompare("222222", "37050198", "de", ("DE85370501980002222222", .IBANToolsDefaultIBAN), true), "7.19");
    XCTAssert(testAndCompare("300000", "37050198", "de", ("DE22370501980009992959", .IBANToolsDefaultIBAN), true), "7.20");
    XCTAssert(testAndCompare("333333", "37050198", "de", ("DE53370501980000033217", .IBANToolsDefaultIBAN), true), "7.21");
    XCTAssert(testAndCompare("414141", "37050198", "de", ("DE83370501980000092817", .IBANToolsDefaultIBAN), true), "7.22");
    XCTAssert(testAndCompare("606060", "37050198", "de", ("DE64370501980000091025", .IBANToolsDefaultIBAN), true), "7.23");
    XCTAssert(testAndCompare("909090", "37050198", "de", ("DE20370501980000090944", .IBANToolsDefaultIBAN), true), "7.24");
    XCTAssert(testAndCompare("2602024", "37050198", "de", ("DE24370501980005602024", .IBANToolsDefaultIBAN), true), "7.25");
    XCTAssert(testAndCompare("3000000", "37050198", "de", ("DE22370501980009992959", .IBANToolsDefaultIBAN), true), "7.26");
    XCTAssert(testAndCompare("7777777", "37050198", "de", ("DE85370501980002222222", .IBANToolsDefaultIBAN), true), "7.27");
    XCTAssert(testAndCompare("8090100", "37050198", "de", ("DE39370501980000038901", .IBANToolsDefaultIBAN), true), "7.28");
    XCTAssert(testAndCompare("14141414", "37050198", "de", ("DE96370501980043597665", .IBANToolsDefaultIBAN), true), "7.29");
    XCTAssert(testAndCompare("15000023", "37050198", "de", ("DE98370501980015002223", .IBANToolsDefaultIBAN), true), "7.30");
    XCTAssert(testAndCompare("15151515", "37050198", "de", ("DE64370501980057762957", .IBANToolsDefaultIBAN), true), "7.31");
    XCTAssert(testAndCompare("22222222", "37050198", "de", ("DE85370501980002222222", .IBANToolsDefaultIBAN), true), "7.32");
    XCTAssert(testAndCompare("200820082", "37050198", "de", ("DE54370501981901783868", .IBANToolsDefaultIBAN), true), "7.33");
    XCTAssert(testAndCompare("222220022", "37050198", "de", ("DE85370501980002222222", .IBANToolsDefaultIBAN), true), "7.34");

    // Rule 0008.
    XCTAssert(testAndCompare("38000", "50020200", "de", ("DE80500202000000038000", "BHFBDEFF500", .IBANToolsDefaultIBAN, .IBANToolsOK)), "8.1");
    XCTAssert(testAndCompare("30009963", "51020000", "de", ("DE46500202000030009963", "BHFBDEFF500", .IBANToolsDefaultIBAN, .IBANToolsOK)), "8.2");
    XCTAssert(testAndCompare("40033086", "30020500", "de", ("DE02500202000040033086", "BHFBDEFF500", .IBANToolsDefaultIBAN, .IBANToolsOK)), "8.2");
    XCTAssert(testAndCompare("50017409", "20120200", "de", ("DE55500202000050017409", "BHFBDEFF500", .IBANToolsDefaultIBAN, .IBANToolsOK)), "8.4");
    XCTAssert(testAndCompare("55036107", "70220200", "de", ("DE38500202000055036107", "BHFBDEFF500", .IBANToolsDefaultIBAN, .IBANToolsOK)), "8.5");
    XCTAssert(testAndCompare("70049754", "10020200", "de", ("DE98500202000070049754", "BHFBDEFF500", .IBANToolsDefaultIBAN, .IBANToolsOK)), "8.6");

    // Rule 0009.
    XCTAssert(testAndCompare("1116232594", "683 519 76", "de", ("DE03683515573047232594", "SOLADES1SFH", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "9.1");
    XCTAssert(testAndCompare("0016005845", "683 519 76", "de", ("DE10683515570016005845", "SOLADES1SFH", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "9.2");

    // Rule 0010.
    XCTAssert(testAndCompare("2000", "500 502 01", "de", ("DE42500502010000222000", .IBANToolsDefaultIBAN), true), "10.1");
    XCTAssert(testAndCompare("800000", "500 502 01", "de", ("DE89500502010000180802", .IBANToolsDefaultIBAN), true), "10.2");
    XCTAssert(testAndCompare("1241539870", "500 502 22", "de", ("DE45500502011241539870", .IBANToolsDefaultIBAN), true), "10.3");

    // Rule 0011.
    XCTAssert(testAndCompare("1000", "32050000", "de", ("DE44320500000008010001", .IBANToolsDefaultIBAN), true), "11.1");
    XCTAssert(testAndCompare("47800", "32050000", "de", ("DE36320500000000047803", .IBANToolsDefaultIBAN), true), "11.2");

    // Rule 0012.
    XCTAssert(testAndCompare("5000002096", "50850049", "de", ("DE95500500005000002096", "HELADEFFXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "12.1");

    // Rule 0013.
    XCTAssert(testAndCompare("60624", "40050000", "de", ("DE15300500000000060624", "WELADEDDXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "13.1");

    // Rule 0014.
    XCTAssert(testAndCompare("60624", "10090603", "de", ("DE25300606010000060624", "DAAEDEDDXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "14.1");
    XCTAssert(testAndCompare("60624", "12090640", "de", ("DE25300606010000060624", "DAAEDEDDXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "14.2");
    XCTAssert(testAndCompare("60624", "20090602", "de", ("DE25300606010000060624", "DAAEDEDDXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "14.3");
    XCTAssert(testAndCompare("60624", "21090619", "de", ("DE25300606010000060624", "DAAEDEDDXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "14.4");
    XCTAssert(testAndCompare("60624", "23092620", "de", ("DE25300606010000060624", "DAAEDEDDXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "14.5");
    XCTAssert(testAndCompare("60624", "25090608", "de", ("DE25300606010000060624", "DAAEDEDDXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "14.6");
    XCTAssert(testAndCompare("60624", "26560625", "de", ("DE25300606010000060624", "DAAEDEDDXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "14.7");
    XCTAssert(testAndCompare("60624", "27090618", "de", ("DE25300606010000060624", "DAAEDEDDXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "14.8");
    XCTAssert(testAndCompare("60624", "28090633", "de", ("DE25300606010000060624", "DAAEDEDDXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "14.9");
    XCTAssert(testAndCompare("60624", "29090605", "de", ("DE25300606010000060624", "DAAEDEDDXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "14.10");
    XCTAssert(testAndCompare("60624", "30060601", "de", ("DE25300606010000060624", "DAAEDEDDXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "14.11");
    XCTAssert(testAndCompare("60624", "33060616", "de", ("DE25300606010000060624", "DAAEDEDDXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "14.12");
    XCTAssert(testAndCompare("60624", "35060632", "de", ("DE25300606010000060624", "DAAEDEDDXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "14.13");
    XCTAssert(testAndCompare("60624", "76090613", "de", ("DE25300606010000060624", "DAAEDEDDXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "14.14");
    XCTAssert(testAndCompare("60624", "79090624", "de", ("DE25300606010000060624", "DAAEDEDDXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "14.15");

    // Rule 0015.
    XCTAssert(testAndCompare("94", "37060193", "de", ("DE17370601933008888018", .IBANToolsDefaultIBAN), true), "15.1");
    XCTAssert(testAndCompare("556", "37060193", "de", ("DE75370601930000101010", .IBANToolsDefaultIBAN), true), "15.2");
    XCTAssert(testAndCompare("888", "37060193", "de", ("DE94370601930031870011", .IBANToolsDefaultIBAN), true), "15.3");
    XCTAssert(testAndCompare("4040", "37060193", "de", ("DE13370601934003600101", .IBANToolsDefaultIBAN), true), "15.4");
    XCTAssert(testAndCompare("5826", "37060193", "de", ("DE49370601931015826017", .IBANToolsDefaultIBAN), true), "15.5");
    XCTAssert(testAndCompare("25000", "37060193", "de", ("DE44370601930025000110", .IBANToolsDefaultIBAN), true), "15.6");
    XCTAssert(testAndCompare("393393", "37060193", "de", ("DE10370601930033013019", .IBANToolsDefaultIBAN), true), "15.7");
    XCTAssert(testAndCompare("444555", "37060193", "de", ("DE38370601930032230016", .IBANToolsDefaultIBAN), true), "15.8");
    XCTAssert(testAndCompare("603060", "37060193", "de", ("DE98370601936002919018", .IBANToolsDefaultIBAN), true), "15.9");
    XCTAssert(testAndCompare("2120041", "37060193", "de", ("DE92370601930002130041", .IBANToolsDefaultIBAN), true), "15.10");
    XCTAssert(testAndCompare("80868086", "37060193", "de", ("DE42370601934007375013", .IBANToolsDefaultIBAN), true), "15.11");
    XCTAssert(testAndCompare("400569017", "37060193", "de", ("DE90370601934000569017", .IBANToolsDefaultIBAN), true), "15.12");

    // Rule 0016.
    XCTAssert(testAndCompare("300000", "37160087", "de", ("DE68371600870018128012", .IBANToolsDefaultIBAN), true), "16.1");

    // Rule 0017.
    XCTAssert(testAndCompare("100", "38060186", "de", ("DE43380601862009090013", .IBANToolsDefaultIBAN), true), "17.1");
    XCTAssert(testAndCompare("111", "38060186", "de", ("DE38380601862111111017", .IBANToolsDefaultIBAN), true), "17.2");
    XCTAssert(testAndCompare("240", "38060186", "de", ("DE77380601862100240010", .IBANToolsDefaultIBAN), true), "17.3");
    XCTAssert(testAndCompare("4004", "38060186", "de", ("DE23380601862204004016", .IBANToolsDefaultIBAN), true), "17.4");
    XCTAssert(testAndCompare("4444", "38060186", "de", ("DE04380601862044444014", .IBANToolsDefaultIBAN), true), "17.5");
    XCTAssert(testAndCompare("6060", "38060186", "de", ("DE07380601862016060014", .IBANToolsDefaultIBAN), true), "17.6");
    XCTAssert(testAndCompare("102030", "38060186", "de", ("DE16380601861102030016", .IBANToolsDefaultIBAN), true), "17.7");
    XCTAssert(testAndCompare("333333", "38060186", "de", ("DE06380601862033333016", .IBANToolsDefaultIBAN), true), "17.8");
    XCTAssert(testAndCompare("909090", "38060186", "de", ("DE43380601862009090013", .IBANToolsDefaultIBAN), true), "17.9");
    XCTAssert(testAndCompare("50005000", "38060186", "de", ("DE95380601865000500013", .IBANToolsDefaultIBAN), true), "17.10");

    // Rule 0018.
    XCTAssert(testAndCompare("556", "39060180", "de", ("DE05390601800120440110", .IBANToolsDefaultIBAN), true), "18.1");
    XCTAssert(testAndCompare("5435435430", "39060180", "de", ("DE37390601800543543543", .IBANToolsDefaultIBAN), true), "18.2");
    XCTAssert(testAndCompare("2157", "39060180", "de", ("DE07390601800121787016", .IBANToolsDefaultIBAN), true), "18.3");
    XCTAssert(testAndCompare("9800", "39060180", "de", ("DE19390601800120800019", .IBANToolsDefaultIBAN), true), "18.4");
    XCTAssert(testAndCompare("202050", "39060180", "de", ("DE61390601801221864014", .IBANToolsDefaultIBAN), true), "18.5");

    // Rule 0019.
    XCTAssert(testAndCompare("20475000", "50120383", "de", ("DE82501203830020475000", "DELBDE33XXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "19.1");
    XCTAssert(testAndCompare("20475000", "50130100", "de", ("DE82501203830020475000", "DELBDE33XXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "19.2");
    XCTAssert(testAndCompare("20475000", "50220200", "de", ("DE82501203830020475000", "DELBDE33XXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "19.3");
    XCTAssert(testAndCompare("20475000", "70030800", "de", ("DE82501203830020475000", "DELBDE33XXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "19.4");

    // Rule 0020.
    XCTAssert(testAndCompare("9999", "50070010", "de", ("DE80500700100092777202", .IBANToolsDefaultIBAN), true), "20.1");
    XCTAssert(testAndCompare("38150900", "23070700", "de", ("DE07230707000038150900", .IBANToolsDefaultIBAN), true), "20.2");
    XCTAssert(testAndCompare("600103660", "23070700", "de", ("DE64230707000600103660", .IBANToolsDefaultIBAN), true), "20.3");
    XCTAssert(testAndCompare("39101181", "23070700", "de", ("DE84230707000039101181", .IBANToolsDefaultIBAN), true), "20.4");
    XCTAssert(testAndCompare("117", "23070700", "de", ("", .IBANToolsNoConv), true), "20.5"); // Account valid but too short.
    XCTAssert(testAndCompare("500", "23070700", "de", ("", .IBANToolsBadAccount), true), "20.6"); // Doc says this is a valid account, but it isn't (according to account rule 63).
    XCTAssert(testAndCompare("1800", "23070700", "de", ("", .IBANToolsNoConv), true), "20.7"); // Account valid but too short.
    XCTAssert(testAndCompare("56002", "23070700", "de", ("DE19230707000005600200", .IBANToolsDefaultIBAN), true), "20.8");
    XCTAssert(testAndCompare("752691", "23070700", "de", ("DE94230707000075269100", .IBANToolsDefaultIBAN), true), "20.9");
    XCTAssert(testAndCompare("3700246", "23070700", "de", ("DE36230707000003700246", .IBANToolsDefaultIBAN), true), "20.10");
    XCTAssert(testAndCompare("6723143", "23070700", "de", ("DE42230707000006723143", .IBANToolsDefaultIBAN), true), "20.11");
    XCTAssert(testAndCompare("5719083", "23070700", "de", ("DE63230707000571908300", .IBANToolsDefaultIBAN), true), "20.12");
    XCTAssert(testAndCompare("8007759", "23070700", "de", ("DE21230707000800775900", .IBANToolsDefaultIBAN), true), "20.13");
    XCTAssert(testAndCompare("3500022", "23070700", "de", ("DE94230707000350002200", .IBANToolsDefaultIBAN), true), "20.14");
    XCTAssert(testAndCompare("9000043", "23070700", "de", ("DE90230707000900004300", .IBANToolsDefaultIBAN), true), "20.15");
    XCTAssert(testAndCompare("94012341", "23070700", "de", ("", .IBANToolsBadAccount), true), "20.16");
    XCTAssert(testAndCompare("123456700", "23070700", "de", ("", .IBANToolsBadAccount), true), "20.17");
    XCTAssert(testAndCompare("5073321010", "23070700", "de", ("", .IBANToolsBadAccount), true), "20.18");
    XCTAssert(testAndCompare("1415900000", "23070700", "de", ("", .IBANToolsBadAccount), true), "20.19");
    XCTAssert(testAndCompare("1000300004", "23070700", "de", ("", .IBANToolsBadAccount), true), "20.20");
    XCTAssert(testAndCompare("94012341", "76026000", "de", ("", .IBANToolsNoConv), true), "20.21"); // Account valid but not allowed for IBAN.
    XCTAssert(testAndCompare("5073321010", "76026000", "de", ("", .IBANToolsNoConv), true), "20.22"); // ditto
    XCTAssert(testAndCompare("1234517892", "76026000", "de", ("", .IBANToolsBadAccount), true), "20.23");
    XCTAssert(testAndCompare("987614325", "76026000", "de", ("", .IBANToolsBadAccount), true), "20.24");

    // Rule 0021.
    XCTAssert(testAndCompare("305200", "350 200 30", "de", ("DE81360200300000305200", "NBAGDE3EXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "21.1");
    XCTAssert(testAndCompare("900826", "350 200 30", "de", ("DE03360200300000900826", "NBAGDE3EXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "21.2");
    XCTAssert(testAndCompare("705020", "350 200 30", "de", ("DE71360200300000705020", "NBAGDE3EXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "21.3");
    XCTAssert(testAndCompare("9197354", "350 200 30", "de", ("DE18360200300009197354", "NBAGDE3EXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "21.4");

    // Rule 0022.
    XCTAssert(testAndCompare("1111111", "43060967", "de", ("DE22430609672222200000", .IBANToolsDefaultIBAN), true), "22.1");

    // Rule 0023.
    XCTAssert(testAndCompare("700", "265 900 25", "de", ("DE76265900251000700800", .IBANToolsDefaultIBAN), true), "23.1");

    // Rule 0024.
    XCTAssert(testAndCompare("94", "36060295", "de", ("DE48360602950000001694", .IBANToolsDefaultIBAN), false), "24.1");
    XCTAssert(testAndCompare("248", "36060295", "de", ("DE03360602950000017248", .IBANToolsDefaultIBAN), true), "24.2");
    XCTAssert(testAndCompare("345", "36060295", "de", ("DE03360602950000017345", .IBANToolsDefaultIBAN), false), "24.3");
    XCTAssert(testAndCompare("400", "36060295", "de", ("DE75360602950000014400", .IBANToolsDefaultIBAN), true), "24.4");

    // Rule 0025.
    XCTAssert(testAndCompare("2777939", "60250184", "de", ("DE81600501010002777939", .IBANToolsDefaultIBAN), false), "25.1");
    XCTAssert(testAndCompare("7893500686", "644 502 88", "de", ("DE80600501017893500686", .IBANToolsDefaultIBAN), true), "25.2");

    // Rule 0026.
    XCTAssert(testAndCompare("55111", "35060190", "de", ("DE21350601900000055111", .IBANToolsDefaultIBAN), false), "26.1");
    XCTAssert(testAndCompare("8090100", "35060190", "de", ("DE86350601900008090100", .IBANToolsDefaultIBAN), true), "26.2");

    // Rule 0027.
    XCTAssert(testAndCompare("3333", "32060362", "de", ("DE47320603620000003333", .IBANToolsDefaultIBAN), false), "27.1");
    XCTAssert(testAndCompare("4444", "32060362", "de", ("DE23320603620000004444", .IBANToolsDefaultIBAN), true), "27.2");

    // Rule 0028.
    XCTAssert(testAndCompare("17095", "250 502 99", "de", ("DE69250501800000017095", "SPKHDE2HXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "28.1");

    // Rule 0029.
    XCTAssert(testAndCompare("2600123456", "51210800", "de", ("DE02512108000260123456", .IBANToolsDefaultIBAN), false), "29.1");
    XCTAssert(testAndCompare("1410123456", "51210800", "de", ("DE35512108000141123456", .IBANToolsDefaultIBAN), true), "29.2");
    XCTAssert(testAndCompare("123456", "51210800", "de", ("DE04512108000000123456", .IBANToolsDefaultIBAN), false), "29.3");

    // Rule 0030.
    XCTAssert(testAndCompare("1718190", "13091054", "de", ("DE47130910540001718190", .IBANToolsDefaultIBAN), true), "30.1");
    XCTAssert(testAndCompare("22000225", "13091054", "de", ("DE57130910540022000225", .IBANToolsDefaultIBAN), true), "30.2");
    XCTAssert(testAndCompare("49902271", "13091054", "de", ("DE68130910540049902271", .IBANToolsDefaultIBAN), true), "30.3");
    XCTAssert(testAndCompare("49902280", "13091054", "de", ("DE19130910540049902280", .IBANToolsDefaultIBAN), true), "30.4");
    XCTAssert(testAndCompare("101680029", "13091054", "de", ("DE07130910540101680029", .IBANToolsDefaultIBAN), true), "30.5");
    XCTAssert(testAndCompare("104200028", "13091054", "de", ("DE05130910540104200028", .IBANToolsDefaultIBAN), true), "30.6");
    XCTAssert(testAndCompare("106200025", "13091054", "de", ("DE83130910540106200025", .IBANToolsDefaultIBAN), true), "30.7");
    XCTAssert(testAndCompare("108000171", "13091054", "de", ("DE28130910540108000171", .IBANToolsDefaultIBAN), true), "30.8");
    XCTAssert(testAndCompare("108000279", "13091054", "de", ("DE22130910540108000279", .IBANToolsDefaultIBAN), true), "30.9");
    XCTAssert(testAndCompare("108001364", "13091054", "de", ("DE21130910540108001364", .IBANToolsDefaultIBAN), true), "30.10");
    XCTAssert(testAndCompare("108001801", "13091054", "de", ("DE56130910540108001801", .IBANToolsDefaultIBAN), true), "30.11");
    XCTAssert(testAndCompare("108002514", "13091054", "de", ("DE11130910540108002514", .IBANToolsDefaultIBAN), true), "30.12");
    XCTAssert(testAndCompare("300008542", "13091054", "de", ("DE24130910540300008542", .IBANToolsDefaultIBAN), true), "30.13");
    XCTAssert(testAndCompare("9130099995", "13091054", "de", ("DE69130910549130099995", .IBANToolsDefaultIBAN), true), "30.14");
    XCTAssert(testAndCompare("9130500002", "13091054", "de", ("DE54130910549130500002", .IBANToolsDefaultIBAN), true), "30.15");
    XCTAssert(testAndCompare("9131100008", "13091054", "de", ("DE56130910549131100008", .IBANToolsDefaultIBAN), true), "30.16");
    XCTAssert(testAndCompare("9131600000", "13091054", "de", ("DE53130910549131600000", .IBANToolsDefaultIBAN), true), "30.17");
    XCTAssert(testAndCompare("9131610006", "13091054", "de", ("DE36130910549131610006", .IBANToolsDefaultIBAN), true), "30.18");
    XCTAssert(testAndCompare("9132200006", "13091054", "de", ("DE55130910549132200006", .IBANToolsDefaultIBAN), true), "30.19");
    XCTAssert(testAndCompare("9132400005", "13091054", "de", ("DE72130910549132400005", .IBANToolsDefaultIBAN), true), "30.20");
    XCTAssert(testAndCompare("9132600004", "13091054", "de", ("DE89130910549132600004", .IBANToolsDefaultIBAN), true), "30.21");
    XCTAssert(testAndCompare("9132700017", "13091054", "de", ("DE24130910549132700017", .IBANToolsDefaultIBAN), true), "30.22");
    XCTAssert(testAndCompare("9132700025", "13091054", "de", ("DE02130910549132700025", .IBANToolsDefaultIBAN), true), "30.23");
    XCTAssert(testAndCompare("9132700033", "13091054", "de", ("DE77130910549132700033", .IBANToolsDefaultIBAN), true), "30.24");
    XCTAssert(testAndCompare("9132700041", "13091054", "de", ("DE55130910549132700041", .IBANToolsDefaultIBAN), true), "30.25");
    XCTAssert(testAndCompare("9133200700", "13091054", "de", ("DE85130910549133200700", .IBANToolsDefaultIBAN), true), "30.26");
    XCTAssert(testAndCompare("9133200735", "13091054", "de", ("DE13130910549133200735", .IBANToolsDefaultIBAN), true), "30.27");
    XCTAssert(testAndCompare("9133200743", "13091054", "de", ("DE88130910549133200743", .IBANToolsDefaultIBAN), true), "30.28");
    XCTAssert(testAndCompare("9133200751", "13091054", "de", ("DE66130910549133200751", .IBANToolsDefaultIBAN), true), "30.29");
    XCTAssert(testAndCompare("9133200786", "13091054", "de", ("DE91130910549133200786", .IBANToolsDefaultIBAN), true), "30.30");
    XCTAssert(testAndCompare("9133200808", "13091054", "de", ("DE79130910549133200808", .IBANToolsDefaultIBAN), true), "30.31");
    XCTAssert(testAndCompare("9133200816", "13091054", "de", ("DE57130910549133200816", .IBANToolsDefaultIBAN), true), "30.32");
    XCTAssert(testAndCompare("9133200824", "13091054", "de", ("DE35130910549133200824", .IBANToolsDefaultIBAN), true), "30.33");
    XCTAssert(testAndCompare("9133200832", "13091054", "de", ("DE13130910549133200832", .IBANToolsDefaultIBAN), true), "30.34");
    XCTAssert(testAndCompare("9136700003", "13091054", "de", ("DE08130910549136700003", .IBANToolsDefaultIBAN), true), "30.35");
    XCTAssert(testAndCompare("9177300010", "13091054", "de", ("DE20130910549177300010", .IBANToolsDefaultIBAN), true), "30.36");
    XCTAssert(testAndCompare("9177300060", "13091054", "de", ("DE28130910549177300060", .IBANToolsDefaultIBAN), true), "30.37");
    XCTAssert(testAndCompare("9198100002", "13091054", "de", ("DE69130910549198100002", .IBANToolsDefaultIBAN), true), "30.38");
    XCTAssert(testAndCompare("9198200007", "13091054", "de", ("DE26130910549198200007", .IBANToolsDefaultIBAN), true), "30.39");
    XCTAssert(testAndCompare("9198200104", "13091054", "de", ("DE26130910549198200104", .IBANToolsDefaultIBAN), true), "30.40");
    XCTAssert(testAndCompare("9198300001", "13091054", "de", ("DE86130910549198300001", .IBANToolsDefaultIBAN), true), "30.41");
    XCTAssert(testAndCompare("9331300141", "13091054", "de", ("DE35130910549331300141", .IBANToolsDefaultIBAN), true), "30.42");
    XCTAssert(testAndCompare("9331300150", "13091054", "de", ("DE83130910549331300150", .IBANToolsDefaultIBAN), true), "30.43");
    XCTAssert(testAndCompare("9331401010", "13091054", "de", ("DE41130910549331401010", .IBANToolsDefaultIBAN), true), "30.44");
    XCTAssert(testAndCompare("9331401061", "13091054", "de", ("DE22130910549331401061", .IBANToolsDefaultIBAN), true), "30.45");
    XCTAssert(testAndCompare("9349010000", "13091054", "de", ("DE95130910549349010000", .IBANToolsDefaultIBAN), true), "30.46");
    XCTAssert(testAndCompare("9349100000", "13091054", "de", ("DE42130910549349100000", .IBANToolsDefaultIBAN), true), "30.47");
    XCTAssert(testAndCompare("9360500001", "13091054", "de", ("DE27130910549360500001", .IBANToolsDefaultIBAN), true), "30.48");
    XCTAssert(testAndCompare("9364902007", "13091054", "de", ("DE62130910549364902007", .IBANToolsDefaultIBAN), true), "30.49");
    XCTAssert(testAndCompare("9366101001", "13091054", "de", ("DE04130910549366101001", .IBANToolsDefaultIBAN), true), "30.50");
    XCTAssert(testAndCompare("9366104000", "13091054", "de", ("DE26130910549366104000", .IBANToolsDefaultIBAN), true), "30.51");
    XCTAssert(testAndCompare("9370620030", "13091054", "de", ("DE96130910549370620030", .IBANToolsDefaultIBAN), true), "30.52");
    XCTAssert(testAndCompare("9370620080", "13091054", "de", ("DE07130910549370620080", .IBANToolsDefaultIBAN), true), "30.53");
    XCTAssert(testAndCompare("9371900010", "13091054", "de", ("DE87130910549371900010", .IBANToolsDefaultIBAN), true), "30.54");
    XCTAssert(testAndCompare("9373600005", "13091054", "de", ("DE40130910549373600005", .IBANToolsDefaultIBAN), true), "30.55");
    XCTAssert(testAndCompare("9402900021", "13091054", "de", ("DE83130910549402900021", .IBANToolsDefaultIBAN), true), "30.56");
    XCTAssert(testAndCompare("9605110000", "13091054", "de", ("DE94130910549605110000", .IBANToolsDefaultIBAN), true), "30.57");
    XCTAssert(testAndCompare("9614001000", "13091054", "de", ("DE52130910549614001000", .IBANToolsDefaultIBAN), true), "30.58");
    XCTAssert(testAndCompare("9615000016", "13091054", "de", ("DE89130910549615000016", .IBANToolsDefaultIBAN), true), "30.59");
    XCTAssert(testAndCompare("9615010003", "13091054", "de", ("DE03130910549615010003", .IBANToolsDefaultIBAN), true), "30.60");
    XCTAssert(testAndCompare("9618500036", "13091054", "de", ("DE53130910549618500036", .IBANToolsDefaultIBAN), true), "30.61");
    XCTAssert(testAndCompare("9631020000", "13091054", "de", ("DE11130910549631020000", .IBANToolsDefaultIBAN), true), "30.62");
    XCTAssert(testAndCompare("9632600051", "13091054", "de", ("DE10130910549632600051", .IBANToolsDefaultIBAN), true), "30.63");
    XCTAssert(testAndCompare("9632600060", "13091054", "de", ("DE58130910549632600060", .IBANToolsDefaultIBAN), true), "30.64");
    XCTAssert(testAndCompare("9635000012", "13091054", "de", ("DE70130910549635000012", .IBANToolsDefaultIBAN), true), "30.65");
    XCTAssert(testAndCompare("9635000020", "13091054", "de", ("DE48130910549635000020", .IBANToolsDefaultIBAN), true), "30.66");
    XCTAssert(testAndCompare("9635701002", "13091054", "de", ("DE77130910549635701002", .IBANToolsDefaultIBAN), true), "30.67");
    XCTAssert(testAndCompare("9636010003", "13091054", "de", ("DE20130910549636010003", .IBANToolsDefaultIBAN), true), "30.68");
    XCTAssert(testAndCompare("9636013002", "13091054", "de", ("DE42130910549636013002", .IBANToolsDefaultIBAN), true), "30.69");
    XCTAssert(testAndCompare("9636016001", "13091054", "de", ("DE64130910549636016001", .IBANToolsDefaultIBAN), true), "30.70");
    XCTAssert(testAndCompare("9636018004", "13091054", "de", ("DE12130910549636018004", .IBANToolsDefaultIBAN), true), "30.71");
    XCTAssert(testAndCompare("9636019000", "13091054", "de", ("DE86130910549636019000", .IBANToolsDefaultIBAN), true), "30.72");
    XCTAssert(testAndCompare("9636022001", "13091054", "de", ("DE54130910549636022001", .IBANToolsDefaultIBAN), true), "30.73");
    XCTAssert(testAndCompare("9636024004", "13091054", "de", ("DE02130910549636024004", .IBANToolsDefaultIBAN), true), "30.74");
    XCTAssert(testAndCompare("9636025000", "13091054", "de", ("DE76130910549636025000", .IBANToolsDefaultIBAN), true), "30.75");
    XCTAssert(testAndCompare("9636027003", "13091054", "de", ("DE24130910549636027003", .IBANToolsDefaultIBAN), true), "30.76");
    XCTAssert(testAndCompare("9636028000", "13091054", "de", ("DE71130910549636028000", .IBANToolsDefaultIBAN), true), "30.77");
    XCTAssert(testAndCompare("9636045001", "13091054", "de", ("DE48130910549636045001", .IBANToolsDefaultIBAN), true), "30.78");
    XCTAssert(testAndCompare("9636048000", "13091054", "de", ("DE70130910549636048000", .IBANToolsDefaultIBAN), true), "30.79");
    XCTAssert(testAndCompare("9636051001", "13091054", "de", ("DE38130910549636051001", .IBANToolsDefaultIBAN), true), "30.80");
    XCTAssert(testAndCompare("9636053004", "13091054", "de", ("DE83130910549636053004", .IBANToolsDefaultIBAN), true), "30.81");
    XCTAssert(testAndCompare("9636120003", "13091054", "de", ("DE63130910549636120003", .IBANToolsDefaultIBAN), true), "30.82");
    XCTAssert(testAndCompare("9636140004", "13091054", "de", ("DE35130910549636140004", .IBANToolsDefaultIBAN), true), "30.83");
    XCTAssert(testAndCompare("9636150000", "13091054", "de", ("DE94130910549636150000", .IBANToolsDefaultIBAN), true), "30.84");
    XCTAssert(testAndCompare("9636320002", "13091054", "de", ("DE80130910549636320002", .IBANToolsDefaultIBAN), true), "30.85");
    XCTAssert(testAndCompare("9636700000", "13091054", "de", ("DE18130910549636700000", .IBANToolsDefaultIBAN), true), "30.86");
    XCTAssert(testAndCompare("9638120000", "13091054", "de", ("DE44130910549638120000", .IBANToolsDefaultIBAN), true), "30.87");
    XCTAssert(testAndCompare("9639401100", "13091054", "de", ("DE59130910549639401100", .IBANToolsDefaultIBAN), true), "30.88");
    XCTAssert(testAndCompare("9639801001", "13091054", "de", ("DE93130910549639801001", .IBANToolsDefaultIBAN), true), "30.89");
    XCTAssert(testAndCompare("9670010004", "13091054", "de", ("DE39130910549670010004", .IBANToolsDefaultIBAN), true), "30.90");
    XCTAssert(testAndCompare("9680610000", "13091054", "de", ("DE05130910549680610000", .IBANToolsDefaultIBAN), true), "30.91");
    XCTAssert(testAndCompare("9705010002", "13091054", "de", ("DE89130910549705010002", .IBANToolsDefaultIBAN), true), "30.92");
    XCTAssert(testAndCompare("9705403004", "13091054", "de", ("DE59130910549705403004", .IBANToolsDefaultIBAN), true), "30.93");
    XCTAssert(testAndCompare("9705404000", "13091054", "de", ("DE36130910549705404000", .IBANToolsDefaultIBAN), true), "30.94");
    XCTAssert(testAndCompare("9705509996", "13091054", "de", ("DE32130910549705509996", .IBANToolsDefaultIBAN), true), "30.95");
    XCTAssert(testAndCompare("9707901001", "13091054", "de", ("DE83130910549707901001", .IBANToolsDefaultIBAN), true), "30.96");
    XCTAssert(testAndCompare("9736010000", "13091054", "de", ("DE48130910549736010000", .IBANToolsDefaultIBAN), true), "30.97");
    XCTAssert(testAndCompare("9780100050", "13091054", "de", ("DE34130910549780100050", .IBANToolsDefaultIBAN), true), "30.98");
    XCTAssert(testAndCompare("9791000030", "13091054", "de", ("DE29130910549791000030", .IBANToolsDefaultIBAN), true), "30.99");
    XCTAssert(testAndCompare("9990001003", "13091054", "de", ("DE86130910549990001003", .IBANToolsDefaultIBAN), true), "30.100");
    XCTAssert(testAndCompare("9990001100", "13091054", "de", ("DE86130910549990001100", .IBANToolsDefaultIBAN), true), "30.101");
    XCTAssert(testAndCompare("9990002000", "13091054", "de", ("DE36130910549990002000", .IBANToolsDefaultIBAN), true), "30.102");
    XCTAssert(testAndCompare("9990004002", "13091054", "de", ("DE11130910549990004002", .IBANToolsDefaultIBAN), true), "30.103");
    XCTAssert(testAndCompare("9991020001", "13091054", "de", ("DE26130910549991020001", .IBANToolsDefaultIBAN), true), "30.104");
    XCTAssert(testAndCompare("9991040002", "13091054", "de", ("DE95130910549991040002", .IBANToolsDefaultIBAN), true), "30.05");
    XCTAssert(testAndCompare("9991060003", "13091054", "de", ("DE67130910549991060003", .IBANToolsDefaultIBAN), true), "30.106");
    XCTAssert(testAndCompare("9999999993", "13091054", "de", ("DE84130910549999999993", .IBANToolsDefaultIBAN), true), "30.107");
    XCTAssert(testAndCompare("9999999994", "13091054", "de", ("DE57130910549999999994", .IBANToolsDefaultIBAN), true), "30.108");
    XCTAssert(testAndCompare("9999999995", "13091054", "de", ("DE30130910549999999995", .IBANToolsDefaultIBAN), true), "30.109");
    XCTAssert(testAndCompare("9999999996", "13091054", "de", ("DE03130910549999999996", .IBANToolsDefaultIBAN), true), "30.110");
    XCTAssert(testAndCompare("9999999997", "13091054", "de", ("DE73130910549999999997", .IBANToolsDefaultIBAN), true), "30.111");
    XCTAssert(testAndCompare("9999999998", "13091054", "de", ("DE46130910549999999998", .IBANToolsDefaultIBAN), true), "30.112");
    XCTAssert(testAndCompare("9999999999", "13091054", "de", ("DE19130910549999999999", .IBANToolsDefaultIBAN), true), "30.113");

    // Rule 0031.
    XCTAssert(testAndCompare("6790149813", "545 200 71", "de", ("DE77545201946790149813", "HYVEDEMM483", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "31.1");
    XCTAssert(testAndCompare("6791000000", "545 200 71", "de", ("", "", .IBANToolsBadAccount, .IBANToolsBadAccount), true), "31.2");

    // This test is (according to the docs) supposed to fail because the account number is too short.
    // However the account number is not valid and the bank code needs special mapping which doesn't work without a valid account.
    // Consequently we cannot even say which IBAN rule to apply.
    XCTAssert(testAndCompare("897", "101 207 60", "de", ("", "", .IBANToolsNoMethod, .IBANToolsNoMethod), false), "31.3");

    XCTAssert(testAndCompare("1210100047", "790 203 25", "de", ("DE70762200731210100047", "HYVEDEMM419", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "31.5");
    XCTAssert(testAndCompare("1210100047", "700 200 01", "de", ("DE70762200731210100047", "HYVEDEMM419", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "31.6");
    XCTAssert(testAndCompare("1210100047", "760 202 14", "de", ("DE70762200731210100047", "HYVEDEMM419", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "31.7");
    XCTAssert(testAndCompare("1210100047", "762 200 73", "de", ("DE70762200731210100047", "HYVEDEMM419", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "31.8");

    // Same again as for account 897 above. We need a valid account to lookup old bank codes.
    XCTAssert(testAndCompare("44613352", "630 204 50", "de", ("", "", .IBANToolsNoMethod, .IBANToolsNoMethod), false), "31.9");
    XCTAssert(testAndCompare("1457032621", "660 201 50", "de", ("DE92660202861457032621", "HYVEDEMM475", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "31.10");
    XCTAssert(testAndCompare("1210100040", "790 203 25", "de", ("", "", .IBANToolsBadAccount, .IBANToolsBadAccount), true), "31.11");

    // Rule 0032.
    XCTAssert(testAndCompare("1210100047", "762 200 73", "de", ("DE70762200731210100047", "HYVEDEMM419", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "32.1");
    XCTAssert(testAndCompare("1457032621", "660 202 86", "de", ("DE92660202861457032621", "HYVEDEMM475", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "32.2");
    XCTAssert(testAndCompare("3200000012", "762 200 73", "de", ("DE06710221823200000012", "HYVEDEMM453", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "32.3");
    XCTAssert(testAndCompare("5951950", "100 208 90", "de", ("DE07100208900005951950", "HYVEDEMM488", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "32.4");
    XCTAssert(testAndCompare("897", "100 208 90", "de", ("", "", .IBANToolsBadAccount, .IBANToolsBadAccount), true), "32.5");
    XCTAssert(testAndCompare("847321750", "850 200 86", "de", ("", "", .IBANToolsNoConv, .IBANToolsNoConv), true), "32.6");

    // Rule 0033.
    XCTAssert(testAndCompare("2950219435", "70020270", "de", ("DE76700202702950219435", "HYVEDEMMXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "33.1");
    XCTAssert(testAndCompare("1457032621", "70020270", "de", ("DE92660202861457032621", "HYVEDEMM475", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "33.2");
    XCTAssert(testAndCompare("897", "70020270", "de", ("DE55700202700000000897", "HYVEDEMMXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "33.3");
    XCTAssert(testAndCompare("847321750", "70020270", "de", ("DE36700202700847321750", "HYVEDEMMXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "33.4");

    XCTAssert(testAndCompare("22222", "70020270", "de", ("DE11700202705803435253", "HYVEDEMMXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "33.5");
    XCTAssert(testAndCompare("1111111", "70020270", "de", ("DE88700202700039908140", "HYVEDEMMXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "33.6");
    XCTAssert(testAndCompare("94", "70020270", "de", ("DE83700202700002711931", "HYVEDEMMXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "33.7");
    XCTAssert(testAndCompare("7777777", "70020270", "de", ("DE40700202705800522694", "HYVEDEMMXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "33.8");
    XCTAssert(testAndCompare("55555", "70020270", "de", ("DE61700202705801800000", "HYVEDEMMXXX", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "33.9");

    // Rule 0034.
    XCTAssert(testAndCompare("1320815432", "60020290", "de", ("DE69600202901320815432", "HYVEDEMM473", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "34.1");
    XCTAssert(testAndCompare("1457032621", "60020290", "de", ("DE92660202861457032621", "HYVEDEMM475", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "34.2");
    XCTAssert(testAndCompare("5951950", "60020290", "de", ("DE67600202900005951950", "HYVEDEMM473", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "34.3");
    XCTAssert(testAndCompare("847321750", "60020290", "de", ("", "", .IBANToolsNoConv, .IBANToolsNoConv), true), "34.4");

    XCTAssert(testAndCompare("500500500", "60020290", "de", ("DE82600202904340111112", "HYVEDEMM473", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "34.5");
    XCTAssert(testAndCompare("502", "60020290", "de", ("DE28600202904340118001", "HYVEDEMM473", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "34.6");

    // Rule 0035.
    XCTAssert(testAndCompare("1050958422", "79020076", "de", ("DE42790200761050958422", "HYVEDEMM455", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "35.1");
    XCTAssert(testAndCompare("1320815432", "79020076", "de", ("DE69600202901320815432", "HYVEDEMM473", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "35.2");
    XCTAssert(testAndCompare("5951950", "79020076", "de", ("DE56790200760005951950", "HYVEDEMM455", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "35.3");
    XCTAssert(testAndCompare("847321750", "79020076", "de", ("", "", .IBANToolsNoConv, .IBANToolsNoConv), true), "35.4");

    XCTAssert(testAndCompare("9696", "79020076", "de", ("DE29790200761490196966", "HYVEDEMM455", .IBANToolsDefaultIBAN, .IBANToolsOK), true), "35.5");
  }
}
