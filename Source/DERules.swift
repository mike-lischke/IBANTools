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

import Foundation
import AppKit

// IBAN conversion rules specific to Germany.

@objc(DERules)
internal class DERules : IBANRules {

  private struct BankEntry {         // Details for a given bank code.
    var name: String = "";
    var postalCode: String = "";
    var place: String = "";
    var bic: String = "";
    var checksumMethod: String = ""; // Checksum method for account numbers.
    var isDeleted: Bool = false;     // True if this entry is just mentioned for completeness.
                                     // No longer use such an entry for payments.
    var replacement: Int = 0;        // Set if there's a new bank code now.
    var rule: Int = 0;               // The IBAN conversion rule for this bank.
    var ruleVersion: Int = 0;        // The version of the rule (starting with 0).
  }

  typealias RuleResult = (account: String, bankCode: String, iban: String, result: IBANToolsResult);
  typealias RuleClosure = (String, String, Int) -> RuleResult;

  static private var institutes: [Int: BankEntry] = [:];

  // An array of rules. The signature is a bit complicated because some rules only modify
  // the account number or the bank code, but otherwise use the default IBAN creation rule.
  // We could use inout parameters, but Swift crashs if inout is used for the array closures.
  static private var rules: [RuleClosure] = [
    DERules.defaultRule, DERules.rule1, DERules.rule2, DERules.rule3, DERules.defaultRuleWithAccountMapping,
    DERules.rule5, DERules.defaultRuleWithAccountMapping, DERules.defaultRuleWithAccountMapping,
    DERules.rule8, DERules.rule9,

    DERules.rule10, DERules.defaultRuleWithAccountMapping, DERules.rule12, DERules.rule13, DERules.rule14,
    DERules.defaultRuleWithAccountMapping, DERules.defaultRuleWithAccountMapping,
    DERules.defaultRuleWithAccountMapping, DERules.defaultRuleWithAccountMapping, DERules.rule19,

    DERules.rule20, DERules.defaultRuleWithAccountMapping, DERules.defaultRuleWithAccountMapping,
    DERules.defaultRuleWithAccountMapping, DERules.defaultRuleWithAccountMapping,
    DERules.rule25, DERules.defaultRuleWithAccountMapping, DERules.defaultRuleWithAccountMapping,
    DERules.rule28, DERules.rule29,

    DERules.defaultRuleWithAccountMapping, DERules.rule31, DERules.rule323435, DERules.rule33,
    DERules.rule323435, DERules.rule323435,
    DERules.rule36, DERules.rule37, DERules.rule38, DERules.rule39,

    DERules.rule40, DERules.rule41,
    DERules.rule42, DERules.rule43, DERules.defaultRule, DERules.defaultRule, DERules.rule46,
    DERules.rule47, DERules.defaultRule, DERules.rule49,

    DERules.defaultRule, DERules.defaultRule, DERules.rule52, DERules.defaultRule,
    DERules.defaultRule, DERules.rule55, DERules.rule56, DERules.defaultRule,
  ];

  // For certain bank codes a specific range of account numbers are closed off and not
  // available for IBAN calculations. Certain other's are generally not used.
  static private let bankCodes5: Set<Int> = [
    10080900, 25780022, 42080082, 54280023, 65180005, 79580099,
    12080000, 25980027, 42680081, 54580020, 65380003, 80080000,
    13080000, 26080024, 43080083, 54680022, 66280053, 81080000,
    14080000, 26281420, 44080055, 55080065, 66680013, 82080000,
    15080000, 26580070, 44080057, 57080070, 67280051, 83080000,
    16080000, 26880063, 44580070, 58580074, 69280035, 84080000,
    17080000, 26981062, 45080060, 59080090, 70080056, 85080200,
    18080000, 28280012, 46080010, 60080055, 70080057, 86080055,
    20080055, 29280011, 47880031, 60080057, 70380006, 86080057,
    20080057, 30080055, 49080025, 60380002, 71180005, 87080000,
    21080050, 30080057, 50080055, 60480008, 72180002,
    21280002, 31080015, 50080057, 61080006, 73180011,
    21480003, 32080010, 50080082, 61281007, 73380004,
    21580000, 33080030, 50680002, 61480001, 73480013,
    22180000, 34080031, 50780006, 62080012, 74180009,
    22181400, 34280032, 50880050, 62280012, 74380007,
    22280000, 36280071, 51380040, 63080015, 75080003,
    24080000, 36580072, 52080080, 64080014, 76080053,
    24180001, 40080040, 53080030, 64380011, 79080052,
    25480021, 41280043, 54080021, 65080009, 79380051,
  ];

