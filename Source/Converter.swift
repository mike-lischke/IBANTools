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

@objc public enum IBANToolsResult: Int {
  case DefaultIBAN // The default rule for generating an IBAN was used.
  case OK          // Conversion/check was ok.
  case NoBIC       // No known BIC.

  // All other results are returned by country specific code only.
  case BadAccount   // The account was rejected (e.g. wrong checksum).
  case BadBank      // The bank code was rejected (e.g. deleted bank entry).
  case NoMethod     // Couldn't find any conversion/checksum method.
  case NoConversion // No IBAN conversion by intention (always invalid).
  case NoChecksum   // No checksum computation/check by intention for bank accounts (always valid).
  case WrongValue   // One of the given parameters was wrong (0 for account/bank,
                    // no 2 letter country code, invalid chars etc.).

  public func description() -> String {
    switch self {
    case DefaultIBAN:
      return "DefaultIBAN";
    case OK:
      return "OK";
    case NoBIC:
      return "NoBIC";
    case BadAccount:
      return "BadAccount";
    case BadBank:
      return "BadBank";
    case NoMethod:
      return "NoMethod";
    case NoConversion:
      return "NoConversion";
    case NoChecksum:
      return "NoChecksum";
    case WrongValue:
      return "WrongValue";
    }
  }
}

public class InstituteInfo: NSObject {
  public var mfiID: String;
  public var bic: String;
  public var countryCode: String;
  public var name: String;
  public var box: String;
  public var address: String;
  public var postal: String;
  public var city: String;
  public var category: String;
  public var domicile: String;
  public var headName: String;
  public var reserve: Bool;
  public var exempt: Bool;

  public var hbciVersion: String;   // for DDV + RDH
  public var pinTanVersion: String; // for HBCI Pin/Tan + RDH
  public var hostURL: String;       // host URL for DDV + RDH
  public var pinTanURL: String;

  override init() {
    mfiID = "";
    bic = "";
    countryCode = "";
    name = "";
    box = "";
    address = "";
    postal = "";
    city = "";
    category = "";
    domicile = "";
    headName = "";
    reserve = false;
    exempt = false;

    hbciVersion = "";   // for DDV + RDH
    pinTanVersion = ""; // for HBCI Pin/Tan + RDH
    hostURL = "";       // host URL for DDV + RDH
    pinTanURL = "";
  }
}

typealias ConversionResult = (iban: String, result: IBANToolsResult);

/// Base classes for country specific rules.
/// Note: @objc and the NSObject base class are necessary to make dynamic instantiation + initialize override working.
class IBANRules : NSObject {
  class func loadData(path: String) {
  }

  class func onlineDetailsForBIC(bic: String) -> (hbciVersion: String, pinTanVersion: String, hostURL: String, pinTanURL: String) {
    return ("", "", "", "");
  }

  class func validWithoutChecksum(account: String, _ bankCode: String) -> Bool {
    return false;
  }

  class func convertToIBAN(inout account: String, inout _ bankCode: String) -> ConversionResult {
    return ("", .NoConversion);
  }

  class func bicForBankCode(bankCode: String) -> (bic: String, result: IBANToolsResult) {
    return ("", .NoBIC);
  }

  class func instituteDetailsForBIC(bic: String) -> InstituteInfo? {
    return nil;
  }
}

class AccountCheck : NSObject {
  class func loadData(path: String) {
  }

  class func isValidAccount(inout account: String, inout _ bankCode: String, _ forIBAN: Bool) ->
    (valid: Bool, result: IBANToolsResult) {
    return (false, .NoMethod);
  }
}

public class IBANtools: NSObject {

  private static var institutesInfo: [String: InstituteInfo] = [:];
  private static var usedPath: String?;
  private static var patternForBIC: NSRegularExpression?;

  override public class func initialize() {
    super.initialize();

    patternForBIC = try? NSRegularExpression(pattern: "^([a-zA-Z]{4}[a-zA-Z]{2}[a-zA-Z0-9]{2}([a-zA-Z0-9]{3})?)$",
      options: .CaseInsensitive);

    let bundle = NSBundle(forClass: IBANtools.self);
    if let resourcePath = bundle.pathForResource("eu_all_mfi", ofType: "txt", inDirectory: "") {
      loadData((resourcePath as NSString).stringByDeletingLastPathComponent);
    }
  }

