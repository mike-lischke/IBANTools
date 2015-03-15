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
    default:
      return "Invalid enum value";
    }
  }
}

/// Institute info for use in Swift. For obj-c we use a dict with keys as written in the comments.
public struct InstituteInfo {
  public let mfiID: String;       // MFIID
  public let bic: String;         // BIC
  public let countryCode: String; // COUNTRY
  public let name: String;        // NAME
  public let box: String;         // BOX
  public let address: String;     // ADDRESS
  public let postal: String;      // POSTAL
  public let city: String;        // CITY
  public let category: String;    // CATEGORY
  public let domicile: String;    // DOMICILE
  public let headName: String;    // HEAD
  public let reserve: Bool;       // RESERVE
  public let exempt: Bool;        // EXEMPT
}

typealias ConversionResult = (iban: String, result: IBANToolsResult);

/// Base classes for country specific rules.
/// Note: @objc and the NSObject base class are necessary to make dynamic instantiation + initialize override working.
internal class IBANRules : NSObject {
  class func loadData(path: String?) {
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
}

internal class AccountCheck : NSObject {
  class func loadData(path: String?) {
  }

  class func isValidAccount(inout account: String, inout _ bankCode: String, _ forIBAN: Bool) ->
    (valid: Bool, result: IBANToolsResult) {
    return (false, .NoMethod);
  }
}

public class IBANtools: NSObject {

  static var institutesInfo: [String: InstituteInfo] = [:];
  static var usedPath: String?;

  override public class func initialize() {
    super.initialize();

    let bundle = NSBundle(forClass: IBANtools.self);
    let resourcePath = bundle.pathForResource("eu_all_mfi", ofType: "txt", inDirectory: "");
    loadData(resourcePath);
  }

  private class func loadData(path: String?) {
    if path == nil || count(path!) < 14 {
      return;
    }

    var filePath = path!;
    if !filePath.hasSuffix("eu_all_mfi.txt") {
      filePath += "eu_all_mfi.txt";
    }

    if NSFileManager.defaultManager().fileExistsAtPath(filePath) {
      var error: NSError?;
      let content = NSString(contentsOfFile: filePath, encoding: NSUTF8StringEncoding, error: &error);
      if error != nil {
        let alert = NSAlert.init(error: error!);
        alert.runModal();
        return;
      }

      if content != nil {
        usedPath = filePath;
        institutesInfo = [:];

        // Extract institute details.
        for line in content!.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()) {
          let s: NSString = line as! NSString;
          let entry = s.componentsSeparatedByString("\t") as! [String];
          if entry.count == 0 {
            continue;
          }
          if entry[0] == "MFI_ID" {
            continue; // Header line.
          }

          let info = InstituteInfo(
            mfiID: entry[0],
            bic: entry[1],
            countryCode: entry[2],
            name: entry[3],
            box: entry[4],
            address: entry[5],
            postal: entry[6],
            city: entry[7],
            category: entry[8],
            domicile: entry[9],
            headName: entry[11],
            reserve: entry[12] == "Yes",
            exempt:entry[13] == "Yes"
          );

          // Many entries in the file have no BIC and a few use the same BIC. In both cases
          // we use the MFI ID instead (which is unique). We may later find a way to get the MFI ID
          // from a BIC.
          var key = count(entry[1]) > 0 ? entry[1] : entry[0];
          if institutesInfo[key] != nil {
            key = entry[0];
          }
          institutesInfo[key] = info; // Info keyed by BIC or (if the bic is empty/duplicate) by MFI ID.
        }
      }
    }
  }

  public class func useResourcePath(path: String) {
    if usedPath != nil && usedPath! != path {
      loadData(path);

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
    }
  }

  /// Obj-c wrapper for same named Swift-only function.
  public class func instituteDetailsForBIC(bic: NSString) -> Dictionary<NSString, AnyObject> {
    var result: [NSString: AnyObject] = [:];
    if let info = instituteDetailsForBIC(bic as String) {
      result["MFIID"] = info.mfiID;
      result["BIC"] = info.bic;
      result["COUNTRY"] = info.countryCode;
      result["NAME"] = info.name;
      result["BOX"] = info.box;
      result["ADDRESS"] = info.address;
      result["POSTAL"] = info.postal;
      result["CITY"] = info.city;
      result["CATEGORY"] = info.category;
      result["DOMICILE"] = info.domicile;
      result["HEAD"] = info.headName;
      result["RESERVE"] = NSNumber(bool: info.reserve);
      result["EXEMPT"] = info.exempt;
    }
    return result;
  }