  static private let accounts54: Set<Int> = [
    624044, 4063060, 20111908, 20211908, 20311908, 20411908, 20511908, 20611908,
    20711908, 20811908, 20911908, 21111908, 21211908, 21311908, 21411908, 21511908,
    21611908, 21711908, 21811908, 21911908, 22111908, 22211908, 22311908, 22411908,
    22511908, 22611908, 46211991, 50111908, 50211908, 50311908, 50411908, 50511908,
    50611908, 50711908, 50811908, 50911908, 51111908, 51111991, 51211908, 51211991,
    51311908, 51411908, 51511908, 51611908, 51711908, 51811908, 51911908, 52111908,
    52111991, 52211908, 52211991, 52311908, 52411908, 52511908, 52611908, 52711908,
    52811908, 52911908, 53111908, 53211908, 53311908, 57111908, 58111908, 58211908,
    58311908, 58411908, 58511908, 80111908, 80211908, 80311908, 80411908, 80511908,
    80611908, 80711908, 80811908, 80911908, 81111908, 81211908, 81311908, 81411908,
    81511908, 81611908, 81711908, 81811908, 81911908, 82111908, 82211908, 82311908,
    82411908, 82511908, 82611908, 82711908, 82811908, 82911908, 99624044, 300143869,
  ];

  override class func initialize() {
    super.initialize();

    let bundle = NSBundle(forClass: DERules.self);
    let resourcePath = bundle.pathForResource("bank_codes", ofType: "txt", inDirectory: "de");
    loadData(resourcePath);
  }

