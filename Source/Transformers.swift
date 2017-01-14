/**
 * Copyright (c) 2016, 2017, Mike Lischke. All rights reserved.
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
open class IBANTransformer : ValueTransformer {

  open var countryCode = "de";

  open static override func allowsReverseTransformation() -> Bool {
    return true;
  }

  open override func transformedValue(_ value: Any?) -> Any? {
    if let data = countryData[countryCode.uppercased()] {
      let requiredLength = 4 + data.accountLength + data.bankCodeLength;
      if let iban = value as? String, iban.characters.count >= requiredLength {
        return iban.substring(with: (iban.startIndex ..< iban.characters.index(iban.startIndex, offsetBy: 2))) + " " + // Country code.
          iban.substring(with: (iban.characters.index(iban.startIndex, offsetBy: 2) ..< iban.characters.index(iban.startIndex, offsetBy: 4))) + " " + // Check sum.
          iban.substring(with: (iban.characters.index(iban.startIndex, offsetBy: 4) ..< iban.characters.index(iban.startIndex, offsetBy: data.accountLength))) + " " + // Account number.
          iban.substring(from: iban.characters.index(iban.startIndex, offsetBy: data.accountLength + 4)); // The rest.
      }
    }
    return value;
  }

  open override func reverseTransformedValue(_ value: Any?) -> Any? {
    if let iban = value as? String {
      return iban.replacingOccurrences(of: " ", with: "");
    }
    return value;
  }

}