  private class func loadData(path: String) {
    if NSFileManager.defaultManager().fileExistsAtPath(path + "/eu_all_mfi.txt") {
      do {
        let content = try NSString(contentsOfFile: path + "/eu_all_mfi.txt", encoding: NSUTF8StringEncoding);
        let bundle = NSBundle(forClass: IBANtools.self);

        usedPath = path + "/eu_all_mfi.txt";
        institutesInfo = [:];

        // Extract institute details.
        for line in content.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()) {
          let s: NSString = line as NSString;
          let entry = s.componentsSeparatedByString("\t") ;
          if entry.count == 0 {
            continue;
          }
          if entry[0] == "MFI_ID" {
            continue; // Header line.
          }

          // The ECB MFI file doesn't contain PIN/TAN URLs or HBCI/FinTS version numbers used
          // by a specific bank, so we ask the country specific classes for that info.
          var hbciVersion = "";
          var pinTanVersion = "";
          var hostURL = "";
          var pinTanURL = "";
          if let clazz: AnyClass = bundle.classNamed(entry[2] + "Rules") where entry[1].characters.count > 0 {
            let rulesClass = clazz as! IBANRules.Type;
            (hbciVersion, pinTanVersion, hostURL, pinTanURL) = rulesClass.onlineDetailsForBIC(entry[1]);
          }

          let info = InstituteInfo();
          info.mfiID = entry[0];
          info.bic = entry[1];
          info.countryCode = entry[2];
          info.name = entry[3];
          info.box = entry[4]
          info.address = entry[5];
          info.postal = entry[6];
          info.city = entry[7];
          info.category = entry[8];
          info.domicile = entry[9];
          info.headName = entry[11];
          info.reserve = entry[12] == "Yes";
          info.exempt = entry[13] == "Yes";

          info.hbciVersion = hbciVersion;
          info.pinTanVersion = pinTanVersion;
          info.hostURL = hostURL;
          info.pinTanURL = pinTanURL;

          // Many entries in the file have no BIC and a few use the same BIC. In both cases
          // we use the MFI ID instead (which is unique). We may later find a way to get the MFI ID
          // from a BIC.
          var key = entry[1].characters.count > 0 ? entry[1] : entry[0];
          if institutesInfo[key] != nil {
            key = entry[0];
          }
          institutesInfo[key] = info; // Info keyed by BIC or (if the bic is empty/duplicate) by MFI ID.
        }
      }
      catch let error as NSError {
        let alert = NSAlert.init(error: error);
        alert.runModal();
        return;
      }
    }
  }

  public class func useResourcePath(path: String) {
    if usedPath != nil && usedPath! != path {

      // First let support classes load their data. We may need that for our initialization.
      let bundle = NSBundle(forClass: IBANtools.self);
      for entry in countryData.keys {
        var clazz: AnyClass! = bundle.classNamed(entry + "AccountCheck");
        if clazz != nil {
          let rulesClass = clazz as! AccountCheck.Type;
          return rulesClass.loadData(path);
        }

        clazz = bundle.classNamed(entry + "Rules");
        if clazz != nil {
          let rulesClass = clazz as! IBANRules.Type;
          return rulesClass.loadData(path);
        }
      }

      // Now we can load our own data.
      loadData(path);
    }
  }

  /// Returns address, name and other info about an institute in Europe.
  /// Some of the financial institues in our list have no bic and the MFI ID is used as key.
  /// So it can happen we cannot return such details even though we would have an entry for that institute.
  public class func instituteDetailsForBIC(bic: String) -> InstituteInfo? {

    // Let country rules override ECB data.
    let bundle = NSBundle(forClass: IBANtools.self);
    for entry in countryData.keys {
      let clazz: AnyClass! = bundle.classNamed(entry + "Rules");
      if clazz != nil {
        let rulesClass = clazz as! IBANRules.Type;
        if let result = rulesClass.instituteDetailsForBIC(bic) {
          return result;
        }
      }
    }

    var result = institutesInfo[bic];
    if result == nil && !bic.hasSuffix("XXX") {
      // If we cannot find anything for the given bic and it is not already in the generic form
      // (XXX at the end for no specific subsidary) try another lookup using the generic form.
      let newBic = (bic as NSString).substringToIndex(bic.characters.count - 3) + "XXX";
      result = institutesInfo[newBic];
    }
    return result;
  }

  /// Validates the given IBAN. Returns true if the number is valid, otherwise false.
  public class func isValidIBAN(iban: String?) -> Bool {
    if iban == nil || (iban!).characters.count < 8 {
        return false;
    }
    return computeChecksum(iban!) == 97;
  }

  public class func isValidBIC(text: String?) -> Bool {
    if (text == nil || (text!).characters.count == 0) {
      return false;
    }

    return patternForBIC?.numberOfMatchesInString(text!, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, (text!).characters.count)) == 1;
  }

  /// Wrapper function for isValidAccount function to be usable by Obj-C.
  /// Entries used in the result dictionaries:
  ///   "valid" (Bool in an NSNumber)
  ///   "result" (IBANToolsResult in an NSNumber)
  ///   "account" (String)
  ///   "bankCode" (String)
  public class func isValidAccount(account: String, bankCode: String, countryCode: String, forIBAN: Bool = false) ->
    Dictionary<String, AnyObject> {

    var mutableAccount = account;
    var mutableBankCode = bankCode;
    let results = isValidAccount(&mutableAccount, bankCode: &mutableBankCode, countryCode: countryCode, forIBAN: forIBAN);
    let result: Dictionary<String, AnyObject> = [
      "valid": NSNumber(bool: results.valid),
      "account": mutableAccount,
      "bankCode": mutableBankCode,
      "result": NSNumber(integer: results.result.rawValue),
    ];

    return result;
  }

  /// Validates the given bank account number. Returns true if the number is valid, otherwise false.
  /// This check involves institute specific checksum rules.
  /// Also returns the real account number if the given one is special (e.g. for donations).
  public class func isValidAccount(inout account: String, inout bankCode: String, var countryCode: String, forIBAN: Bool = false) ->
    (valid: Bool, result: IBANToolsResult) {

    account = account.stringByReplacingOccurrencesOfString(" ", withString: "");
    bankCode = bankCode.stringByReplacingOccurrencesOfString(" ", withString: "");
    if account.characters.count == 0 || bankCode.characters.count == 0 || countryCode.characters.count != 2 {
      return (false, .WrongValue);
    }

    if containsInvalidChars(account) || containsInvalidChars(bankCode) {
      return (false, .WrongValue);
    }

    countryCode = countryCode.uppercaseString;

    if let _ = countryData[countryCode] {
      let bundle = NSBundle(forClass: IBANtools.self);
      let clazz: AnyClass! = bundle.classNamed(countryCode + "AccountCheck");
      if clazz != nil {
        let rulesClass = clazz as! AccountCheck.Type;
        return rulesClass.isValidAccount(&account, &bankCode, forIBAN);
      }
    }

    return (true, .OK); // For any country for which we have no checksum check assume everything is ok.
  }

  /// Wrapper function for bicForBankCode function to be usable by Obj-C.
  /// Entries used in the result dictionaries:
  ///   "bic" (String)
  ///   "result" (IBANToolsResult in an NSNumber)
  public class func bicForBankCode(bankCode: String, countryCode: String) -> Dictionary<String, AnyObject> {
    let results: (bic: String, result: IBANToolsResult) = bicForBankCode(bankCode, countryCode: countryCode);
    let result: Dictionary<String, AnyObject> = [
      "bic": results.bic,
      "result": NSNumber(integer: results.result.rawValue),
    ];

    return result;
  }

  /// Returns the BIC for a given bank code. Since there is no generic procedure to determine the BIC
  /// this lookup only works for those countries with a specific implementation (DE atm).
  public class func bicForBankCode(var bankCode: String, var countryCode: String) -> (bic: String, result: IBANToolsResult) {
    bankCode = bankCode.stringByReplacingOccurrencesOfString(" ", withString: "");
    if bankCode.characters.count == 0 || countryCode.characters.count != 2 {
      return ("", .WrongValue);
    }

    if containsInvalidChars(bankCode) {
      return ("", .WrongValue);
    }

    countryCode = countryCode.uppercaseString;

    if let _ = countryData[countryCode] {
      let bundle = NSBundle(forClass: IBANtools.self);
      let clazz: AnyClass! = bundle.classNamed(countryCode + "Rules");
      if clazz != nil {
        let rulesClass = clazz as! IBANRules.Type;
        return rulesClass.bicForBankCode(bankCode);
      }
    }

    return ("", .NoBIC);
  }
  
  /// Wrapper function for bicForIBAN function to be usable by Obj-C.
  /// Entries used in the result dictionaries:
  ///   "bic" (String)
  ///   "result" (IBANToolsResult in an NSNumber)
  public class func bicForIBAN(iban: String?) -> Dictionary<String, AnyObject> {
    let results: (bic: String, result: IBANToolsResult) = bicForIBAN(iban);
    let result: Dictionary<String, AnyObject> = [
      "bic": results.bic,
      "result": NSNumber(integer: results.result.rawValue),
    ];

    return result;
  }
  
  /// Returns the BIC for a given IBAN.
  public class func bicForIBAN(iban: String?) -> (bic: String, result: IBANToolsResult) {

    if iban != nil && (iban!).characters.count > 8 {
      let countryCode = iban!.substringToIndex(iban!.startIndex.advancedBy(2));
      if let details = countryData[countryCode.uppercaseString] {
        let bankCode = (iban! as NSString).substringWithRange(NSMakeRange(4, details.bankCodeLength));
        return bicForBankCode(bankCode, countryCode: countryCode);
      }
    }
    return ("", .NoBIC);
  }

  /// Wrapper function for convertToIBAN function to be usable by Obj-C.
  /// Entries used in the result dictionaries:
  ///   "iban" (String)
  ///   "result" (IBANToolsResult in an NSNumber)
  ///   "account" (String)
  ///   "bankCode" (String)
  public class func convertToIBAN(account: String, bankCode: String, countryCode: String,
    validateAccount: Bool = true) -> Dictionary<String, AnyObject> {

    var mutableAccount = account;
    var mutableBankCode = bankCode;
    let results = convertToIBAN(&mutableAccount, bankCode: &mutableBankCode, countryCode: countryCode,
      validateAccount: validateAccount);

    let result: Dictionary<String, AnyObject> = [
      "iban": results.iban,
      "account": mutableAccount,
      "bankCode": mutableBankCode,
      "result": NSNumber(integer: results.result.rawValue),
    ];

    return result;
  }
  
  /// Converts the given account number and bank code to an IBAN number.
  /// Can return an empty string if the given values are invalid or if there's no IBAN conversion.
  /// for a given account number (e.g. for accounts no longer in use).
  /// Notes:
  ///   - Values can contain space chars. They are automatically removed.
  ///   - Switching off account validation is not recommended as often accounts and/or bank codes must be
  ///     replaced by others which happens during account validation. Essentially keep this on except for
  ///     unit testing with random account numbers instead of real ones.
  public class func convertToIBAN(inout account: String, inout bankCode: String, var countryCode: String,
    validateAccount: Bool = true) -> (iban: String, result: IBANToolsResult) {

      account = account.stringByReplacingOccurrencesOfString(" ", withString: "");
      bankCode = bankCode.stringByReplacingOccurrencesOfString(" ", withString: "");
      if account.characters.count == 0 || bankCode.characters.count == 0 || countryCode.characters.count != 2 {
        return ("", .WrongValue);
      }

      if containsInvalidChars(account) || containsInvalidChars(bankCode) {
        return ("", .WrongValue);
      }

      countryCode = countryCode.uppercaseString;

      var result: (String, IBANToolsResult) = ("", .DefaultIBAN);

      // If we have country information call the country converter and then ensure
      // bank code and account number have the desired length.
      if let details = countryData[countryCode] {
        let bundle = NSBundle(forClass: IBANtools.self);
        let clazz: AnyClass! = bundle.classNamed(countryCode + "Rules");

        // Some accounts can be used for IBANs even though they do not validate.
        var ignoreChecksum = false;
        if clazz != nil {
          ignoreChecksum = (clazz as! IBANRules.Type).validWithoutChecksum(account, bankCode);
        }
        if validateAccount && !ignoreChecksum {
          let accountResult = isValidAccount(&account, bankCode: &bankCode, countryCode: countryCode, forIBAN: true)
          if !accountResult.valid {
            return ("", accountResult.result);
          }
        }
        if clazz != nil {
          let rulesClass = clazz as! IBANRules.Type;
          result = rulesClass.convertToIBAN(&account, &bankCode);
        }

        // Do length check *after* the country specific rules. They might rely on the exact
        // account number (e.g. for special accounts).
        if account.characters.count < details.accountLength {
          account = String(count: details.accountLength - account.characters.count, repeatedValue: "0" as Character) + account;
        }
        if bankCode.characters.count < details.bankCodeLength {
          bankCode = String(count: details.bankCodeLength - bankCode.characters.count, repeatedValue: "0" as Character) + bankCode;
        }
      } else {
        if validateAccount {
          let accountResult = isValidAccount(&account, bankCode: &bankCode, countryCode: countryCode, forIBAN: true)
          if !accountResult.valid {
            return ("", accountResult.result);
          }
        }
      }

      if result.1 == .DefaultIBAN {
        var checksum = String(computeChecksum(countryCode + "00" + bankCode.uppercaseString + account.uppercaseString));
        if checksum.characters.count < 2 {
          checksum = "0" + checksum;
        }

        result.0 = countryCode + checksum + bankCode + account;
      }
      return result;
  }

  private class func mod97(s: String) -> Int {
    var result = 0;
    for c in s.characters {
      let i = Int(String(c))!;
      result = (result * 10 + i) % 97;
    }
    return result;
  }

  private class func computeChecksum(iban: NSString) -> Int {
    var work: String = "";
    let countryCode = iban.substringToIndex(2);
    let checksum = iban.substringWithRange(NSMakeRange(2, 2));
    let bban = iban.substringFromIndex(4); // Basic bank account number.
    for char in (bban + countryCode).characters {
      let s = String(char);
      if (char >= "0") && (char <= "9") {
        work += s;
      } else {
        let scalars = s.unicodeScalars;
        let v = scalars[scalars.startIndex].value;
        if v < 55 {
          return 0; // Some invalid character. Return invalid checksum.
        }
        work += String(v - 55);
      }
    }
    work += checksum;
    return 98 - mod97(work);
  }

  /// Checks if the input string only consists of letters and numbers.
  /// Everything else is considered wrong.
  private class func containsInvalidChars(input: String) -> Bool {
    for c in input.characters {
      if c < "0" || (c > "9" && c < "A") || (c > "Z" && c < "a") || c > "z" {
        return true;
      }
    }
    return false;
  }
}

