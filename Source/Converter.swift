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

let A: unichar = 65; // "A"
let Z: unichar = 90; // "Z"

public enum IBANToolsResult {
  case IBANToolsDefaultIBAN // The default rule for generating an IBAN was used.
  case IBANToolsOK          // Conversion/check was ok.
  case IBANToolsNoBic       // No known BIC.

  // All other results are returned by country specific code only.
  case IBANToolsBadAccount  // The account was rejected (e.g. wrong checksum).
  case IBANToolsBadBank     // The bank code was rejected (e.g. deleted bank entry).
  case IBANToolsNoMethod    // Couldn't find any conversion/checksum method.
  case IBANToolsNoConv      // No IBAN conversion by intention (always invalid).
  case IBANToolsNoChecksum  // No checksum computation/check by intention for bank accounts (always valid).
  case IBANToolsWrongValue  // One of the given parameters was wrong (0 for account/bank,
                            // no 2 letter country code, invalid chars etc.).

  public func description() -> String {
    switch self {
    case IBANToolsDefaultIBAN:
      return "IBANToolsDefaultIBAN";
    case IBANToolsOK:
      return "IBANToolsOK";
    case IBANToolsNoBic:
      return "IBANToolsNoBic";
    case IBANToolsBadAccount:
      return "IBANToolsBadAccount";
    case IBANToolsBadBank:
      return "IBANToolsBadBank";
    case IBANToolsNoMethod:
      return "IBANToolsNoMethod";
    case IBANToolsNoConv:
      return "IBANToolsNoConv";
    case IBANToolsNoChecksum:
      return "IBANToolsNoChecksum";
    case IBANToolsWrongValue:
      return "IBANToolsWrongValue";
    default:
      return "Invalid enum value";
    }
  }
}

internal typealias ConversionResult = (iban: String, result: IBANToolsResult);

// Base classes for country specific rules.
// Note: @objc and the NSObject base class are necessary to make dynamic instantiation working.
@objc(IBANRules)
internal class IBANRules : NSObject {
  class func validWithoutChecksum(account: String, _ bankCode: String) -> Bool {
    return false;
  }

  class func convertToIBAN(inout account: String, inout _ bankCode: String) -> ConversionResult {
    return ("", .IBANToolsNoConv);
  }

  class func bicForBankCode(bankCode: String) -> (bic: String, result: IBANToolsResult) {
    return ("", .IBANToolsNoBic);
  }
}

@objc(AccountCheck)
internal class AccountCheck : NSObject {
  class func isValidAccount(inout account: String, inout _ bankCode: String, _ forIBAN: Bool) ->
    (valid: Bool, result: IBANToolsResult) {
    return (false, .IBANToolsNoMethod);
  }
}

@objc(IBANtools)
public class IBANtools {

  /**
   * Validates the given IBAN. Returns true if the number is valid, otherwise false.
   */
  public class func isValidIBAN(iban: String) -> Bool {
    return computeChecksum(iban) == 97;
  }

  /**
   * Validates the given bank account number. Returns true if the number is valid, otherwise false.
   * This check involves institute's specific checksum rules.
   * Also returns the real account number if the given one is special (e.g. for donations).
   */
  public class func isValidAccount(inout account: String, inout bankCode: String, var countryCode: String, forIBAN: Bool = false) ->
    (valid: Bool, result: IBANToolsResult) {

    account = account.stringByReplacingOccurrencesOfString(" ", withString: "");
    bankCode = bankCode.stringByReplacingOccurrencesOfString(" ", withString: "");
    if account.utf16Count == 0 || bankCode.utf16Count == 0 || countryCode.utf16Count != 2 {
      return (false, .IBANToolsWrongValue);
    }

    if containsInvalidChars(account) || containsInvalidChars(bankCode) {
      return (false, .IBANToolsWrongValue);
    }

    countryCode = countryCode.uppercaseString;

    if let details = countryData[countryCode] {
      let clazz: AnyClass! = NSClassFromString(countryCode + "AccountCheck");
      if clazz != nil {
        let rulesClass = clazz as AccountCheck.Type;
        return rulesClass.isValidAccount(&account, &bankCode, forIBAN);
      }
    }

    return (true, .IBANToolsOK); // For any country for which we have no checksum check assume everything is ok.
  }

