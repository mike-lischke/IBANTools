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

  private struct Static {
    static var institutes: [Int: BankEntry] = [:];

    // An array of rules. The signature is a bit complicated because some rules only modify
    // the account number or the bank code, but otherwise use the default IBAN creation rule.
    // We could use inout parameters, but Swift crashs if inout is used for the array closures.
    typealias RuleClosure = (String, String, Int) -> ConversionResult;
    static var rules: [RuleClosure] = [
      DERules.defaultRule, DERules.rule1, DERules.rule2, DERules.rule3, DERules.defaultRuleWithAccountMapping,
      DERules.rule5, DERules.defaultRuleWithAccountMapping, DERules.defaultRuleWithAccountMapping,
      DERules.rule8, DERules.rule9, DERules.rule10,

      DERules.defaultRuleWithAccountMapping, DERules.rule12, DERules.rule13, DERules.rule14,
      DERules.defaultRuleWithAccountMapping, DERules.defaultRuleWithAccountMapping,
      DERules.defaultRuleWithAccountMapping, DERules.defaultRuleWithAccountMapping, DERules.rule19, DERules.rule20,

      DERules.rule21, DERules.rule22, DERules.rule23,
      DERules.rule24, DERules.rule25, DERules.rule26, DERules.rule27, DERules.rule28, DERules.rule29,
      DERules.rule30, DERules.rule31, DERules.rule32, DERules.rule33, DERules.rule34, DERules.rule35,
      DERules.rule36, DERules.rule37, DERules.rule38, DERules.rule39, DERules.rule40, DERules.rule41,
      DERules.rule42, DERules.rule43, DERules.rule44, DERules.rule45, DERules.rule46, DERules.rule47,
      DERules.rule48, DERules.rule49, DERules.rule50, DERules.rule51, DERules.rule52, DERules.rule53,
      DERules.rule54, DERules.rule55, DERules.rule56, DERules.rule57, DERules.rule58, DERules.rule59,
    ];
  }

  override class func initialize() {
    super.initialize();

    let bundle = NSBundle(forClass: DERules.self);
    let resourcePath = bundle.pathForResource("bank_codes", ofType: "txt", inDirectory: "de");
    if resourcePath != nil && NSFileManager.defaultManager().fileExistsAtPath(resourcePath!) {
      var error: NSError?;
      let content = NSString(contentsOfFile: resourcePath!, encoding: NSUTF8StringEncoding, error: &error);
      if error != nil {
        let alert = NSAlert.init(error: error!);
        alert.runModal();
        return;
      }
      if content != nil {
        // Extract bank code mappings.
        for line in content!.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()) {
          let s: NSString = line as NSString;
          if s.length < 168 {
            continue; // Not a valid line.
          }

          // 1 for the primary institute or subsidiary, 2 for additional subsidiaries that
          // should not take part in the payments. They share the same bank code anyway.
          let mark = line.substringWithRange(NSMakeRange(8, 1)).toInt();
          if mark? == 2 {
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
          Static.institutes[bankCode!] = entry;
        }
      }
    }
  }

  /**
  * Returns the method to be used for account checks for the specific institute.
  * May return an empty string if we have no info for the given bank code.
  */
  class func checkSumMethodForInstitute(bankCode: String) -> String {
    let bank = bankCode.toInt();
    if bank != nil {
      if let institute = Static.institutes[bank!] {
        return institute.checksumMethod;
      }
    }

    // There are a few methods that are defined but not referenced (yet?, no longer?).
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

  override class func convertToIBAN(account: String, _ bankCode: String) -> ConversionResult {
    var rule = 0;
    var version = 0;
    var bankNumber = bankCode;
    if let bank = bankCode.toInt() {
      if let institute = Static.institutes[bank] {
        // Replace bank code by new one if there's one.
        if institute.isDeleted {
          return (account, bankCode, "", .IBANToolsBadBank);
        }

        if institute.replacement > 0 {
          bankNumber = String(institute.replacement);
        }

        rule = institute.rule;
        version = institute.ruleVersion;
      }
    }

    if rule < Static.rules.count {
      let function = Static.rules[rule];
      return function(account, bankNumber, version);
    }
    return (account, bankNumber, "", .IBANToolsNoMethod);
  }

  override class func bicForBankCode(bankCode: String) -> (bic: String, result: IBANToolsResult) {
    if let bank = bankCode.toInt() {
      if var institute = Static.institutes[bank] {
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

        default:
          done = false;
        }

        if !done {
          // Mappings for certain bank code clusters.
          let cluster = (bankCode as NSString).substringWithRange(NSMakeRange(3, 3));
          if cluster == "400" { // Commerzbank main.
            institute.bic = "COBADEFFXXX";
          } else {
            if (institute.bic as NSString).hasPrefix("DAAEDED") { // apoBank
              institute.bic = "DAAEDEDDXXX";
            }
          }
        }

        return (institute.bic, .IBANToolsOK);
      }
    }

    return ("", .IBANToolsNoBic);
  }

  private class func defaultRule(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }

  private class func defaultRuleWithAccountMapping(var account: String, bankCode: String, version: Int) ->
    (String, String, String, IBANToolsResult) {

    let (valid, account, result) = DEAccountCheck.isValidAccount(account, bankCode);
    if !valid {
      return (account, bankCode, "", result);
    }
    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }

  private class func rule1(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, bankCode, "", .IBANToolsNoConv);
  }

  private class func rule2(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    // No IBANs for nnnnnnn86n and nnnnnnn6nn.
    if account[advance(account.endIndex, -3)] == "6" {
      return (account, bankCode, "", .IBANToolsNoConv);
    }

    if (account[advance(account.endIndex, -2)] == "6") && (account[advance(account.endIndex, -3)] == "8") {
      return (account, bankCode, "", .IBANToolsNoConv);
    }

    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }

  private class func rule3(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    if account == "6161604670" {
      return (account, bankCode, "", .IBANToolsNoConv);
    }

    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }

  private class func rule5(var account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    let code = bankCode.toInt()!;
    if code == 50040033 {
      return (account, bankCode, "", .IBANToolsNoConv);
    }

    var number = account.toInt()!;

    // For certain bank codes a specific range of account numbers are closed off and not
    // available for IBAN calculations. Certain other's are generally not used.
    let bankCodes1: [Int: Int] = [ // Dict used as set.
      10080900: 0, 25780022: 0, 42080082: 0, 54280023: 0, 65180005: 0, 79580099: 0,
      12080000: 0, 25980027: 0, 42680081: 0, 54580020: 0, 65380003: 0, 80080000: 0,
      13080000: 0, 26080024: 0, 43080083: 0, 54680022: 0, 66280053: 0, 81080000: 0,
      14080000: 0, 26281420: 0, 44080055: 0, 55080065: 0, 66680013: 0, 82080000: 0,
      15080000: 0, 26580070: 0, 44080057: 0, 57080070: 0, 67280051: 0, 83080000: 0,
      16080000: 0, 26880063: 0, 44580070: 0, 58580074: 0, 69280035: 0, 84080000: 0,
      17080000: 0, 26981062: 0, 45080060: 0, 59080090: 0, 70080056: 0, 85080200: 0,
      18080000: 0, 28280012: 0, 46080010: 0, 60080055: 0, 70080057: 0, 86080055: 0,
      20080055: 0, 29280011: 0, 47880031: 0, 60080057: 0, 70380006: 0, 86080057: 0,
      20080057: 0, 30080055: 0, 49080025: 0, 60380002: 0, 71180005: 0, 87080000: 0,
      21080050: 0, 30080057: 0, 50080055: 0, 60480008: 0, 72180002: 0,
      21280002: 0, 31080015: 0, 50080057: 0, 61080006: 0, 73180011: 0,
      21480003: 0, 32080010: 0, 50080082: 0, 61281007: 0, 73380004: 0,
      21580000: 0, 33080030: 0, 50680002: 0, 61480001: 0, 73480013: 0,
      22180000: 0, 34080031: 0, 50780006: 0, 62080012: 0, 74180009: 0,
      22181400: 0, 34280032: 0, 50880050: 0, 62280012: 0, 74380007: 0,
      22280000: 0, 36280071: 0, 51380040: 0, 63080015: 0, 75080003: 0,
      24080000: 0, 36580072: 0, 52080080: 0, 64080014: 0, 76080053: 0,
      24180001: 0, 40080040: 0, 53080030: 0, 64380011: 0, 79080052: 0,
      25480021: 0, 41280043: 0, 54080021: 0, 65080009: 0, 79380051: 0,
    ];

    if (bankCodes1[code] != nil) && 0998000000...0999499999 ~= number {
        return (account, bankCode, "", .IBANToolsNoConv);
    }

    let temp = String(number); // Like the original account number but without leading zeros.

    let checksumMethod = checkSumMethodForInstitute(bankCode);
    if checksumMethod == "13" && 6...7 ~= temp.utf16Count {
      account += "00"; // Always assumed the sub account number is missing.
    }

    if checksumMethod == "76" {
      let (valid, _, result, checkSumPos) = DEAccountCheck.checkWithMethod(checksumMethod, account, bankCode);
      if !valid {
        return (account, bankCode, "", result);
      }
      if checkSumPos == 9 {
        account += "00";
      }
    }

    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }
  
  private class func rule8(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, "50020200", "", .IBANToolsDefaultIBAN);
  }

  private class func rule9(var account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    let s = account as NSString;
    if s.length == 10 && s.hasPrefix("1116") {
      account = "3047" + s.substringFromIndex(4);
    }
    return (account, "68351557", "", .IBANToolsDefaultIBAN);
  }

  private class func rule10(account: String, var bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    if bankCode == "50050222" {
      bankCode = "50050201";
    }
    return defaultRuleWithAccountMapping(account, bankCode: bankCode, version: version);
  }

  private class func rule12(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return defaultRuleWithAccountMapping(account, bankCode: "50050000", version: version);
  }

  private class func rule13(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return defaultRuleWithAccountMapping(account, bankCode: "30050000", version: version);
  }

  private class func rule14(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, "30060601", "", .IBANToolsDefaultIBAN);
  }

  private class func rule19(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, "50120383", "", .IBANToolsDefaultIBAN);
  }

  private class func rule20(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }

  private class func rule21(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }

  private class func rule22(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }

  private class func rule23(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }

  private class func rule24(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }

  private class func rule25(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }

  private class func rule26(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }

  private class func rule27(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }

  private class func rule28(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }

  private class func rule29(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }
  
  private class func rule30(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }

  private class func rule31(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }

  private class func rule32(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }

  private class func rule33(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }

  private class func rule34(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }

  private class func rule35(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }

  private class func rule36(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }

  private class func rule37(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }

  private class func rule38(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }

  private class func rule39(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }
  
  private class func rule40(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }

  private class func rule41(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }

  private class func rule42(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }

  private class func rule43(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }

  private class func rule44(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }

  private class func rule45(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }

  private class func rule46(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }

  private class func rule47(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }

  private class func rule48(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }

  private class func rule49(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }
  
  private class func rule50(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }

  private class func rule51(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }

  private class func rule52(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }

  private class func rule53(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }

  private class func rule54(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }

  private class func rule55(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }

  private class func rule56(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }

  private class func rule57(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }

  private class func rule58(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }

  private class func rule59(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }
  
  private class func rule60(account: String, bankCode: String, version: Int) -> (String, String, String, IBANToolsResult) {
    return (account, bankCode, "", .IBANToolsDefaultIBAN);
  }

}