// Public only for test cases.
public let countryData: [String: (country: String, bankCodeLength: Int, accountLength: Int)] = [
  "AL": ("Albania", 8, 16),
  "AD": ("Andorra", 8, 12),
  "AT": ("Austria", 5, 1),
  "BE": ("Belgium", 3, 9),
  "BA": ("Bosnia and Herzegovina", 6, 10),
  "BG": ("Bulgaria", 8, 10),
  "HR": ("Croatia", 7, 10),
  "CY": ("Cyprus", 8, 16),
  "CZ": ("Czech Republic", 4, 16),
  "DK": ("Denmark", 4, 10),
  "EE": ("Estonia", 2, 14),
  "FO": ("Faroe Islands", 4, 10),
  "FI": ("Finland", 6, 8),
  "FR": ("France", 10, 13),
  "GE": ("Georgia", 2, 16),
  "DE": ("Germany", 8, 10),
  "GI": ("Gibraltar", 4, 15),
  "GR": ("Greece", 7, 16),
  "GL": ("Greenland", 4, 10),
  "HU": ("Hungary", 7, 17),
  "IS": ("Iceland", 4, 18),
  "IE": ("Ireland", 10, 8),
  "IL": ("Israel", 6, 13),
  "IT": ("Italy", 11, 12),
  "KZ": ("Kazakhstan", 3, 13),
  "KW": ("Kuwait", 4, 22),
  "LV": ("Latvia", 4, 13),
  "LB": ("Lebanon", 4, 20),
  "LI": ("Liechtenstein", 5, 12),
  "LT": ("Lithuania", 5, 11),
  "LU": ("Luxembourg", 3, 13),
  "MK": ("Macedonia, Former Yugoslav Republic of", 3, 12),
  "MT": ("Malta", 9, 18),
  "MR": ("Mauritania", 10, 13),
  "MU": ("Mauritius", 8, 18),
  "MC": ("Monaco", 10, 13),
  "ME": ("Montenegro", 3, 15),
  "NL": ("Netherlands", 4, 10),
  "NO": ("Norway", 4, 7),
  "PL": ("Poland", 8, 16),
  "PT": ("Portugal", 8, 13),
  "RO": ("Romania", 4, 16),
  "SM": ("San Marino", 11, 12),
  "SA": ("Saudi Arabia", 2, 18),
  "RS": ("Serbia", 3, 15),
  "SK": ("Slovak Republic", 4, 16),
  "SI": ("Slovenia", 4, 10),
  "ES": ("Spain", 8, 12),
  "SE": ("Sweden", 3, 17),
  "CH": ("Switzerland", 5, 12),
  "TN": ("Tunisia", 5, 15),
  "TR": ("Turkey", 5, 17),
  "GB": ("United Kingdom", 10, 8)
];

