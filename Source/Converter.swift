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

  // All other results are returned by country specific code only.
  case IBANToolsBadAccount  // The account was rejected (e.g. wrong checksum).
  case IBANToolsBadBank     // The bank code was rejected (e.g. deleted bank entry).
  case IBANToolsNoMethod    // Couldn't find any conversion/checksum method.
  case IBANToolsNoConv      // No IBAN conversion by intention (always invalid).
  case IBANToolsNoChecksum  // No checksum computation/check by intention for bank accounts (always valid).
  case IBANToolsWrongValue  // One of the given parameters was wrong (0 for account/bank,
                            // no 2 letter country code, invalid chars etc.).
}

internal typealias ConversionResult = (account: String, bankCode: String, iban: String, result: IBANToolsResult);

// Base classes for country specific rules.
// Note: @objc and the NSObject base class are necessary to make dynamic instantiation working.
@objc(IBANRules)
internal class IBANRules : NSObject {
  class func convertToIBAN(account: String, _ bankCode: String) -> ConversionResult {
    return (account, bankCode, "", .IBANToolsNoConv);
  }
}

@objc(AccountCheck)
internal class AccountCheck : NSObject {
  class func isValidAccount(account: String, _ bankCode: String) -> (Bool, IBANToolsResult) {
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
  */
  public class func isValidAccount(account: String, bankCode: String, countryCode: String) -> (Bool, IBANToolsResult) {
    var accountNumber = account.stringByReplacingOccurrencesOfString(" ", withString: "");
    var bankCodeNumber = bankCode.stringByReplacingOccurrencesOfString(" ", withString: "");
    if accountNumber.utf16Count == 0 || bankCodeNumber.utf16Count == 0 || countryCode.utf16Count != 2 {
      return (false, .IBANToolsWrongValue);
    }

    if containsInvalidChars(accountNumber) || containsInvalidChars(bankCodeNumber) {
      return (false, .IBANToolsWrongValue);
    }

    let countryCodeUpper = countryCode.uppercaseString;

    if let details = countryData[countryCodeUpper] {
      let clazz: AnyClass! = NSClassFromString(countryCodeUpper + "AccountCheck");
      if clazz != nil {
        let rulesClass = clazz as AccountCheck.Type;
        return rulesClass.isValidAccount(accountNumber, bankCodeNumber);
      }
    }

    return (true, .IBANToolsOK); // For any country for which we have no checksum check assume everything is ok.
  }

  /**
  * Converts the given account number and bank code to an IBAN number.
  * Can return an empty string if the given values are invalid or if there's no IBAN conversion.
  * for a given account number (e.g. for accounts no longer in use).
  * Notes:
  *   - Values can contain space chars. They are automatically removed.
  */
  public class func convertToIBAN(account: String, bankCode: String, countryCode: String,
    validateAccount: Bool = true) -> (String, IBANToolsResult) {
      if validateAccount {
        let accountResult = isValidAccount(account, bankCode: bankCode, countryCode: countryCode)
        if !accountResult.0 {
          return ("", accountResult.1);
        }
      }

      var accountNumber = account.stringByReplacingOccurrencesOfString(" ", withString: "");
      var bankCodeNumber = bankCode.stringByReplacingOccurrencesOfString(" ", withString: "");
      if accountNumber.utf16Count == 0 || bankCodeNumber.utf16Count == 0 || countryCode.utf16Count != 2 {
        return ("", .IBANToolsWrongValue);
      }

      if containsInvalidChars(accountNumber) || containsInvalidChars(bankCodeNumber) {
        return ("", .IBANToolsWrongValue);
      }

      let countryCodeUpper = countryCode.uppercaseString;

      var result: (String, IBANToolsResult) = ("", .IBANToolsDefaultIBAN);

      // If we have country information call the country converter and then ensure
      // bank code and account number have the desired length.
      if let details = countryData[countryCodeUpper] {
        let clazz: AnyClass! = NSClassFromString(countryCodeUpper + "Rules");
        if clazz != nil {
          let rulesClass = clazz as IBANRules.Type;
          let localResult = rulesClass.convertToIBAN(accountNumber, bankCodeNumber);
          result.0 = localResult.iban;
          result.1 = localResult.result;

          // These 2 values might have been mapped to other values, to be used with the
          // standard conversion rule.
          accountNumber = localResult.account;
          bankCodeNumber = localResult.bankCode;
        }

        // Do length check *after* the country specific rules. They might rely on the exact
        // account number (e.g. for special accounts).
        if accountNumber.utf16Count < details.accountLength {
          accountNumber = String(count: details.accountLength - accountNumber.utf16Count, repeatedValue: "0" as Character) + accountNumber;
        }
        if bankCodeNumber.utf16Count < details.bankCodeLength {
          bankCodeNumber = String(count: details.bankCodeLength - bankCodeNumber.utf16Count, repeatedValue: "0" as Character) + bankCodeNumber;
        }
      }

      if result.1 == .IBANToolsDefaultIBAN {
        var checksum = String(computeChecksum(countryCodeUpper + "00" + bankCodeNumber.uppercaseString + accountNumber.uppercaseString));
        if checksum.utf16Count < 2 {
          checksum = "0" + checksum;
        }

        result.0 = countryCodeUpper + checksum + bankCodeNumber + accountNumber;
      }
      return result;
  }

  private class func mod97(s: String) -> Int {
    var result: Int = 0;
    for c in s {
      let i: Int? = String(c).toInt();
      result = (result * 10 + i!) % 97;
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