  override class func loadData(path: String?) {
    if path != nil && NSFileManager.defaultManager().fileExistsAtPath(path!) {
      var error: NSError?;
      let content = NSString(contentsOfFile: path!, encoding: NSUTF8StringEncoding, error: &error);
      if error != nil {
        let alert = NSAlert.init(error: error!);
        alert.runModal();
        return;
      }

      if content != nil {
        institutes = [:];
        
        // Extract bank code details.
        for line in content!.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()) {
          let s: NSString = line as! NSString;
          if s.length < 168 {
            continue; // Not a valid line.
          }

          // 1 for the primary institute or subsidiary, 2 for additional subsidiaries that
          // should not take part in the payments. They share the same bank code anyway.
          let mark = line.substringWithRange(NSMakeRange(8, 1)).toInt();
          if mark == 2 {
            continue;
          }

          var entry = BankEntry();

          let bankCode = line.substringWithRange(NSMakeRange(0, 8)).toInt();
          entry.name = line.substringWithRange(NSMakeRange(9, 58)).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet());
          entry.postalCode = line.substringWithRange(NSMakeRange(67, 5));
          entry.place = line.substringWithRange(NSMakeRange(72, 35)).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet());
          entry.bic = line.substringWithRange(NSMakeRange(139, 11));
          entry.checksumMethod = line.substringWithRange(NSMakeRange(150, 2));
          let c: unichar = line.characterAtIndex(158);
          entry.isDeleted = UnicodeScalar(c) == "D";
          entry.replacement = line.substringWithRange(NSMakeRange(160, 8)).toInt()!;

          if s.length > 168 {
            // Extended bank code file.
            entry.rule = line.substringWithRange(NSMakeRange(168, 4)).toInt()!;
            entry.ruleVersion = line.substringWithRange(NSMakeRange(172, 2)).toInt()!;
          }
          institutes[bankCode!] = entry;
        }
      }
    }
  }

  /// Returns the method to be used for account checks for the specific institute.
  /// May return an empty string if we have no info for the given bank code.
  class func checkSumMethodForInstitute(bankCode: String) -> String {
    let bank = bankCode.toInt();
    if bank != nil {
      if let institute = institutes[bank!] {
        return institute.checksumMethod;
      }
    }

    // There are a few methods that are defined but not referenced (not yet?, no longer?).
    // For some of them we have (obviously) deleted bank codes, which we list here.
    // For others we take dummy bank code numbers.
    // This allows us to trigger tests for the associated methods.
    // The dummy numbers are *not* used outside of this lib.
    let internalMapping: [String: String] = [
      "13051172": "52", // No longer used bank code that was using method 52.
      "16052082": "53", // Ditto for method 53.
      "80053782": "B6", // There are other (still used) bank codes for method B6.

      "11111111": "35", "11111112": "36", "11111113": "37", "11111114": "39","11111115": "54",
      "11111116": "62", "11111117": "69", "11111118": "77", "11111119": "79", "11111120": "80",
      "11111121": "82", "11111122": "83", "11111123": "86", "11111124": "89", "11111125": "93",
      "11111126": "97", "11111127": "A0", "11111128": "A6", "11111129": "A7", "11111130": "A8",
      "11111131": "A9", "11111132": "B0", "11111133": "B4", "11111134": "B9",
    ];

    if let method = internalMapping[bankCode] {
      return method;
    }
    return "";
  }

  private class func ruleForAccount(account: String, bankCode: String) -> (Int, Int, String) {
    if let bank = bankCode.toInt() {
      if let institute = institutes[bank] {
        // Replace bank code by new one if there's one.
        var bankNumber = bankCode;
        if institute.replacement > 0 {
          bankNumber = String(institute.replacement);
        }
        return (institute.rule, institute.ruleVersion, bankNumber);
      }
    }

    return (1000, 0, bankCode);
  }

  /// Certain accounts can be used for IBAN conversion even if they fail the checksum check.
  override class func validWithoutChecksum(account: String, _ bankCode: String) -> Bool {
    if (bankCode == "21060237" || bankCode == "10060237") && accounts54.contains(account.toInt()!) {
      return true;
    }
    return false;
  }

  override class func convertToIBAN(inout account: String, inout _ bankCode: String) -> ConversionResult {
    var (rule, version, bankNumber) = ruleForAccount(account, bankCode: bankCode);

    // Same here as with the account checks. If we cannot find an entry for a given bank
    // because it might have been deleted and hence is no longer in the database) try a lookup
    // in our internal mappings.
    if rule > rules.count {
      let newBankCode = DEAccountCheck.bankCodeFromAccountCluster(account.toInt()!, bankCode: bankCode.toInt()!);
      if newBankCode > -1 {
        bankCode = String(newBankCode);
        (rule, version, bankNumber) = ruleForAccount(account, bankCode: bankCode);
      }
    }

    if rule < rules.count {
      let function = rules[rule];
      let result = function(account, bankNumber, version);
      account = result.account;
      bankCode = result.bankCode;
      return (result.iban, result.result);
    }
    return ("", .NoMethod);
  }

  override class func bicForBankCode(bankCode: String) -> (bic: String, result: IBANToolsResult) {
    if let bank = bankCode.toInt() {
      if var institute = institutes[bank] {
        var done = true;
        switch bank {
        case 10020200, 20120200, 25020200, 30020500, 51020000, 55020000, 60120200, 70220200, 86020200:
          institute.bic = "BHFBDEFF500"; // BHF Bank AG

        case 68351976, 68351557:
          institute.bic = "SOLADES1SFH"; // Sparkasse Zell im Wiesental

        case 50850049: // Landesbank Hessen-Thüringen Girozentrale
          institute.bic = "HELADEFFXXX";

        case 40050000, 44050000: // Landesbank Hessen-Thüringen Girozentrale
          institute.bic = "WELADEDDXXX";

        case 50120383, 50130100, 50220200, 70030800: // Bethmann Bank
          institute.bic = "DELBDE33XXX";

        case 25050299: // Sparkasse Hannover
          institute.bic = "SPKHDE2HXXX";

        case 62220000: // Bausparkasse Schwäbisch Hall AG
          institute.bic = "GENODEFFXXX";

        case 60651070: // Sparkasse Pforzheim Calw
          institute.bic = "PZHSDE66XXX";

        case 10120800, 27010200, 60020300: // VON ESSEN GmbH & Co. KG Bankgesellschaft
          institute.bic = "VONEDE33XXX";

        case 28252760: // Sparkasse LeerWittmund
          institute.bic = "BRLADE21LER";

        case 60050101: // Landesbank Baden-Württemberg
          institute.bic = "SOLADEST600";

        default:
          done = false;
        }

        let bankString = bankCode as NSString;
        if !done {
          // Mappings for certain bank code clusters.
          let cluster = bankString.substringWithRange(NSMakeRange(3, 3));
          if cluster == "400" { // Commerzbank main.
            institute.bic = "COBADEFFXXX";
          } else {
            if (institute.bic as NSString).hasPrefix("DAAEDED") { // apoBank.
              institute.bic = "DAAEDEDDXXX";
            } else {
              if bankString.hasPrefix("502101") || bankString.hasPrefix("505101") { // SEB AG.
                let suffix = bank % 100;
                if (bankString.hasPrefix("502101") && 30...89 ~= suffix) || (20...80 ~= suffix) {
                  institute.bic = "ESSEDE5FXXX";
                }
              }
            }
          }
        }

        return (institute.bic, .OK);
      }
    }

    return ("", .NoBIC);
  }

  private class func defaultRule(account: String, bankCode: String, version: Int) -> RuleResult {
    return (account, bankCode, "", .DefaultIBAN);
  }

  private class func defaultRuleWithAccountMapping(var account: String, var bankCode: String, version: Int) ->
    RuleResult {

    let (valid, result) = DEAccountCheck.isValidAccount(&account, &bankCode, true);
    if !valid {
      return (account, bankCode, "", result);
    }
    return (account, bankCode, "", .DefaultIBAN);
  }

  private class func rule1(account: String, bankCode: String, version: Int) -> RuleResult {
    return (account, bankCode, "", .NoConversion);
  }

  private class func rule2(account: String, bankCode: String, version: Int) -> RuleResult {
    // No IBANs for nnnnnnn86n and nnnnnnn6nn.
    if account[advance(account.endIndex, -3)] == "6" {
      return (account, bankCode, "", .NoConversion);
    }

    if (account[advance(account.endIndex, -2)] == "6") && (account[advance(account.endIndex, -3)] == "8") {
      return (account, bankCode, "", .NoConversion);
    }

    return (account, bankCode, "", .DefaultIBAN);
  }

  private class func rule3(account: String, bankCode: String, version: Int) -> RuleResult {
    if account == "6161604670" {
      return (account, bankCode, "", .NoConversion);
    }

    return (account, bankCode, "", .DefaultIBAN);
  }

  private class func rule5(var account: String, var bankCode: String, version: Int) -> RuleResult {
    let code = bankCode.toInt()!;
    if code == 50040033 {
      return (account, bankCode, "", .NoConversion);
    }

    var number = account.toInt()!;

    if bankCodes5.contains(code) && 0998000000...0999499999 ~= number {
        return (account, bankCode, "", .NoConversion);
    }

    let temp = String(number); // Like the original account number but without leading zeros.

    let checksumMethod = checkSumMethodForInstitute(bankCode);
    if checksumMethod == "13" && 6...7 ~= count(temp) {
      account += "00"; // Always assumed the sub account number is missing.
    }

    if checksumMethod == "76" {
      let (valid, result, checkSumPos) = DEAccountCheck.checkWithMethod(checksumMethod, &account, &bankCode, true);
      if !valid {
        return (account, bankCode, "", result);
      }
      if checkSumPos == 9 {
        account += "00";
      }
    }

    return (account, bankCode, "", .DefaultIBAN);
  }
  
  private class func rule8(account: String, bankCode: String, version: Int) -> RuleResult {
    return (account, "50020200", "", .DefaultIBAN);
  }

  private class func rule9(var account: String, bankCode: String, version: Int) -> RuleResult {
    let s = account as NSString;
    if s.length == 10 && s.hasPrefix("1116") {
      account = "3047" + s.substringFromIndex(4);
    }
    return (account, "68351557", "", .DefaultIBAN);
  }

  private class func rule10(account: String, var bankCode: String, version: Int) -> RuleResult {
    if bankCode == "50050222" {
      bankCode = "50050201";
    }
    return defaultRuleWithAccountMapping(account, bankCode: bankCode, version: version);
  }

  private class func rule12(account: String, bankCode: String, version: Int) -> RuleResult {
    return defaultRuleWithAccountMapping(account, bankCode: "50050000", version: version);
  }

  private class func rule13(account: String, bankCode: String, version: Int) -> RuleResult {
    return defaultRuleWithAccountMapping(account, bankCode: "30050000", version: version);
  }

  private class func rule14(account: String, bankCode: String, version: Int) -> RuleResult {
    return (account, "30060601", "", .DefaultIBAN);
  }

  private class func rule19(account: String, bankCode: String, version: Int) -> RuleResult {
    return (account, "50120383", "", .DefaultIBAN);
  }

  private class func rule20(var account: String, var bankCode: String, version: Int) -> RuleResult {
    let checksumMethod = checkSumMethodForInstitute(bankCode);

    if bankCode == "76026000" {
      // Norisbank. Check out without alternative (rule 06).
      var (valid, _, _) = DEAccountCheck.checkWithMethod(checksumMethod, &account, &bankCode, true, false);
      if !valid {
        return (account, bankCode, "", .NoConversion);
      }
    }

    switch count(account) {
    case 1...4:
      return (account, bankCode, "", .NoConversion);
    case 7:
      // Check first as if the sub account where missing.
      var account2 = account + "00";
      var (valid, result, _) = DEAccountCheck.checkWithMethod(checksumMethod, &account2, &bankCode, true);
      if valid {
        return (account2, bankCode, "", .DefaultIBAN);
      }
      (valid, result, _) = DEAccountCheck.checkWithMethod(checksumMethod, &account, &bankCode, true);
      if !valid {
        return (account, bankCode, "", result);
      }

    case 5, 6:
      let (valid, result, checkSumPos) = DEAccountCheck.checkWithMethod(checksumMethod, &account, &bankCode, true);
      if !valid {
        return (account, bankCode, "", result);
      }
      account += "00";
    default:
      break;
    }
    return (account, bankCode, "", .DefaultIBAN);
  }

  private class func rule25(account: String, bankCode: String, version: Int) -> RuleResult {
    return (account, "60050101", "", .DefaultIBAN);
  }

  private class func rule28(account: String, bankCode: String, version: Int) -> RuleResult {
    return (account, "25050180", "", .DefaultIBAN);
  }

  private class func rule29(var account: String, bankCode: String, version: Int) -> RuleResult {
    let accountAsInt = account.toInt()!;
    account = String(accountAsInt); // Remove any leading 0.
    if count(account) == 10 {
      account = "0" + (account as NSString).substringToIndex(3) + (account as NSString).substringFromIndex(4);
    }
    return (account, bankCode, "", .DefaultIBAN);
  }
  
  private class func rule31(var account: String, var bankCode: String, version: Int) -> RuleResult {
    var accountAsInt = account.toInt()!;
    account = String(accountAsInt);
    if count(account) < 10 { // Rule only valid for 10 digits account numbers.
      return (account, bankCode, "", .NoConversion);
    }

    let newBankCode = DEAccountCheck.bankCodeFromAccount(accountAsInt, forRule: 31);
    if newBankCode > -1 {
      bankCode = String(newBankCode);
    }
    return (account, bankCode, "", .DefaultIBAN);
  }

  private class func rule323435(account: String, var bankCode: String, version: Int) -> RuleResult {
    var accountAsInt = account.toInt()!;
    if 800_000_000...899_999_999 ~= accountAsInt {
      return (account, bankCode, "", .NoConversion);
    }

    let newBankCode = DEAccountCheck.bankCodeFromAccount(accountAsInt, forRule: 31);
    if newBankCode > -1 {
      bankCode = String(newBankCode);
    }
    return (account, bankCode, "", .DefaultIBAN);
  }

  private class func rule33(account: String, var bankCode: String, version: Int) -> RuleResult {
    var accountAsInt = account.toInt()!;
    let newBankCode = DEAccountCheck.bankCodeFromAccount(accountAsInt, forRule: 31);
    if newBankCode > -1 {
      bankCode = String(newBankCode);
    }
    return (account, bankCode, "", .DefaultIBAN);
  }

  private class func rule36(var account: String, bankCode: String, version: Int) -> RuleResult {
    var accountAsInt = account.toInt()!;
    switch accountAsInt {
    case 0...999999:
      account = String(accountAsInt) + "000";

    case 0000000000...0000099999, 0000900000...0029999999, 0060000000...0099999999,
         0900000000...0999999999, 2000000000...2999999999, 7100000000...8499999999,
         8600000000...8999999999:
      return (account, bankCode, "", .NoConversion);
      
    default:
      break;
    }
    return (account, "21050000", "", .DefaultIBAN);
  }

  private class func rule37(account: String, bankCode: String, version: Int) -> RuleResult {
    return (account, "30010700", "", .DefaultIBAN);
  }

  private class func rule38(account: String, bankCode: String, version: Int) -> RuleResult {
    return (account, "28590075", "", .DefaultIBAN);
  }

  private class func rule39(account: String, bankCode: String, version: Int) -> RuleResult {
    return (account, bankCode, "", .DefaultIBAN);
  }
  
  private class func rule40(account: String, bankCode: String, version: Int) -> RuleResult {
    return (account, "68052328", "", .DefaultIBAN);
  }

  private class func rule41(account: String, bankCode: String, version: Int) -> RuleResult {
    if bankCode == "62220000" {
      return (account, bankCode, "DE96500604000000011404", .OK);
    }
    return (account, bankCode, "", .DefaultIBAN);
  }

  private class func rule42(account: String, bankCode: String, version: Int) -> RuleResult {
    let accountAsInt = account.toInt()!;
    if !(10000000...99999999 ~= accountAsInt) { // Only accounts with 8 digits are valid.
      return (account, bankCode, "", .NoConversion);
    }

    if 0...999 ~= (accountAsInt % 100000) { // No IBAN for nnn 0 0000 through nnn 0 0999.
      return (account, bankCode, "", .NoConversion);
    }

    if 50462000...50463999 ~= accountAsInt || 50469000...50469999 ~= accountAsInt {
      return (account, bankCode, "", .DefaultIBAN);
    }

    if (accountAsInt / 10000) % 10 != 0 { // Only accounts with 0 at 4th position.
      return (account, bankCode, "", .NoConversion);
    }
    return (account, bankCode, "", .DefaultIBAN);
  }

  private class func rule43(var account: String, var bankCode: String, version: Int) -> RuleResult {
    if bankCode == "60651070" {
      bankCode = "66650085"; // Now accounts must be valid for this new bank code, so do another account check.

      let checksumMethod = checkSumMethodForInstitute(bankCode);
      let (valid, result, _) = DEAccountCheck.checkWithMethod(checksumMethod, &account, &bankCode, true);
      if !valid {
        return (account, bankCode, "", result);
      }
    }
    return (account, bankCode, "", .DefaultIBAN);
  }

  private class func rule46(account: String, bankCode: String, version: Int) -> RuleResult {
    return (account, "31010833", "", .DefaultIBAN);
  }

  private class func rule47(var account: String, bankCode: String, version: Int) -> RuleResult {
    let accountAsInt = account.toInt()!;
    if 10000000...99999999 ~= accountAsInt { // 8 digit accounts must be right-justified, instead of the usual left alignment.
      account = String(accountAsInt) + "00";
    }
    return (account, bankCode, "", .DefaultIBAN);
  }

  private class func rule49(var account: String, bankCode: String, version: Int) -> RuleResult {
    if bankCode == "30060010" || bankCode == "40060000" || bankCode == "57060000" {
      let accountAsInt = account.toInt()!;
      account = String(accountAsInt);
      if count(account) < 10 {
        account = String(count: 10 - count(account), repeatedValue: "0" as Character) + account;
      }
      let s = account as NSString;
      if s.characterAtIndex(4) == 0x39 {
        account = s.substringFromIndex(4) + s.substringToIndex(4);
      }
    }
    return (account, bankCode, "", .DefaultIBAN);
  }
  
  private class func rule52(var account: String, var bankCode: String, version: Int) -> RuleResult {
    // Only very specific account/bank code combinations are allowed for conversion.
    if DEAccountCheck.checkSpecialAccount(&account, bankCode: &bankCode) {
      return (account, bankCode, "", .DefaultIBAN);
    }
    return (account, bankCode, "", .NoConversion);
  }

  private class func rule55(account: String, bankCode: String, version: Int) -> RuleResult {
    return (account, "25410200", "", .DefaultIBAN);
  }

  private class func rule56(account: String, bankCode: String, version: Int) -> RuleResult {
    if account.toInt()! < 1000000000 { // Only accounts with 10 digits can be used.
      return (account, bankCode, "", .NoConversion);
    }
   return (account, bankCode, "", .DefaultIBAN);
  }

}