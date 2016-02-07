/**
 * Copyright (c) 2016, Mike Lischke. All rights reserved.
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

// Converts an IBAN to human readable form and back.
@objc(IBANTransformer)
public class IBANTransformer : NSValueTransformer {

  public var countryCode = "de";

  public static override func allowsReverseTransformation() -> Bool {
    return true;
  }

  public override func transformedValue(value: AnyObject?) -> AnyObject? {
    if let data = countryData[countryCode.uppercaseString] {
      let requiredLength = 4 + data.accountLength + data.bankCodeLength;
      if let iban = value as? String where iban.characters.count >= requiredLength {
        return iban.substringWithRange(Range(start: iban.startIndex, end: iban.startIndex.advancedBy(2))) + " " + // Country code.
          iban.substringWithRange(Range(start: iban.startIndex.advancedBy(2), end: iban.startIndex.advancedBy(4))) + " " + // Check sum.
          iban.substringWithRange(Range(start: iban.startIndex.advancedBy(4), end: iban.startIndex.advancedBy(data.accountLength))) + " " + // Account number.
          iban.substringFromIndex(iban.startIndex.advancedBy(data.accountLength + 4)); // The rest.
      }
    }
    return value;
  }

  public override func reverseTransformedValue(value: AnyObject?) -> AnyObject? {
    if let iban = value as? String {
      return iban.stringByReplacingOccurrencesOfString(" ", withString: "");
    }
    return value;
  }

}