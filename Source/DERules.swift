/**
* Copyright (c) 2014, 2017, Mike Lischke. All rights reserved.
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

  fileprivate struct BankEntry {         // Details for a given bank code.
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

    // Additional info not found in the official bank codes file.
    var hbciVersion: String = "";
    var pinTanVersion: String = "";
    var hostURL: String = "";
    var pinTanURL: String = "";
  }

  typealias RuleResult = (account: String, bankCode: String, iban: String, result: IBANToolsResult);
  typealias RuleClosure = (String, String, Int) -> RuleResult;

  static fileprivate var institutes: [Int: BankEntry] = [:];
  static fileprivate var bicToBankCode: [String: Int] = [:]; // Reverse lookup.

  // An array of rules. The signature is a bit complicated because some rules only modify
  // the account number or the bank code, but otherwise use the default IBAN creation rule.
  // We could use inout parameters, but Swift crashs if inout is used for the array closures.
  static fileprivate var rules: [RuleClosure] = [
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
  static fileprivate let bankCodes5: Set<Int> = [
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

  static fileprivate let accounts54: Set<Int> = [
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

    let bundle = Bundle(for: DERules.self);
    if let resourcePath = bundle.path(forResource: "bank_codes", ofType: "txt", inDirectory: "de") {
      loadData((resourcePath as NSString).deletingLastPathComponent);
    }
  }

  fileprivate class func fillZKADetails(_ entry: inout BankEntry, details: [String]) -> Void {
    var version = details[8];
    if version.characters.count > 0 {
      // Convert x.y to xy0 form (e.g. 2.2 to 220).
      version.remove(at: version.characters.index(version.startIndex, offsetBy: 1));
      entry.hbciVersion = version + "0";
    }

    version = details[24];
    if version.characters.count > 0 {
      // Special format here. So do a simple mapping of the few possible values.
      if version == "FinTS V3.0" {
        entry.pinTanVersion = "300";
      } else {
        if version.hasPrefix("HBCI 2.2") {
          entry.pinTanVersion = "220";
          if version.hasSuffix("1.01") {
            entry.pinTanVersion = "plus";
          }
        } // Otherwise unknown.
      }
    }

    entry.hostURL = details[6];
    entry.pinTanURL = details[23];

    // Usually the ZKA file has preciser bank names, so we use them if available.
    if details[2].characters.count > 0 {
      entry.name = details[2];
    }
  }

  override class func loadData(_ path: String) {
    // For german banks we combine 2 files (the bank code file from the Deutsche Bundesbank and
    // a similar file from the ZKA) to form our database. They are kept separate in order to ease
    // updating them individually at arbitrary intervals.
    var zkaData: [Int: [String]] = [:]; // bank code + details.

    if FileManager.default.fileExists(atPath: path + "/fints_institute.csv") {
      do {
        let content = try NSString(contentsOfFile: path + "/fints_institute.csv", encoding: String.Encoding.utf8.rawValue)

        var firstLineSkipped = false;
        for line in content.components(separatedBy: CharacterSet.newlines) {
          let s = (line as NSString).trimmingCharacters(in: CharacterSet.whitespaces);
          if s.characters.count == 0 || !firstLineSkipped {
            firstLineSkipped = true;
            continue;
          }

          let values = s.components(separatedBy: ";");
          if values.count > 1 && values[1].characters.count > 0 {
            zkaData[Int(values[1])!] = values;
          }
        }
      } catch let error as NSError {
        let alert = NSAlert.init(error: error);
        alert.runModal();
        return;
      }
    }

    if FileManager.default.fileExists(atPath: path + "/bank_codes.txt") {
      do {
        let content = try NSString(contentsOfFile: path + "/bank_codes.txt", encoding: String.Encoding.utf8.rawValue)
        institutes = [:];
        bicToBankCode = [:];

        // Extract bank code details.
        for line in content.components(separatedBy: CharacterSet.newlines) {
          let s: NSString = line as NSString;
          if s.length < 168 {
            continue; // Not a valid line.
          }

          // 1 for the primary institute or subsidiary, 2 for additional subsidiaries that
          // should not take part in the payments. They share the same bank code anyway.
          let mark = Int(line[line.characters.index(line.startIndex, offsetBy: 8)...line.characters.index(line.startIndex, offsetBy: 8)]);
          if mark == 2 {
            continue;
          }

          var entry = BankEntry();

          let bankCode = Int(line[line.startIndex..<line.characters.index(line.startIndex, offsetBy: 8)])!;
          entry.name = line[line.characters.index(line.startIndex, offsetBy: 9)..<line.characters.index(line.startIndex, offsetBy: 67)].trimmingCharacters(in: CharacterSet.whitespaces);
          entry.postalCode = line[line.characters.index(line.startIndex, offsetBy: 67)..<line.characters.index(line.startIndex, offsetBy: 72)];
          entry.place = line[line.characters.index(line.startIndex, offsetBy: 72)..<line.characters.index(line.startIndex, offsetBy: 107)].trimmingCharacters(in: CharacterSet.whitespaces);
          entry.bic = line[line.characters.index(line.startIndex, offsetBy: 139)..<line.characters.index(line.startIndex, offsetBy: 150)];
          entry.checksumMethod = line[line.characters.index(line.startIndex, offsetBy: 150)..<line.characters.index(line.startIndex, offsetBy: 152)];
          entry.isDeleted = line[line.characters.index(line.startIndex, offsetBy: 158)] == "D";
          entry.replacement = Int(line[line.characters.index(line.startIndex, offsetBy: 160)..<line.characters.index(line.startIndex, offsetBy: 168)])!;

          if s.length > 168 {
            // Extended bank code file.
            entry.rule = Int(line[line.characters.index(line.startIndex, offsetBy: 168)..<line.characters.index(line.startIndex, offsetBy: 172)])!;
            entry.ruleVersion = Int(line[line.characters.index(line.startIndex, offsetBy: 172)..<line.characters.index(line.startIndex, offsetBy: 174)])!;
          }

          // Look for additional info in the ZKA dataset. If an entry can be found for the given
          // bank code remove it afterwards, so we get a list of entries at the end that are not
          // in the bank code list.
          if let zkaDetails = zkaData[bankCode] {
            fillZKADetails(&entry, details: zkaDetails);
            zkaData.removeValue(forKey: bankCode);
          }

          institutes[bankCode] = entry;
          bicToBankCode[entry.bic] = bankCode; // Note: this is not unique! There can be more than one bank code for a BIC.
        }
      } catch let error as NSError {
        let alert = NSAlert.init(error: error);
        alert.runModal();
        return;
      }


      // Finally go over the remaining entries in the ZKA data and create institutes entries from them.
      // These may contain entries for deleted or otherwise invalid banks.
      for (bankCode, zkaDetails) in zkaData {
        var entry = BankEntry();

        entry.name = zkaDetails[2];
        entry.postalCode = "";
        entry.place = zkaDetails[3];
        entry.bic = "";
        entry.checksumMethod = ""; // Invalid checksum rule. We have no info about this.
                                   // Causes our private bank code mapping to kick in.
        entry.isDeleted = false;
        entry.replacement = 0;
        entry.rule = 1000;         // Invalid IBAN rule. No info about that either.
        entry.ruleVersion = 0;
        fillZKADetails(&entry, details: zkaDetails);

        // No reverse lookup via BIC. The ZKA file doesn't contain BICs.
        institutes[bankCode] = entry;
      }
    }
  }

  override class func onlineDetailsForBIC(_ bic: String) -> (hbciVersion: String, pinTanVersion: String, hostURL: String, pinTanURL: String) {
    var bic = bic
    if let bankCode = bicToBankCode[bic], let entry = institutes[bankCode] {
      return (entry.hbciVersion, entry.pinTanVersion, entry.hostURL, entry.pinTanURL);
    }

    if !bic.hasSuffix("XXX") {
      // Try the generic form (no subsidary) if we couldn't find an entry.
      bic = (bic as NSString).substring(to: bic.characters.count - 3) + "XXX";
      if let bankCode = bicToBankCode[bic], let entry = institutes[bankCode] {
        return (entry.hbciVersion, entry.pinTanVersion, entry.hostURL, entry.pinTanURL);
      }
    }

    return ("", "", "", "");
  }

  /// Override institutes info from the ECB by local information from the ZKA
  /// (or even provide info at all for institutes not listed by the ECB).
  override class func instituteDetailsForBIC(_ bic: String) -> InstituteInfo? {
    if let bankCode = bicToBankCode[bic], let entry = institutes[bankCode] {
      let info = InstituteInfo();
      info.mfiID = "";
      info.bic = entry.bic;
      info.bankCode = bankCode;
      info.countryCode = "DE";
      info.name = entry.name;
      info.postal = entry.postalCode;
      info.city = entry.place;
      info.reserve = false;
      info.exempt = false;

      info.hbciVersion = entry.hbciVersion;
      info.pinTanVersion = entry.pinTanVersion;
      info.hostURL = entry.hostURL;
      info.pinTanURL = entry.pinTanURL;
      
      return info;
    };

    return nil;
  }

  /// Same as instituteDetailsForBIC but use bank codes instead. These allow for more details
  /// because the ECB list doesn't contain bank codes (and multiple bank codes can stand for the same BIC).
  override class func instituteDetailsForBankCode(_ bankCode: String) -> InstituteInfo? {
    if let bank = Int(bankCode), let entry = institutes[bank] {
      let info = InstituteInfo();
      info.mfiID = "";
      info.bic = entry.bic;
      info.bankCode = bank;
      info.countryCode = "DE";
      info.name = entry.name;
      info.postal = entry.postalCode;
      info.city = entry.place;
      info.reserve = false;
      info.exempt = false;

      info.hbciVersion = entry.hbciVersion;
      info.pinTanVersion = entry.pinTanVersion;
      info.hostURL = entry.hostURL;
      info.pinTanURL = entry.pinTanURL;

      return info;
    };

    return nil;
  }
  
  /// Returns the method to be used for account checks for the specific institute.
  /// May return an empty string if we have no info for the given bank code.
  class func checkSumMethodForInstitute(_ bankCode: String) -> String {
    let bank = Int(bankCode);
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

  fileprivate class func ruleForAccount(_ account: String, bankCode: String) -> (Int, Int, String) {
    if let bank = Int(bankCode) {
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
  override class func validWithoutChecksum(_ account: String, _ bankCode: String) -> Bool {
    if (bankCode == "21060237" || bankCode == "10060237") && accounts54.contains(Int(account)!) {
      return true;
    }
    return false;
  }

  override class func convertToIBAN(_ account: inout String, _ bankCode: inout String) -> ConversionResult {
    var (rule, version, bankNumber) = ruleForAccount(account, bankCode: bankCode);

    // Same here as with the account checks. If we cannot find an entry for a given bank
    // because it might have been deleted and hence is no longer in the database) try a lookup
    // in our internal mappings.
    if rule > rules.count {
      let newBankCode = DEAccountCheck.bankCodeFromAccountCluster(Int(account)!, bankCode: Int(bankCode)!);
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
    return ("", .noMethod);
  }

  override class func bicForBankCode(_ bankCode: String) -> (bic: String, result: IBANToolsResult) {
    if let bank = Int(bankCode) {
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
          let cluster = bankString.substring(with: NSMakeRange(3, 3));
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

        if institute.bic.characters.count > 0 { // Some institutes don't have a BIC (if data comes from ZKA).
          return (institute.bic, .ok);
        }
      }
    }

    return ("", .noBIC);
  }

  fileprivate class func defaultRule(_ account: String, bankCode: String, version: Int) -> RuleResult {
    return (account, bankCode, "", .defaultIBAN);
  }

  private class func defaultRuleWithAccountMapping(_ account: String, bankCode: String, version: Int) ->
    RuleResult {
    var account = account, bankCode = bankCode

    let (valid, result) = DEAccountCheck.isValidAccount(&account, &bankCode, true);
    if !valid {
      return (account, bankCode, "", result);
    }
    return (account, bankCode, "", .defaultIBAN);
  }

  fileprivate class func rule1(_ account: String, bankCode: String, version: Int) -> RuleResult {
    return (account, bankCode, "", .noConversion);
  }

  fileprivate class func rule2(_ account: String, bankCode: String, version: Int) -> RuleResult {
    // No IBANs for nnnnnnn86n and nnnnnnn6nn.
    if account[account.characters.index(account.endIndex, offsetBy: -3)] == "6" {
      return (account, bankCode, "", .noConversion);
    }

    if (account[account.characters.index(account.endIndex, offsetBy: -2)] == "6") && (account[account.characters.index(account.endIndex, offsetBy: -3)] == "8") {
      return (account, bankCode, "", .noConversion);
    }

    return (account, bankCode, "", .defaultIBAN);
  }

  fileprivate class func rule3(_ account: String, bankCode: String, version: Int) -> RuleResult {
    if account == "6161604670" {
      return (account, bankCode, "", .noConversion);
    }

    return (account, bankCode, "", .defaultIBAN);
  }

  private class func rule5(_ account: String, bankCode: String, version: Int) -> RuleResult {
    var account = account, bankCode = bankCode
    let code = Int(bankCode)!;
    if code == 50040033 {
      return (account, bankCode, "", .noConversion);
    }

    let number = Int(account)!;

    if bankCodes5.contains(code) && 0998000000...0999499999 ~= number {
        return (account, bankCode, "", .noConversion);
    }

    let temp = String(number); // Like the original account number but without leading zeros.

    let checksumMethod = checkSumMethodForInstitute(bankCode);
    if checksumMethod == "13" && 6...7 ~= temp.characters.count {
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

    return (account, bankCode, "", .defaultIBAN);
  }
  
  fileprivate class func rule8(_ account: String, bankCode: String, version: Int) -> RuleResult {
    return (account, "50020200", "", .defaultIBAN);
  }

  private class func rule9(_ account: String, bankCode: String, version: Int) -> RuleResult {
    var account = account
    let s = account as NSString;
    if s.length == 10 && s.hasPrefix("1116") {
      account = "3047" + s.substring(from: 4);
    }
    return (account, "68351557", "", .defaultIBAN);
  }

  private class func rule10(_ account: String, bankCode: String, version: Int) -> RuleResult {
    var bankCode = bankCode
    if bankCode == "50050222" {
      bankCode = "50050201";
    }
    return defaultRuleWithAccountMapping(account, bankCode: bankCode, version: version);
  }

  fileprivate class func rule12(_ account: String, bankCode: String, version: Int) -> RuleResult {
    return defaultRuleWithAccountMapping(account, bankCode: "50050000", version: version);
  }

  fileprivate class func rule13(_ account: String, bankCode: String, version: Int) -> RuleResult {
    return defaultRuleWithAccountMapping(account, bankCode: "30050000", version: version);
  }

  fileprivate class func rule14(_ account: String, bankCode: String, version: Int) -> RuleResult {
    return (account, "30060601", "", .defaultIBAN);
  }

  fileprivate class func rule19(_ account: String, bankCode: String, version: Int) -> RuleResult {
    return (account, "50120383", "", .defaultIBAN);
  }

  private class func rule20(_ account: String, bankCode: String, version: Int) -> RuleResult {
    var account = account, bankCode = bankCode
    let checksumMethod = checkSumMethodForInstitute(bankCode);

    if bankCode == "76026000" {
      // Norisbank. Check out without alternative (rule 06).
      let (valid, _, _) = DEAccountCheck.checkWithMethod(checksumMethod, &account, &bankCode, true, false);
      if !valid {
        return (account, bankCode, "", .noConversion);
      }
    }

    switch account.characters.count {
    case 1...4:
      return (account, bankCode, "", .noConversion);
    case 7:
      // Check first as if the sub account where missing.
      var account2 = account + "00";
      var (valid, result, _) = DEAccountCheck.checkWithMethod(checksumMethod, &account2, &bankCode, true);
      if valid {
        return (account2, bankCode, "", .defaultIBAN);
      }
      (valid, result, _) = DEAccountCheck.checkWithMethod(checksumMethod, &account, &bankCode, true);
      if !valid {
        return (account, bankCode, "", result);
      }

    case 5, 6:
      let (valid, result, _) = DEAccountCheck.checkWithMethod(checksumMethod, &account, &bankCode, true);
      if !valid {
        return (account, bankCode, "", result);
      }
      account += "00";
    default:
      break;
    }
    return (account, bankCode, "", .defaultIBAN);
  }

  fileprivate class func rule25(_ account: String, bankCode: String, version: Int) -> RuleResult {
    return (account, "60050101", "", .defaultIBAN);
  }

  fileprivate class func rule28(_ account: String, bankCode: String, version: Int) -> RuleResult {
    return (account, "25050180", "", .defaultIBAN);
  }

  private class func rule29(_ account: String, bankCode: String, version: Int) -> RuleResult {
    var account = account
    let accountAsInt = Int(account)!;
    account = String(accountAsInt); // Remove any leading 0.
    if account.characters.count == 10 {
      account = "0" + (account as NSString).substring(to: 3) + (account as NSString).substring(from: 4);
    }
    return (account, bankCode, "", .defaultIBAN);
  }
  
  private class func rule31(_ account: String, bankCode: String, version: Int) -> RuleResult {
    var account = account, bankCode = bankCode
    let accountAsInt = Int(account)!;
    account = String(accountAsInt);
    if account.characters.count < 10 { // Rule only valid for 10 digits account numbers.
      return (account, bankCode, "", .noConversion);
    }

    let newBankCode = DEAccountCheck.bankCodeFromAccount(accountAsInt, forRule: 31);
    if newBankCode > -1 {
      bankCode = String(newBankCode);
    }
    return (account, bankCode, "", .defaultIBAN);
  }

  private class func rule323435(_ account: String, bankCode: String, version: Int) -> RuleResult {
    var bankCode = bankCode
    let accountAsInt = Int(account)!;
    if 800_000_000...899_999_999 ~= accountAsInt {
      return (account, bankCode, "", .noConversion);
    }

    let newBankCode = DEAccountCheck.bankCodeFromAccount(accountAsInt, forRule: 31);
    if newBankCode > -1 {
      bankCode = String(newBankCode);
    }
    return (account, bankCode, "", .defaultIBAN);
  }

  private class func rule33(_ account: String, bankCode: String, version: Int) -> RuleResult {
    var bankCode = bankCode
    let accountAsInt = Int(account)!;
    let newBankCode = DEAccountCheck.bankCodeFromAccount(accountAsInt, forRule: 31);
    if newBankCode > -1 {
      bankCode = String(newBankCode);
    }
    return (account, bankCode, "", .defaultIBAN);
  }

  private class func rule36(_ account: String, bankCode: String, version: Int) -> RuleResult {
    var account = account
    let accountAsInt = Int(account)!;
    switch accountAsInt {
    case 0...999999:
      account = String(accountAsInt) + "000";

    case 0000000000...0000099999, 0000900000...0029999999, 0060000000...0099999999,
         0900000000...0999999999, 2000000000...2999999999, 7100000000...8499999999,
         8600000000...8999999999:
      return (account, bankCode, "", .noConversion);
      
    default:
      break;
    }
    return (account, "21050000", "", .defaultIBAN);
  }

  fileprivate class func rule37(_ account: String, bankCode: String, version: Int) -> RuleResult {
    return (account, "30010700", "", .defaultIBAN);
  }

  fileprivate class func rule38(_ account: String, bankCode: String, version: Int) -> RuleResult {
    return (account, "28590075", "", .defaultIBAN);
  }

  fileprivate class func rule39(_ account: String, bankCode: String, version: Int) -> RuleResult {
    return (account, bankCode, "", .defaultIBAN);
  }
  
  fileprivate class func rule40(_ account: String, bankCode: String, version: Int) -> RuleResult {
    return (account, "68052328", "", .defaultIBAN);
  }

  fileprivate class func rule41(_ account: String, bankCode: String, version: Int) -> RuleResult {
    if bankCode == "62220000" {
      return (account, bankCode, "DE96500604000000011404", .ok);
    }
    return (account, bankCode, "", .defaultIBAN);
  }

  fileprivate class func rule42(_ account: String, bankCode: String, version: Int) -> RuleResult {
    let accountAsInt = Int(account)!;
    if !(10000000...99999999 ~= accountAsInt) { // Only accounts with 8 digits are valid.
      return (account, bankCode, "", .noConversion);
    }

    if 0...999 ~= (accountAsInt % 100000) { // No IBAN for nnn 0 0000 through nnn 0 0999.
      return (account, bankCode, "", .noConversion);
    }

    if 50462000...50463999 ~= accountAsInt || 50469000...50469999 ~= accountAsInt {
      return (account, bankCode, "", .defaultIBAN);
    }

    if (accountAsInt / 10000) % 10 != 0 { // Only accounts with 0 at 4th position.
      return (account, bankCode, "", .noConversion);
    }
    return (account, bankCode, "", .defaultIBAN);
  }

  private class func rule43(_ account: String, bankCode: String, version: Int) -> RuleResult {
    var account = account, bankCode = bankCode
    if bankCode == "60651070" {
      bankCode = "66650085"; // Now accounts must be valid for this new bank code, so do another account check.

      let checksumMethod = checkSumMethodForInstitute(bankCode);
      let (valid, result, _) = DEAccountCheck.checkWithMethod(checksumMethod, &account, &bankCode, true);
      if !valid {
        return (account, bankCode, "", result);
      }
    }
    return (account, bankCode, "", .defaultIBAN);
  }

  fileprivate class func rule46(_ account: String, bankCode: String, version: Int) -> RuleResult {
    return (account, "31010833", "", .defaultIBAN);
  }

  private class func rule47(_ account: String, bankCode: String, version: Int) -> RuleResult {
    var account = account
    let accountAsInt = Int(account)!;
    if 10000000...99999999 ~= accountAsInt { // 8 digit accounts must be right-justified, instead of the usual left alignment.
      account = String(accountAsInt) + "00";
    }
    return (account, bankCode, "", .defaultIBAN);
  }

  private class func rule49(_ account: String, bankCode: String, version: Int) -> RuleResult {
    var account = account
    if bankCode == "30060010" || bankCode == "40060000" || bankCode == "57060000" {
      let accountAsInt = Int(account)!;
      account = String(accountAsInt);
      if account.characters.count < 10 {
        account = String(repeating: "0", count: 10 - account.characters.count) + account;
      }
      let s = account as NSString;
      if s.character(at: 4) == 0x39 {
        account = s.substring(from: 4) + s.substring(to: 4);
      }
    }
    return (account, bankCode, "", .defaultIBAN);
  }
  
  private class func rule52(_ account: String, bankCode: String, version: Int) -> RuleResult {
    var account = account, bankCode = bankCode
    // Only very specific account/bank code combinations are allowed for conversion.
    if DEAccountCheck.checkSpecialAccount(&account, bankCode: &bankCode) {
      return (account, bankCode, "", .defaultIBAN);
    }
    return (account, bankCode, "", .noConversion);
  }

  fileprivate class func rule55(_ account: String, bankCode: String, version: Int) -> RuleResult {
    return (account, "25410200", "", .defaultIBAN);
  }

  fileprivate class func rule56(_ account: String, bankCode: String, version: Int) -> RuleResult {
    if Int(account)! < 1000000000 { // Only accounts with 10 digits can be used.
      return (account, bankCode, "", .noConversion);
    }
   return (account, bankCode, "", .defaultIBAN);
  }

}
