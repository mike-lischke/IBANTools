//
//  Converter.swift
//  iban-tools
//
//  Created by Mike Lischke on 06.12.14.
//  Copyright (c) 2014 mike.lischke. All rights reserved.

import Foundation

let A: unichar = 65; // "A"
let Z: unichar = 90; // "Z"

// Country specific rules.
// Note: @objc and the NSObject base class are necessary to make dynamic instantiation working.
@objc(IBANRules)
class IBANRules : NSObject {
    class func convertToIBAN(inout account: String, inout _ bankCode: String) -> String? {
        return nil;
    }
}

@objc(IBANtools)
public class IBANtools {

    /**
     * Validates the given IBAN. Returns true if the number is valid, otherwise false.
     */
    public class func checkIBAN(iban: String) -> Bool {
        return computeChecksum(iban) == 97;
    }

    /**
    * Converts the given account number and bank code to an IBAN number.
    * Can return an empty string if the given values are invalid or if there's no IBAN conversion.
    * for a given account number (e.g. for accounts no longer in use).
    * Notes:
    *   - Values can contain space chars. They are automatically removed.
    */
    public class func convertToIBAN(account: String, bankCode: String, countryCode: String) -> String {

        var accountNumber = account.stringByReplacingOccurrencesOfString(" ", withString: "");
        var bankCodeNumber = bankCode.stringByReplacingOccurrencesOfString(" ", withString: "");
        if accountNumber.utf16Count == 0 || bankCodeNumber.utf16Count == 0 || countryCode.utf16Count != 2 {
            return "";
        }

        let countryCodeUpper = countryCode.uppercaseString;

        var result: String?;

        // If we have country information call the country converter and then ensure
        // bank code and account number have the desired length.
        let details: CountryDetails? = countryData[countryCodeUpper];
        if details != nil {
            let clazz: AnyClass! = NSClassFromString(countryCodeUpper + "Rules");
            if clazz != nil {
                let rulesClass = clazz as IBANRules.Type;
                result = rulesClass.convertToIBAN(&accountNumber, &bankCodeNumber);
            }

            // Do length check *after* the country specific rules. They might rely on the exact
            // account number (e.g. for special accounts).
            if accountNumber.utf16Count < details!.accountLength {
                accountNumber = String(count: details!.accountLength - accountNumber.utf16Count, repeatedValue: "0" as Character) + accountNumber;
            }
            if bankCodeNumber.utf16Count < details!.bankCodeLength {
                bankCodeNumber = String(count: details!.bankCodeLength - bankCodeNumber.utf16Count, repeatedValue: "0" as Character) + bankCodeNumber;
            }
        }

        if (result == nil) {
            var checksum = String(computeChecksum(countryCodeUpper + "00" + bankCodeNumber.uppercaseString + accountNumber.uppercaseString));
            if checksum.utf16Count < 2 {
                checksum = "0" + checksum;
            }

            return countryCodeUpper + checksum + bankCodeNumber + accountNumber;
        }
        return result!;
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
}

public struct CountryDetails {
    public var country: String;
    public var bankCodeLength: Int;
    public var accountLength: Int;
    init (_ name: String, _ bankCode: Int, _ account: Int) {
        country = name;
        bankCodeLength = bankCode;
        accountLength = account;
    }
}

// Public only for test cases.
public let countryData: [String: CountryDetails] = [
    "AL": CountryDetails("Albania", 8, 16),
    "AD": CountryDetails("Andorra", 8, 12),
    "AT": CountryDetails("Austria", 5, 1),
    "BE": CountryDetails("Belgium", 3, 9),
    "BA": CountryDetails("Bosnia and Herzegovina", 6, 10),
    "BG": CountryDetails("Bulgaria", 8, 10),
    "HR": CountryDetails("Croatia", 7, 10),
    "CY": CountryDetails("Cyprus", 8, 16),
    "CZ": CountryDetails("Czech Republic", 4, 16),
    "DK": CountryDetails("Denmark", 4, 10),
    "EE": CountryDetails("Estonia", 2, 14),
    "FO": CountryDetails("Faroe Islands", 4, 10),
    "FI": CountryDetails("Finland", 6, 8),
    "FR": CountryDetails("France", 10, 13),
    "GE": CountryDetails("Georgia", 2, 16),
    "DE": CountryDetails("Germany", 8, 10),
    "GI": CountryDetails("Gibraltar", 4, 15),
    "GR": CountryDetails("Greece", 7, 16),
    "GL": CountryDetails("Greenland", 4, 10),
    "HU": CountryDetails("Hungary", 7, 17),
    "IS": CountryDetails("Iceland", 4, 18),
    "IE": CountryDetails("Ireland", 10, 8),
    "IL": CountryDetails("Israel", 6, 13),
    "IT": CountryDetails("Italy", 11, 12),
    "KZ": CountryDetails("Kazakhstan", 3, 13),
    "KW": CountryDetails("Kuwait", 4, 22),
    "LV": CountryDetails("Latvia", 4, 13),
    "LB": CountryDetails("Lebanon", 4, 20),
    "LI": CountryDetails("Liechtenstein", 5, 12),
    "LT": CountryDetails("Lithuania", 5, 11),
    "LU": CountryDetails("Luxembourg", 3, 13),
    "MK": CountryDetails("Macedonia, Former Yugoslav Republic of", 3, 12),
    "MT": CountryDetails("Malta", 9, 18),
    "MR": CountryDetails("Mauritania", 10, 13),
    "MU": CountryDetails("Mauritius", 8, 18),
    "MC": CountryDetails("Monaco", 10, 13),
    "ME": CountryDetails("Montenegro", 3, 15),
    "NL": CountryDetails("Netherlands", 4, 10),
    "NO": CountryDetails("Norway", 4, 7),
    "PL": CountryDetails("Poland", 8, 16),
    "PT": CountryDetails("Portugal", 8, 13),
    "RO": CountryDetails("Romania", 4, 16),
    "SM": CountryDetails("San Marino", 11, 12),
    "SA": CountryDetails("Saudi Arabia", 2, 18),
    "RS": CountryDetails("Serbia", 3, 15),
    "SK": CountryDetails("Slovak Republic", 4, 16),
    "SI": CountryDetails("Slovenia", 4, 10),
    "ES": CountryDetails("Spain", 8, 12),
    "SE": CountryDetails("Sweden", 3, 17),
    "CH": CountryDetails("Switzerland", 5, 12),
    "TN": CountryDetails("Tunisia", 5, 15),
    "TR": CountryDetails("Turkey", 5, 17),
    "GB": CountryDetails("United Kingdom", 10, 8)
];