  /**
   * Returns the BIC for a given bank code. Since there is no generic procedure to determine the BIC
   * this lookup only works for those countries with a specific implementation (DE atm).
   */
  public class func bicForBankCode(var bankCode: String, var countryCode: String) -> (bic: String, result: IBANToolsResult) {
    bankCode = bankCode.stringByReplacingOccurrencesOfString(" ", withString: "");
    if bankCode.utf16Count == 0 || countryCode.utf16Count != 2 {
      return ("", .IBANToolsWrongValue);
    }

    if containsInvalidChars(bankCode) {
      return ("", .IBANToolsWrongValue);
    }

    countryCode = countryCode.uppercaseString;

    if let details = countryData[countryCode] {
      let clazz: AnyClass! = NSClassFromString(countryCode + "Rules");
      if clazz != nil {
        let rulesClass = clazz as IBANRules.Type;
        return rulesClass.bicForBankCode(bankCode);
      }
    }

    return ("", .IBANToolsNoBic);
  }
  
  /**
   * Returns the BIC for a given IBAN.
   */
  public class func bicForIBAN(iban: String) -> (bic: String, result: IBANToolsResult) {
    let countryCode = (iban as NSString).substringWithRange(NSMakeRange(0, 2));
    if let details = countryData[countryCode.uppercaseString] {
      let bankCode = (iban as NSString).substringWithRange(NSMakeRange(4, details.bankCodeLength));
      return bicForBankCode(bankCode, countryCode: countryCode);
    }
    return ("", .IBANToolsNoBic);
  }

  /**
  * Converts the given account number and bank code to an IBAN number.
  * Can return an empty string if the given values are invalid or if there's no IBAN conversion.
  * for a given account number (e.g. for accounts no longer in use).
  * Notes:
  *   - Values can contain space chars. They are automatically removed.
  *   - Switching off account validation is not recommended as often accounts and/or bank codes must be
  *     replaced by others which happens during account validation. Essentially keep this on except for
  *     unit testing with random account numbers instead of real ones.
  */
  public class func convertToIBAN(inout account: String, inout bankCode: String, var countryCode: String,
    validateAccount: Bool = true) -> (iban: String, result: IBANToolsResult) {

      account = account.stringByReplacingOccurrencesOfString(" ", withString: "");
      bankCode = bankCode.stringByReplacingOccurrencesOfString(" ", withString: "");
      if account.utf16Count == 0 || bankCode.utf16Count == 0 || countryCode.utf16Count != 2 {
        return ("", .IBANToolsWrongValue);
      }

      if containsInvalidChars(account) || containsInvalidChars(bankCode) {
        return ("", .IBANToolsWrongValue);
      }

      countryCode = countryCode.uppercaseString;

      var result: (String, IBANToolsResult) = ("", .IBANToolsDefaultIBAN);

      // If we have country information call the country converter and then ensure
      // bank code and account number have the desired length.
      if let details = countryData[countryCode] {
        let clazz: AnyClass! = NSClassFromString(countryCode + "Rules");

        // Some accounts can be used for IBANs even though they do not validate.
        var ignoreChecksum = false;
        if clazz != nil {
          ignoreChecksum = (clazz as IBANRules.Type).validWithoutChecksum(account, bankCode);
        }
        if validateAccount && !ignoreChecksum {
          let accountResult = isValidAccount(&account, bankCode: &bankCode, countryCode: countryCode, forIBAN: true)
          if !accountResult.valid {
            return ("", accountResult.result);
          }
        }
        if clazz != nil {
          let rulesClass = clazz as IBANRules.Type;
          result = rulesClass.convertToIBAN(&account, &bankCode);
        }

        // Do length check *after* the country specific rules. They might rely on the exact
        // account number (e.g. for special accounts).
        if account.utf16Count < details.accountLength {
          account = String(count: details.accountLength - account.utf16Count, repeatedValue: "0" as Character) + account;
        }
        if bankCode.utf16Count < details.bankCodeLength {
          bankCode = String(count: details.bankCodeLength - bankCode.utf16Count, repeatedValue: "0" as Character) + bankCode;
        }
      } else {
        if validateAccount {
          let accountResult = isValidAccount(&account, bankCode: &bankCode, countryCode: countryCode, forIBAN: true)
          if !accountResult.valid {
            return ("", accountResult.result);
          }
        }
      }

      if result.1 == .IBANToolsDefaultIBAN {
        var checksum = String(computeChecksum(countryCode + "00" + bankCode.uppercaseString + account.uppercaseString));
        if checksum.utf16Count < 2 {
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

  /**
  * Checks if the input string only consists of letters and numbers.
  * Everything else is considered wrong.
  */
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