  /// Returns address, name and other info about an institute in Europe.
  /// Some of the financial institues in our list have no bic and the MFI ID is used as key.
  // So it can happen we cannot return
  public class func instituteDetailsForBIC(var bic: String) -> InstituteInfo? {
    var result = institutesInfo[bic];
    if result == nil && !(bic as NSString).hasSuffix("XXX") {
      // If we cannot find anything for the given bic and it is not already in the generic form
      // (XXX at the end for no specific subsidary) try another lookup using the generic form.
      bic = (bic as NSString).substringToIndex(count(bic) - 3) + "XXX";
      result = institutesInfo[bic];
    }
    return result;
  }

  /// Validates the given IBAN. Returns true if the number is valid, otherwise false.
  public class func isValidIBAN(iban: String) -> Bool {
    return computeChecksum(iban) == 97;
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
    var result: Dictionary<String, AnyObject> = [
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
    if count(account) == 0 || count(bankCode) == 0 || count(countryCode) != 2 {
      return (false, .WrongValue);
    }

    if containsInvalidChars(account) || containsInvalidChars(bankCode) {
      return (false, .WrongValue);
    }

    countryCode = countryCode.uppercaseString;

    if let details = countryData[countryCode] {
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
    var result: Dictionary<String, AnyObject> = [
      "bic": results.bic,
      "result": NSNumber(integer: results.result.rawValue),
    ];

    return result;
  }

  /// Returns the BIC for a given bank code. Since there is no generic procedure to determine the BIC
  /// this lookup only works for those countries with a specific implementation (DE atm).
  public class func bicForBankCode(var bankCode: String, var countryCode: String) -> (bic: String, result: IBANToolsResult) {
    bankCode = bankCode.stringByReplacingOccurrencesOfString(" ", withString: "");
    if count(bankCode) == 0 || count(countryCode) != 2 {
      return ("", .WrongValue);
    }

    if containsInvalidChars(bankCode) {
      return ("", .WrongValue);
    }

    countryCode = countryCode.uppercaseString;

    if let details = countryData[countryCode] {
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
  public class func bicForIBAN(iban: String) -> Dictionary<String, AnyObject> {
    let results: (bic: String, result: IBANToolsResult) = bicForIBAN(iban);
    var result: Dictionary<String, AnyObject> = [
      "bic": results.bic,
      "result": NSNumber(integer: results.result.rawValue),
    ];

    return result;
  }
  
  /// Returns the BIC for a given IBAN.
  public class func bicForIBAN(iban: String) -> (bic: String, result: IBANToolsResult) {
    let countryCode = (iban as NSString).substringWithRange(NSMakeRange(0, 2));
    if let details = countryData[countryCode.uppercaseString] {
      let bankCode = (iban as NSString).substringWithRange(NSMakeRange(4, details.bankCodeLength));
      return bicForBankCode(bankCode, countryCode: countryCode);
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

    var result: Dictionary<String, AnyObject> = [
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
      if count(account) == 0 || count(bankCode) == 0 || count(countryCode) != 2 {
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
        if count(account) < details.accountLength {
          account = String(count: details.accountLength - count(account), repeatedValue: "0" as Character) + account;
        }
        if count(bankCode) < details.bankCodeLength {
          bankCode = String(count: details.bankCodeLength - count(bankCode), repeatedValue: "0" as Character) + bankCode;
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
        if count(checksum) < 2 {
          checksum = "0" + checksum;
        }

        result.0 = countryCode + checksum + bankCode + account;
      }
      return result;
  }

  private class func mod97(s: String) -> Int {
    var result = 0;
    for c in s {
      let i = String(c).toInt()!;
      result = (result * 10 + i) % 97;
    }
    return result;
  }

  private class func computeChecksum(iban: NSString) -> Int {
    var work: String = "";
    let countryCode = iban.substringToIndex(2);
    var checksum = iban.substringWithRange(NSMakeRange(2, 2));
    let bban = iban.substringFromIndex(4); // Basic bank account number.
    for char in (bban + countryCode) {
      let s = String(char);
      if (char >= "0") && (char <= "9") {
        work += s;
      } else {
        var scalars = s.unicodeScalars;
        var v = scalars[scalars.startIndex].value;
        work += String(v - 55);
      }
    }
    work += checksum;
    return 98 - mod97(work);
  }

  /// Checks if the input string only consists of letters and numbers.
  /// Everything else is considered wrong.
  private class func containsInvalidChars(input: String) -> Bool {
    for c in input {
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

