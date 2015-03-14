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

@objc(DEAccountCheck)
internal class DEAccountCheck : AccountCheck {

  /// Enumeration to describe the handling of the 3 computation result values (0, 1, anything else).
  private enum ResultMapping: Int16 {
    case DontMap = -1           // Means: don't do any special handling with that value. Not used for the default case.
    case MapToZero = 0
    case MapToOne = 1
    case MapToSpecial = 99
    case ReturnSum
    case ReturnRemainder
    case ReturnDifference      // modulus - remainder
    case ReturnDiff2HalfDecade // Difference of the sum to the next half decade (e.g. 25, 30, 35, 40 etc.)
    case ReturnDivByModulus    // sum / modulus
  }

  /// Details for each used method.
  /// In some cases the range is not continuous, which require a special slice construction then.
  typealias MethodParameters = (
    modulus: UInt16,
    weights: [UInt16],
    indices: (start: Int, stop: Int, check: Int)
  );

  // TODO: this data should also be in a file (so we can update it without recompilation).
  static private var methodParameters: [String: MethodParameters] = [
    "00": (10, [2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2], (0, 8, 9)),
    "01": (10, [3, 7, 1, 3, 7, 1, 3, 7, 1], (0, 8, 9)),
    "02": (11, [2, 3, 4, 5, 6, 7, 8, 9, 2], (0, 8, 9)),
    "03": (10, [2, 1, 2, 1, 2, 1, 2, 1, 2], (0, 8, 9)),
    "04": (11, [2, 3, 4, 5, 6, 7, 2, 3, 4], (0, 8, 9)),
    "05": (10, [7, 3, 1, 7, 3, 1, 7, 3, 1], (0, 8, 9)),
    "06": (11, [2, 3, 4, 5, 6, 7, 2, 3, 4], (0, 8, 9)),
    "07": (11, [2, 3, 4, 5, 6, 7, 8, 9, 10], (0, 8, 9)),
    "08": (10, [2, 1, 2, 1, 2, 1, 2, 1, 2], (0, 8, 9)),
    "10": (11, [2, 3, 4, 5, 6, 7, 8, 9, 10], (0, 8, 9)),
    "11": (11, [2, 3, 4, 5, 6, 7, 8, 9, 10], (0, 8, 9)),
    "13": (10, [2, 1, 2, 1, 2, 1], (1, 6, 7)),
    "13b": (10, [2, 1, 2, 1, 2, 1], (3, 8, 9)),
    "14": (11, [2, 3, 4, 5, 6, 7], (0, 8, 9)),
    "15": (11, [2, 3, 4, 5], (0, 8, 9)),
    "16": (11, [2, 3, 4, 5, 6, 7, 2, 3, 4], (0, 8, 9)),
    "17": (11, [1, 2, 1, 2, 1, 2], (1, 6, 9)),
    "18": (10, [3, 9, 7, 1, 3, 9, 7, 1, 3], (0, 8, 9)),
    "19": (11, [2, 3, 4, 5, 6, 7, 8, 9, 1], (0, 8, 9)),
    "20": (11, [2, 3, 4, 5, 6, 7, 8, 9, 3], (0, 8, 9)),
    "21": (10, [2, 1, 2, 1, 2, 1, 2, 1, 2], (0, 8, 9)),
    "22": (10, [3, 1, 3, 1, 3, 1, 3, 1, 3], (0, 8, 9)),
    "23": (11, [2, 3, 4, 5, 6, 7], (0, 5, 6)),
    "24": (11, [1, 2, 3, 1, 2, 3, 1, 2, 3], (0, 8, 9)),
    "25": (11, [2, 3, 4, 5, 6, 7, 8, 9], (0, 8, 9)),
    "26": (11, [2, 3, 4, 5, 6, 7, 2], (0, 6, 7)),
    "26b": (11, [2, 3, 4, 5, 6, 7, 2], (2, 8, 9)),
    "27": (10, [2, 1, 2, 1, 2, 1, 2, 1, 2], (0, 8, 9)),
    "28": (11, [2, 3, 4, 5, 6, 7, 8], (0, 6, 7)),
    "29": (10, [], (0, 8, 9)),
    "30": (10, [2, 0, 0, 0, 0, 1, 2, 1, 2], (0, 8, 9)),
    "31": (11, [9, 8, 7, 6, 5, 4, 3, 2, 1], (0, 8, 9)),
    "32": (11, [2, 3, 4, 5, 6, 7], (3, 8, 9)),
    "33": (11, [2, 3, 4, 5, 6], (4, 8, 9)),
    "34": (11, [2, 4, 8, 5, 10, 9, 7], (0, 6, 7)),
    "35": (11, [2, 3, 4, 5, 6, 7, 8, 9, 10], (0, 8, 9)),
    "36": (11, [2, 4, 8, 5], (5, 8, 9)),
    "37": (11, [2, 4, 8, 5, 10], (4, 8, 9)),
    "38": (11, [2, 4, 8, 5, 10, 9], (3, 8, 9)),
    "39": (11, [2, 4, 8, 5, 10, 9, 7], (2, 8, 9)),
    "40": (11, [2, 4, 8, 5, 10, 9, 7, 3, 6], (0, 8, 9)),
    "41": (10, [2, 1, 2, 1, 2, 1, 2, 1, 2], (0, 8, 9)),
    "42": (11, [2, 3, 4, 5, 6, 7, 8, 9], (1, 8, 9)),
    "43": (10, [1, 2, 3, 4, 5, 6, 7, 8, 9], (0, 8, 9)),
    "44": (11, [2, 4, 8, 5, 10, 0, 0, 0, 0], (4, 8, 9)),
    "45": (10, [2, 1, 2, 1, 2, 1, 2, 1, 2], (0, 8, 9)),
    "46": (11, [2, 3, 4, 5, 6], (2, 6, 7)),
    "47": (11, [2, 3, 4, 5, 6], (3, 7, 8)),
    "48": (11, [2, 3, 4, 5, 6, 7], (2, 7, 8)),
    "49": (0, [], (0, 8, 9)),
    "50": (11, [2, 3, 4, 5, 6, 7], (0, 5, 6)),
    "50b": (11, [2, 3, 4, 5, 6, 7], (3, 8, 9)),
    "51": (0, [], (0, 8, 9)),
    "51a": (11, [2, 3, 4, 5, 6, 7], (3, 8, 9)),
    "51b": (11, [2, 3, 4, 5, 6], (4, 8, 9)),
    "51c": (10, [2, 1, 2, 1, 2, 1], (3, 8, 9)),
    "51d": (7, [2, 3, 4, 5, 6], (4, 8, 9)),
    "51e": (11, [2, 3, 4, 5, 6, 7, 8], (2, 8, 9)),
    "51f": (11, [2, 3, 4, 5, 6, 7, 8, 9, 10], (0, 8, 9)),
    "52": (11, [2, 4, 8, 5, 10, 9, 7, 3, 6, 1, 2, 4], (0, 8, 9)),
    "53": (11, [2, 4, 8, 5, 10, 9, 7, 3, 6, 1, 2, 4], (0, 8, 9)),
    "54": (11, [2, 3, 4, 5, 6, 7, 2], (0, 8, 9)),
    "55": (11, [2, 3, 4, 5, 6, 7, 8, 7, 8], (0, 8, 9)),
    "56": (11, [2, 3, 4, 5, 6, 7, 2, 3, 4], (0, 8, 9)),
    "57": (10, [1, 2, 1, 2, 1, 2, 1, 2, 1], (0, 8, 9)),
    "58": (11, [2, 3, 4, 5, 6, 0, 0, 0, 0], (4, 8, 9)),
    "59": (10, [2, 1, 2, 1, 2, 1, 2, 1, 2], (0, 8, 9)),
    "60": (10, [2, 1, 2, 1, 2, 1, 2], (2, 8, 9)),
    "61": (10, [2, 1, 2, 1, 2, 1, 2, 1, 2], (0, 6, 7)),
    "62": (10, [2, 1, 2, 1, 2], (2, 6, 7)),
    "63": (10, [2, 1, 2, 1, 2, 1], (1, 6, 7)),
    "63b": (10, [2, 1, 2, 1, 2, 1], (3, 8, 9)),
    "64": (11, [9, 10, 5, 8, 4, 2], (0, 5, 6)),
    "65": (10, [2, 1, 2, 1, 2, 1, 2, 1, 2], (0, 6, 7)),
    "66": (11, [2, 3, 4, 5, 6, 0, 0, 7], (1, 8, 9)),
    "67": (10, [2, 1, 2, 1, 2, 1, 2], (0, 6, 7)),
    "68": (10, [2, 1, 2, 1, 2, 1, 2, 1, 2], (3, 8, 9)),
    "69": (11, [2, 3, 4, 5, 6, 7, 8], (0, 6, 7)),
    "69b": (11, [], (0, 8, 9)),
    "70": (11, [2, 3, 4, 5, 6, 7], (0, 8, 9)),
    "71": (11, [6, 5, 4, 3, 2, 1], (1, 6, 9)),
    "72": (10, [2, 1, 2, 1, 2, 1], (3, 8, 9)),
    "73": (0, [], (0, 8, 9)),
    "73a": (10, [2, 1, 2, 1, 2, 1], (3, 8, 9)),
    "73b": (10, [2, 1, 2, 1, 2], (4, 8, 9)),
    "73c": (7, [2, 1, 2, 1, 2], (4, 8, 9)),
    "74": (10, [2, 1, 2, 1, 2, 1, 2, 1, 2], (0, 8, 9)),
    "75": (10, [2, 1, 2, 1, 2], (4, 8, 9)),
    "76": (11, [2, 3, 4, 5, 6, 7, 8], (1, 6, 7)),
    "76b": (11, [2, 3, 4, 5, 6, 7, 8], (3, 8, 9)),
    "77": (11, [1, 2, 3, 4, 5], (5, 9, 9)), // No checksum.
    "77b": (11, [5, 4, 3, 4, 5], (5, 9, 9)), // No checksum.
    "78": (10, [2, 1, 2, 1, 2, 1, 2, 1, 2], (0, 8, 9)),
    "79": (10, [2, 1, 2, 1, 2, 1, 2, 1, 2], (0, 8, 9)),
    "79b": (10, [2, 1, 2, 1, 2, 1, 2, 1, 2], (0, 7, 8)),
    "80": (10, [2, 1, 2, 1, 2], (4, 8, 9)),
    "80b": (7, [2, 1, 2, 1, 2], (4, 8, 9)),
    "81": (11, [2, 3, 4, 5, 6, 7], (0, 8, 9)),
    "82": (11, [2, 3, 4, 5, 6], (4, 8, 9)),
    "83": (0, [], (0, 8, 9)),
    "83a": (11, [2, 3, 4, 5, 6, 7], (0, 8, 9)),
    "83b": (11, [2, 3, 4, 5, 6], (0, 8, 9)),
    "83c": (7, [2, 3, 4, 5, 6], (0, 8, 9)),
    "83d": (11, [2, 3, 4, 5, 6, 7, 8], (0, 8, 9)),
    "84": (0, [], (0, 8, 9)),
    "84a": (11, [2, 3, 4, 5, 6], (0, 8, 9)),
    "84b": (7, [2, 3, 4, 5, 6], (0, 8, 9)),
    "84c": (10, [2, 1, 2, 1, 2], (0, 8, 9)),
    "85": (0, [], (0, 8, 9)),
    "85a": (11, [2, 3, 4, 5, 6, 7], (0, 8, 9)),
    "85b": (11, [2, 3, 4, 5, 6], (0, 8, 9)),
    "85c": (7, [2, 3, 4, 5, 6], (0, 8, 9)),
    "85d": (11, [2, 3, 4, 5, 6, 7, 8], (0, 8, 9)),
    "86": (0, [], (0, 8, 9)),
    "86a": (10, [2, 1, 2, 1, 2, 1], (0, 8, 9)),
    "86b": (11, [2, 3, 4, 5, 6, 7], (0, 8, 9)),
    "87": (0, [], (0, 8, 9)),
    "87b": (11, [2, 3, 4, 5, 6], (4, 8, 9)),
    "87c": (7, [2, 3, 4, 5, 6], (4, 8, 9)),
    "88": (11, [2, 3, 4, 5, 6, 7], (0, 8, 9)),
    "88b": (11, [2, 3, 4, 5, 6, 7, 8], (0, 8, 9)),
    "89": (11, [2, 3, 4, 5, 6, 7], (0, 8, 9)),
    "90": (0, [], (0, 8, 9)),
    "90a": (11, [2, 3, 4, 5, 6, 7], (0, 8, 9)),
    "90b": (11, [2, 3, 4, 5, 6], (0, 8, 9)),
    "90c": (7, [2, 3, 4, 5, 6], (0, 8, 9)),
    "90d": (9, [2, 3, 4, 5, 6], (0, 8, 9)),
    "90e": (10, [2, 1, 2, 1, 2], (0, 8, 9)),
    "90f": (11, [2, 3, 4, 5, 6, 7, 8], (0, 8, 9)),
    "90g": (7, [2, 1, 2, 1, 2, 1], (0, 8, 9)),
    "91": (0, [], (0, 8, 9)),
    "91a": (11, [2, 3, 4, 5, 6, 7], (0, 5, 6)),
    "91b": (11, [7, 6, 5, 4, 3, 2], (0, 5, 6)),
    "91c": (11, [2, 3, 4, 0, 5, 6, 7, 8, 9, 10], (0, 9, 6)),
    "91d": (11, [2, 4, 8, 5, 10, 9], (0, 5, 6)),
    "92": (10, [3, 7, 1, 3, 7, 1], (0, 8, 9)),
    "93": (0, [], (0, 8, 9)),
    "93a": (11, [2, 3, 4, 5, 6], (0, 4, 5)),
    "93b": (11, [2, 3, 4, 5, 6], (4, 8, 9)),
    "93c": (7, [2, 3, 4, 5, 6], (0, 4, 5)),
    "93d": (7, [2, 3, 4, 5, 6], (4, 8, 9)),
    "94": (10, [1, 2, 1, 2, 1, 2, 1, 2, 1], (0, 8, 9)),
    "95": (11, [2, 3, 4, 5, 6, 7, 2, 3, 4], (0, 8, 9)),
    "96": (11, [2, 3, 4, 5, 6, 7, 8, 9, 1], (0, 8, 9)),
    "96b": (10, [2, 1, 2, 1, 2, 1, 2, 1, 2], (0, 8, 9)),
    "97": (11, [], (0, 8, 9)),
    "98": (10, [3, 1, 7, 3, 1, 7, 3], (0, 8, 9)),
    "99": (11, [2, 3, 4, 5, 6, 7, 2, 3, 4], (0, 8, 9)),
    "A0": (11, [2, 4, 8, 5, 10, 0, 0, 0, 0], (0, 8, 9)),
    "A1": (10, [2, 1, 2, 1, 2, 1, 2, 0, 0], (0, 8, 9)),
    "A2": (10, [2, 1, 2, 1, 2, 1, 2, 1, 2], (0, 8, 9)),
    "A2b": (11, [2, 3, 4, 5, 6, 7, 2, 3, 4], (0, 8, 9)),
    "A3": (10, [2, 1, 2, 1, 2, 1, 2, 1, 2], (0, 8, 9)),
    "A3b": (11, [2, 3, 4, 5, 6, 7, 8, 9, 10], (0, 8, 9)),
    "A4": (0, [], (0, 8, 9)),
    "A4a": (11, [2, 3, 4, 5, 6, 7, 0, 0, 0], (0, 8, 9)),
    "A4b": (7, [2, 3, 4, 5, 6, 7, 0, 0, 0], (0, 8, 9)),
    "A4c": (11, [2, 3, 4, 5, 6, 0, 0, 0, 0], (0, 8, 9)),
    "A5": (10, [2, 1, 2, 1, 2, 1, 2, 1, 2], (0, 8, 9)),
    "A5b": (11, [2, 3, 4, 5, 6, 7, 8, 9, 10], (0, 8, 9)),
    "A6": (0, [], (0, 8, 9)),
    "A7": (10, [2, 1, 2, 1, 2, 1, 2, 1, 2], (0, 8, 9)),
    "A8": (11, [2, 3, 4, 5, 6, 7], (0, 8, 9)),
    "A8b": (10, [2, 1, 2, 1, 2, 1], (0, 8, 9)),
    "A9": (10, [3, 7, 1, 3, 7, 1, 3, 7, 1], (0, 8, 9)),
    "A9b": (11, [2, 3, 4, 5, 6, 7, 2, 3, 4], (0, 8, 9)),
    "B0": (11, [2, 3, 4, 5, 6, 7, 2, 3, 4], (0, 8, 9)),
    "B1": (10, [7, 3, 1, 7, 3, 1, 7, 3, 1], (0, 8, 9)),
    "B1b": (10, [3, 7, 1, 3, 7, 1, 3, 7, 1], (0, 8, 9)),
    "B2": (0, [], (0, 8, 9)),
    "B3": (0, [], (0, 8, 9)),
    "B4": (0, [], (0, 8, 9)),
    "B5": (10, [7, 3, 1 ,7 , 3, 1, 7, 3, 1], (0, 8, 9)),
    "B5b": (10, [2, 1, 2, 1, 2, 1, 2, 1, 2], (0, 8, 9)),
    "B6": (11, [2, 3, 4, 5, 6, 7, 8, 9, 3], (0, 8, 9)),
    "B6b": (11, [2, 4, 8, 5, 10, 9, 7, 3, 6, 1, 2, 4], (0, 8, 9)),
    "B7": (10, [3, 7, 1, 3, 7, 1, 3, 7, 1], (0, 8, 9)),
    "B8": (11, [2, 3, 4, 5, 6, 7, 8, 9, 3], (0, 8, 9)),
    "B8b": (10, [], (0, 8, 9)),
    "B9": (11, [1, 3, 2, 1, 3, 2, 1], (2, 8, 9)),
    "B9b": (11, [1, 2, 3, 4, 5, 6], (3, 8, 9)),
    "C0": (11, [2, 4, 8, 5, 10, 9, 7, 3, 6, 1, 2, 4], (0, 8, 9)),
    "C0b": (11, [2, 3, 4, 5, 6, 7, 8, 9, 3], (0, 8, 9)),
    "C1": (11, [1, 2, 1, 2, 1, 2], (1, 6, 7)),
    "C1b": (11, [1, 2, 1, 2, 1, 2, 1, 2, 1], (0, 8, 9)),
    "C2": (10, [3, 1, 3, 1, 3, 1, 3, 1, 3], (0, 8, 9)),
    "C2b": (10, [2, 1, 2, 1, 2, 1, 2, 1, 2], (0, 8, 9)),
    "C3": (0, [], (0, 8, 9)),
    "C4": (0, [], (0, 8, 9)),
    "C5": (0, [], (0, 8, 9)),
    "C6": (10, [2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2], (1, 8, 9)),
    "C7": (10, [2, 1, 2, 1, 2, 1], (1, 6, 7)),
    "C7a": (10, [2, 1, 2, 1, 2, 1], (3, 8, 9)),
    "C7b": (11, [2, 3, 4, 5, 6, 7, 2, 3, 4], (0, 8, 9)),
    "C8": (10, [2, 1, 2, 1, 2, 1, 2, 1, 2], (0, 8, 9)),
    "C8b": (11, [2, 3, 4, 5, 6, 7, 2, 3, 4], (0, 8, 9)),
    "C8c": (11, [2, 3, 4, 5, 6, 7, 8, 9, 10], (0, 8, 9)),
    "C9": (10, [2, 1, 2, 1, 2, 1, 2, 1, 2], (0, 8, 9)),
    "C9b": (11, [2, 3, 4, 5, 6, 7, 8, 9, 10], (0, 8, 9)),
    "D0": (0, [], (0, 8, 9)),
    "D1": (0, [], (0, 8, 9)),
    "D2": (11, [2, 3, 4, 5, 6, 7, 2, 3, 4], (0, 8, 9)),
    "D2b": (10, [2, 1, 2, 1, 2, 1, 2, 1, 2], (0, 8, 9)),
    "D3": (10, [2, 1, 2, 1, 2, 1, 2, 1, 2], (0, 8, 9)),
    "D4": (0, [], (0, 8, 9)),
    "D5": (0, [], (0, 8, 9)),
    "D5a": (11, [2, 3, 4, 5, 6, 7, 8, 0, 0], (0, 8, 9)),
    "D5b": (11, [2, 3, 4, 5, 6, 7, 0, 0, 0], (0, 8, 9)),
    "D5c": (7, [2, 3, 4, 5, 6, 7, 0, 0, 0], (0, 8, 9)),
    "D5d": (10, [2, 3, 4, 5, 6, 7, 0, 0, 0], (0, 8, 9)),
    "D6": (11, [2, 3, 4, 5, 6, 7, 8, 9, 10], (0, 8, 9)),
    "D6b": (10, [2, 1, 2, 1, 2, 1, 2, 1, 2], (0, 8, 9)),
    "D7": (10, [2, 1, 2, 1, 2, 1, 2, 1, 2], (0, 8, 9)),
    "D8": (0, [], (0, 8, 9)),
    "D9": (0, [], (0, 8, 9)),
    "E0": (10, [2, 1, 2, 1, 2, 1, 2, 1, 2], (0, 8, 9)),
    "E1": (11, [1, 2, 3, 4, 5, 6, 11, 10, 9], (0, 8, 9)),
  ];

  static private let m10hTransformationTable: [[UInt16]] = [
    [0, 1, 5, 9, 3, 7, 4, 8, 2, 6],
    [0, 1, 7, 6, 9, 8, 3, 2, 5, 4],
    [0, 1, 8, 4, 6, 2, 9, 5, 7, 3],
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
  ];

  // Explicit mappings of bank codes and/or bank accounts to new bank codes and/or bank accounts.
  // Each entry can have more than one mapping details entry.
  typealias MappingDetails = (rangeStart: Int, rangeEnd: Int, account: Int, bankCode: Int);
  static private var mappings: [Int: (rule: Int, details: [MappingDetails])] = [:];

  static private let accounts13091054: [Int] = [
    1718190, 22000225, 49902271, 49902280, 101680029,
    104200028, 106200025, 108000171, 108000279, 108001364,
    108001801, 108002514, 300008542, 9130099995, 9130500002,
    9131100008, 9131600000, 9131610006, 9132200006, 9132400005,
    9132600004, 9132700017, 9132700025, 9132700033, 9132700041,
    9133200700, 9133200735, 9133200743, 9133200751, 9133200786,
    9133200808, 9133200816, 9133200824, 9133200832, 9136700003,
    9177300010, 9177300060, 9198100002, 9198200007, 9198200104,
    9198300001, 9331300141, 9331300150, 9331401010, 9331401061,
    9349010000, 9349100000, 9360500001, 9364902007, 9366101001,
    9366104000, 9370620030, 9370620080, 9371900010, 9373600005,
    9402900021, 9605110000, 9614001000, 9615000016, 9615010003,
    9618500036, 9631020000, 9632600051, 9632600060, 9635000012,
    9635000020, 9635701002, 9636010003, 9636013002, 9636016001,
    9636018004, 9636019000, 9636022001, 9636024004, 9636025000,
    9636027003, 9636028000, 9636045001, 9636048000, 9636051001,
    9636053004, 9636120003, 9636140004, 9636150000, 9636320002,
    9636700000, 9638120000, 9639401100, 9639801001, 9670010004,
    9680610000, 9705010002, 9705403004, 9705404000, 9705509996,
    9707901001, 9736010000, 9780100050, 9791000030, 9990001003,
    9990001100, 9990002000, 9990004002, 9991020001, 9991040002,
    9991060003, 9999999993, 9999999994, 9999999995, 9999999996,
    9999999997, 9999999998, 9999999999,
  ];

  override class func initialize() {
    super.initialize();

    let bundle = NSBundle(forClass: DEAccountCheck.self);
    let resourcePath = bundle.pathForResource("mappings", ofType: "txt", inDirectory: "de");
    if resourcePath != nil && NSFileManager.defaultManager().fileExistsAtPath(resourcePath!) {
      var error: NSError?;
      let content = NSString(contentsOfFile: resourcePath!, encoding: NSUTF8StringEncoding, error: &error);
      if error != nil {
        let alert = NSAlert.init(error: error!);
        alert.runModal();
        return;
      }

      if content != nil {
        var sourceBankCode: NSString = "";
        var rule = 0;
        var entry: MappingDetails = (0, 0, 0, 0);

        var sourceBankCodeIndex = -1;
        var sourceAccountIndex = -1;
        var sourceAccountStartIndex = -1;
        var sourceAccountEndIndex = -1;
        var targetBankCodeIndex = -1;
        var targetAccountIndex = -1;

        for line in content!.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()) {
          var s: NSString = line as! NSString;
          s = s.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet());
          if s.length == 0 || s.hasPrefix("//")  || s.hasPrefix("#"){
            continue; // Ignore empty and comment lines.
          }

          if s.hasPrefix("[") {
            // Format specifier.
            entry = (0, 0, 0, 0);
            sourceBankCodeIndex = -1;
            sourceAccountIndex = -1;
            sourceAccountStartIndex = -1;
            sourceAccountEndIndex = -1;
            targetBankCodeIndex = -1;
            targetAccountIndex = -1;

            s = s.substringWithRange(NSMakeRange(1, s.length - 2));
            var index = 0;
            for part in s.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) {
              let p = part as! NSString;
              if !p.hasPrefix("#") && p != "_" {
                rule = (part as! String).toInt()!;
                continue;
              }

              if p == "_" {
                ++index;
                continue;
              }

              let explicitValue = p.substringFromIndex(3) as NSString;
              switch p.substringToIndex(3) {
              case "#sc":
                if explicitValue.length > 0 {
                  sourceBankCode = (explicitValue as NSString);
                  sourceBankCodeIndex = -1;
                } else {
                  sourceBankCodeIndex = index++;
                }
              case "#sa":
                if explicitValue.length > 0 {
                  entry.rangeStart = (explicitValue as String).toInt()!;
                  entry.rangeEnd = entry.rangeStart;
                  sourceAccountIndex = -1;
                } else {
                  sourceAccountIndex = index++;
                }
              case "#ss":
                if explicitValue.length > 0 {
                  entry.rangeStart = (explicitValue as String).toInt()!;
                  sourceAccountStartIndex = -1;
                } else {
                  sourceAccountStartIndex = index++;
                }
              case "#se":
                if explicitValue.length > 0 {
                  entry.rangeEnd = (explicitValue as String).toInt()!;
                  sourceAccountEndIndex = -1;
                } else {
                  sourceAccountEndIndex = index++;
                }
              case "#tc":
                if explicitValue.length > 0 {
                  entry.bankCode = (explicitValue as String).toInt()!;
                  targetBankCodeIndex = -1;
                } else {
                  targetBankCodeIndex = index++;
                }
              case "#ta":
                if explicitValue.length > 0 {
                  entry.account = (explicitValue as String).toInt()!;
                  targetAccountIndex = -1;
                } else {
                  targetAccountIndex = index++;
                }

              default:
                ++index;
                continue;
              }
            }

            continue;
          }

          // Normal mapping line.
          let parts: [String] = s.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) as! [String];
          if sourceBankCodeIndex > -1 && sourceBankCodeIndex < parts.count {
            sourceBankCode = parts[sourceBankCodeIndex];
          }
          if sourceAccountIndex > -1 && sourceAccountIndex < parts.count {
            entry.rangeStart = parts[sourceAccountIndex].toInt()!;
            entry.rangeEnd = entry.rangeStart;
          }
          if sourceAccountStartIndex > -1 && sourceAccountStartIndex < parts.count {
            entry.rangeStart = parts[sourceAccountStartIndex].toInt()!;
          }
          if sourceAccountEndIndex > -1 && sourceAccountEndIndex < parts.count {
            entry.rangeEnd = parts[sourceAccountEndIndex].toInt()!;
          }
          if targetBankCodeIndex > -1 && targetBankCodeIndex < parts.count {
            entry.bankCode = parts[targetBankCodeIndex].toInt()!;
          }
          if targetAccountIndex > -1 && targetAccountIndex < parts.count {
            entry.account = parts[targetAccountIndex].toInt()!;
          }

          // There can never be multiple IBAN rules for a given bank code as every bank code is
          // covered by exactly one rule (or none at all).
          // The source bank code can actually be a list of bank codes.
          for bankCode in sourceBankCode.componentsSeparatedByString(",") {
            let code = (bankCode as! String).toInt()!;
            var mappingTuple = mappings[code];
            if mappingTuple == nil {
              mappingTuple = (rule, []);
            }
            mappingTuple!.details.append(entry);
            mappings[code] = mappingTuple;
          }
        }
      }
    }
  }

  class func intFromRange(range: Slice<UInt16>) -> Int {
    var result: Int = 0;
    for digit in range {
      result = result * 10 + Int(digit);
    }

    return result;
  }

  override class func isValidAccount(inout account: String, inout _ bankCode: String, _ forIBAN: Bool) -> (Bool, IBANToolsResult) {
    let accountAsInt = account.toInt();
    if accountAsInt == nil {
      return (false, .WrongValue);
    }
    checkSpecialAccount(&account, bankCode: &bankCode);
    var method = DERules.checkSumMethodForInstitute(bankCode);
    if method == "" {
      // If we cannot find a method from the given (and potentially converted) bank code see
      // if we can find something from the private mappings (based on account clusters). This may give us
      // another bank code if there's a set of mappings for a specific IBAN rule to which the
      // original bank code belongs (this way we ensure we don't mess with accounts from other banks).
      let newBankCode = bankCodeFromAccountCluster(accountAsInt!, bankCode: bankCode.toInt()!);
      if newBankCode > -1 {
        bankCode = String(newBankCode);
        method = DERules.checkSumMethodForInstitute(bankCode);
      }
    }
    let (valid, realResult, _) = checkWithMethod(method, &account, &bankCode, forIBAN, true, false); // False for checkSpecial as we do that above already.
    return (valid, realResult);
  }

  /// Runs the specific checksum method on the given account. Returns validity, the result flag and
  /// the position of the checksum digit (which might vary, even for a single method). This position
  /// can be used for special checks (e.g. the IBAN conversion).
  /// Special accounts are first mapped to their real values (which are returned as a further value).
  class func checkWithMethod(startMethod: String, inout _ account: String, inout _ bankCode: String,
    _ forIBAN: Bool, _ allowAlternative: Bool = true, _ checkSpecial: Bool = true) -> (Bool, IBANToolsResult, Int) {

    if checkSpecial {
      checkSpecialAccount(&account, bankCode: &bankCode);
    }
    var accountAsInt: Int = account.toInt()!; // This must be valid at this point.

    var method = startMethod;
    var workSlice: Slice<UInt16> = [];
    var expectedCheckSum: UInt16 = 100;
    var parameters: MethodParameters = (0, [], (0, 8, 9));
    var number10: [UInt16] = []; // Alway 10 digits long.

    //----------------------------------------------------------------------------------------------

    // Switches the current computation method and loading its paramters (if there are own ones).
    func useMethod(newMethod: NSString) {
      method = newMethod.substringToIndex(2); // Only use the base method number for the switch var.
      if let p = self.methodParameters[newMethod as String] {
        parameters = p;
        workSlice = number10[parameters.indices.start...parameters.indices.stop];
        expectedCheckSum = number10[parameters.indices.check];
      }
    }

    //----------------------------------------------------------------------------------------------

    // Note: do not generally reject account number 0 which we use as an extreme corner case below
    //       to harden the routines. In some cases a 0 is even valid.
    if method == "09" || method == "12" {
      return (true, .NoChecksum, -1); // No checksum computation for these methods.
    }

    if let p = methodParameters[method] {
      parameters = p;
    } else {
      return (false, .NoMethod, -1);
    }

    // Convert account digits to their number values in an array.
    // Remove leading zeros to have the real lenght of the original number.
    let stripped = toString(accountAsInt);
    var temp = [UInt16](stripped.utf16);
    var number: [UInt16] = [];
    for n in temp {
      number.append(n - 48);
    }
    var baseNumber = number; // The original number without checksum (assuming this number is in the
                             // last digit, which is not always the case). So, use with care.
    baseNumber.removeLast();

    // Fill the original number on the left with zeros to get to a 10 digits number.
    // Determine the exact number of leading zeros for some special checks.
    let leadingZeros = 10 - count(stripped);
    temp = [UInt16]((String(count: leadingZeros, repeatedValue: "0" as Character) + stripped).utf16);
    for n in temp {
      number10.append(n - 48);
    }

    workSlice = number10[parameters.indices.start...parameters.indices.stop];
    expectedCheckSum = number10[parameters.indices.check];

    let defaultFalseResult = (false, IBANToolsResult.BadAccount, -1);
    let defaultTrueResult = (true, IBANToolsResult.NoChecksum, -1);

    // Pre-massage and special handling for certain methods, depending on the given account.
    switch method {
    case "06":
      switch bankCode {
      case "35060190":
        // Special accounts Bank für Kirche und Diakonie.
        if accountAsInt == 55111 || accountAsInt == 8090100 {
          return (true, .NoChecksum, -1);
        }
      case "32060362":
        // Voksbank Krefeld eG.
        if accountAsInt == 3333 || accountAsInt == 4444 {
          return (true, .NoChecksum, -1);
        }
      default:
        break;
      }

    case "08":
      // Description for this method is unclear. No mention of what should happen for
      // accounts which are not in range.
      if accountAsInt < 60000 {
        return defaultFalseResult;
      }

    case "24":
      // This method starts on the first non-null digit (from left).
      if accountAsInt == 0 {
        return defaultFalseResult;
      }

      // 2 additional exceptions:
      // - If the first digit is 3, 4, 5 or 6 it's treated like a 0.
      // - if the first digit is 9 this and the following 2 digits are treated as 0 as well.
      switch number10[0] {
      case 3, 4, 5, 6:
        number10[0] = 0;

      case 9:
        number10[0] = 0;
        number10[1] = 0;
        number10[2] = 0;

      default:
        // No change.
        break;
      }

      var startIndex = 0;
      for n in number10 {
        if n != 0 {
          break;
        }
        ++startIndex;
      }
      workSlice = number10[startIndex...parameters.indices.stop];

    case "26" where leadingZeros >= 2:
      // Special case which requires a shift for accounts starting with 2 zeros.
      useMethod("26b");

    case "32" where bankCode == "13091054" && forIBAN: // Pommersche Voksbank, special accounts always valid for IBAN.
        if contains(accounts13091054, accountAsInt) {
          return (true, .NoChecksum, -1); // No checks for checksum in those special accounts.
        }
      break;

    case "41":
      if number10[3] == 9 {
        number10[0] = 0;
        number10[1] = 0;
        number10[2] = 0;
        workSlice = number10[parameters.indices.start...parameters.indices.stop];
      }

    case "45":
      if number10[0] == 0 || number10[4] == 1 {
        return defaultTrueResult; // Always true, as those numbers don't contain a checksum.
      }

    case "59":
      if number.count < 10 {
        return defaultTrueResult;
      }

    case "61":
      if number10[8] == 8 {
        // Include digits 8 and 9 in the work slice, if the type number is 8.
        workSlice += number10[8...9];
      }

    case "63":
      if number10[0] != 0 {
        return defaultFalseResult;
      }

    case "65":
      if number10[8] == 9 {
        // Include digits 8 and 9 in the work slice, if the type number is 9.
        workSlice += number10[8...9];
      }

    case "66":
      if number10[1] == 9 {
        return defaultTrueResult; // No checksum.
      }

    case "70":
      // Certain numbers do not include all digits for the computation.
      if number10[3] == 5 || (number10[3] == 6 && number10[4] == 9) {
        workSlice = number10[3...8];
      }

    case "76":
      if number10[0] == 1 || number10[0] == 2 || number10[0] == 3 || number10[0] == 5 {
        return defaultFalseResult;
      }

    case "78":
      if number.count == 8 {
        return defaultTrueResult;
      }

    case "79":
      switch number10[0] {
      case 0:
        return defaultFalseResult;
      case 1, 2, 9:
        useMethod("79b");

      default:
        break;
      }

    case "82":
      if number10[2] == 9 && number10[3] == 9 {
        method = "10";
        useMethod("10");
      } else {
        method = "33"; // No further parameter updates. We use those from method 82.
      }

    case "88":
      if number10[2] == 9 {
        useMethod("88b");
      }

    case "89":
      switch number.count {
      case 7:
        break;
      case 8, 9:
        useMethod("10")
      default:
        return defaultTrueResult;
      }

    case "95":
      switch accountAsInt {
      case 0000000001...0001999999, 0009000000...0025999999, 0396000000...0499999999,
           0700000000...0799999999, 0910000000...0989999999:
        return defaultTrueResult;

      default:
        break;
      }

    case "96":
      if 0001300000...0099399999 ~= accountAsInt{
        return defaultTrueResult;
      }

    case "99":
      if  0396000000...0499999999 ~= accountAsInt{
        return defaultTrueResult;
      }

    case "A0":
      if 100..<1000 ~= accountAsInt {
        return defaultTrueResult;
      }

    case "A1":
      if number.count != 8 && number.count != 10 {
        return defaultFalseResult;
      }

    case "A6":
      if number10[1] == 8 {
        useMethod("00");
      } else {
        useMethod("01");
      }

    case "B0":
      if number10[7] == 1 || number10[7] == 2 || number10[7] == 3 || number10[7] == 6 {
        return defaultTrueResult;
      }

    case "B2":
      if number10[0] == 8 || number10[0] == 9 {
        useMethod("00");
      } else {
        useMethod("02");
      }

    case "B3":
      if number10[0] == 9 {
        useMethod("06");
      } else {
        useMethod("32");
      }

    case "B4":
      if number10[0] == 9 {
        useMethod("00");
      } else {
        useMethod("02");
      }

    case "B7":
      if !(0001000000...0005999999 ~= accountAsInt || 0700000000...0899999999 ~= accountAsInt) {
        return defaultTrueResult;
      }

    case "B8":
      if 5100000000...5999999999 ~= accountAsInt || 9010000000...9109999999 ~= accountAsInt {
        return defaultTrueResult;
      }

    case "B9":
      if leadingZeros != 2 && leadingZeros != 3 {
        return defaultFalseResult;
      }

    case "C0":
      if leadingZeros != 2 && leadingZeros != 3 {
        useMethod("20");
      }

    case "C1":
      if number10[0] == 5 {
        useMethod("C1b");
      }

    case "C3":
      if number10[0] == 9 {
        useMethod("58");
      } else {
        useMethod("00");
      }

    case "C4":
      if number10[0] == 9 {
        useMethod("58");
      } else {
        useMethod("15");
      }

    case "C5":
      switch number.count {
      case 6, 9:
        if !(1...8 ~= number[0]) { // Only account clusters 0000100000 - 0000899999 / 0100000000 - 0899999999 valid here.
          return defaultFalseResult;
        }
        useMethod("75");

      case 8:
        let valid = number10[2] == 3 || number10[2] == 4 || number10[2] == 5;
        return (valid, valid ? .NoChecksum : .BadAccount, -1);

      case 10:
        switch number10[0] {
        case 1, 4, 5, 6, 9:
          useMethod("29");

        case 3:
          useMethod("00");

        default:
          let valid = number10[0] == 7 && number10[1] == 0 || number10[0] == 8 && number10[1] == 5;
          return (valid, valid ? .NoChecksum : .BadAccount, -1);
        }

      default:
        return defaultFalseResult;
      }

    case "C6":
      let prefix: [[UInt16]] = [
        [4, 4, 5, 1, 9, 7, 0],
        [4, 4, 5, 1, 9, 8, 1],
        [4, 4, 5, 1, 9, 9, 2],
        [4, 4, 5, 1, 9, 9, 3],
        [4, 3, 4, 4, 9, 9, 2],
        [4, 3, 4, 4, 9, 9, 0],
        [4, 3, 4, 4, 9, 9, 1],
        [5, 4, 9, 9, 5, 7, 0],
        [4, 4, 5, 1, 9, 9, 4],
        [5, 4, 9, 9, 5, 7, 9],
      ];
      number10 = prefix[Int(number10[0])] + number10[1...9];
      workSlice = number10[0..<number10.count - 1];

    case "C7":
      if number10[1] == 0 && number10[2] == 0 {
        useMethod("C7a");
      }

    case "D0":
      if number10[0] == 5 && number10[1] == 7 {
        return defaultTrueResult;
      }
      useMethod("20");

    case "D1":
      if number10[0] == 8 {
        return defaultFalseResult;
      }

      useMethod("00");
      number10 = [4, 3, 6, 3, 3, 8] + number10;
      workSlice = number10[0..<number10.count - 1];

    case "D4":
      if number10[0] == 0 {
        return defaultFalseResult;
      }

      useMethod("00");
      number10 = [4, 2, 8, 2, 5, 9] + number10;
      workSlice = number10[0..<number10.count - 1];

    case "D8":
      let part = intFromRange(number10[0...2]);
      if 1...9 ~= part { // No check for cluster 0010000000 through 0099999999.
        return defaultTrueResult;
      }
      useMethod("00");

    case "E1":
      // Transform digit values into special numbers.
      for i in 0...8 {
        number10[i] += 48;
      }
      workSlice = number10[0..<number10.count - 1];

    default:
      break;
    }

    // The method handler. This is for the first variants in each method only.
    // There's another switch for those method that may get a second chance.
    switch method {
    case "00", "08", "13", "30", "41", "45", "49", "59", "65", "67", "72", "74", "78", "79",
      "80", "94", "A1", "A2", "A3", "A7", "C6", "C9":
      if method == "80" && number10[2] == 9 {
        return (method51(number10), .OK, parameters.indices.check);
      }

      let checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        mappings: [.MapToZero, .DontMap, .ReturnDifference]);
      if expectedCheckSum == checksum {
        return (true, .OK, parameters.indices.check);
      }

    case "06", "10", "11", "15", "19", "20", "26", "28", "32", "33", "34", "36", "37", "38", "39",
    "40", "42", "44", "46", "47", "48", "50", "55", "60", "70", "81", "88", "95", "96", "99",
    "A0", "A8", "B0", "B6", "B8":
      if (method == "81" || method == "A8") && number10[2] == 9 {
        return (method51(number10), .OK, parameters.indices.check);
      }

      var checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        mappings: [.MapToZero, .MapToZero, .ReturnDifference], useDigitSum: false);
      if method == "11" && checksum == 10 {
        checksum = 9;
      }
      if expectedCheckSum == checksum {
        return (true, .OK, parameters.indices.check);
      }

    case "02", "04", "07", "14", "25", "58", "B2", "B8":
      let checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        mappings: [.MapToZero, .MapToSpecial, .ReturnDifference], useDigitSum: false);
      if method == "25" && checksum == 99 {
        // Checksum valid only if the work number (the one in the second position) is either 9 or 8.
        if number[1] == 8 || number[1] == 9 {
          return (true, .OK, parameters.indices.check);
        }
      }
      if expectedCheckSum == checksum {
        return (true, .OK, parameters.indices.check);
      }

    case "17", "C1":
      let checksum = pattern2(workSlice, modulus: parameters.modulus, weights: parameters.weights, backwards: false);
      if expectedCheckSum == checksum {
        return (true, .OK, parameters.indices.check);
      }

    case "01", "03", "05", "18", "43", "49", "92", "98", "A9", "B1", "B7":
      let checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        mappings: [.MapToZero, .DontMap, .ReturnDifference], useDigitSum: false);
      if expectedCheckSum == checksum {
        return (true, .OK, parameters.indices.check);
      }

    case "21":
      let checksum = pattern3(workSlice, modulus: parameters.modulus, weights: parameters.weights);
      if expectedCheckSum == checksum {
        return (true, .OK, parameters.indices.check);
      }

    case "22", "C2":
      let checksum = pattern4(workSlice, modulus: parameters.modulus, weights: parameters.weights);
      if expectedCheckSum == checksum {
        return (true, .OK, parameters.indices.check);
      }

    case "31", "35", "76":
      let checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        mappings: [.DontMap, .DontMap, .ReturnRemainder], useDigitSum: false);
      if method == "35" && checksum == 10 {
        let valid = number10[8] == number10[9];
        return (valid, valid ? .OK : .BadAccount, parameters.indices.check);
      }
      if expectedCheckSum == checksum {
        return (true, .OK, parameters.indices.check);
      }

    case "27":
      return (method27(accountAsInt, number10), .OK, parameters.indices.check);

    case "29":
      let checksum = patternM10H(workSlice, modulus: parameters.modulus);
      if expectedCheckSum == checksum {
        return (true, .OK, parameters.indices.check);
      }

    case "16", "23":
      var checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        mappings: [.DontMap, .MapToSpecial, .ReturnDifference], useDigitSum: false);
      if checksum == 99 {
        switch method {
        case "16":
          let valid = number10[8] == number10[9];
          return (valid, valid ? .OK : .BadAccount, parameters.indices.check);
        case "23":
          let valid = number10[5] == number10[6];
          return (valid, valid ? .OK : .BadAccount, parameters.indices.check);

        default:
          break;
        }
      }
      if checksum == 10 {
        checksum = 0;
      }
      if expectedCheckSum == checksum {
        return (true, .OK, parameters.indices.check);
      }

    case "24", "B9":
      var checksum = pattern5(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        backwards: method == "B9");
      if expectedCheckSum == checksum {
        return (true, .OK, parameters.indices.check);
      }

      // A second step if the check failed.
      if method == "B9" {
        checksum += 5;
        if checksum > 10 {
          checksum -= 10;
        }
        if expectedCheckSum == checksum {
          return (true, .OK, parameters.indices.check);
        }
      }

    case "51":
      let valid = method51(number10);
      return (valid, valid ? .OK : .BadAccount, parameters.indices.check);

    case "52", "53", "C0":
      if method5253(number, bankCode: bankCode, modulus: parameters.modulus, weights: parameters.weights) {
        return (true, .OK, parameters.indices.check);
      }

    case "54":
      let checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        mappings: [.DontMap, .DontMap, .ReturnDifference], useDigitSum: false);
      if expectedCheckSum == checksum {
        return (true, .OK, parameters.indices.check);
      }

    case "56":
      var checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        mappings: [.DontMap, .DontMap, .ReturnDifference], useDigitSum: false);
      if number10[0] == 9 {
        if checksum == 10 {
          checksum = 7;
        }
        if checksum == 11 {
          checksum = 8;
        }

      }
      if expectedCheckSum == checksum {
        return (true, .OK, parameters.indices.check);
      }

    case "57":
      if account.hasPrefix("777777") || account.hasPrefix("888888") || account == "0185125434" {
        return defaultTrueResult;
      }

      let startNumber = number10[0] * 10 + number10[1];
      switch startNumber {
      case 0:
        return defaultFalseResult;

      case 51, 55, 61, 64...66, 70, 73...82, 88, 94, 95: // Variant 1.
        let checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
          mappings: [.MapToZero, .DontMap, .ReturnDifference]);
        let valid = expectedCheckSum == checksum;
        return (valid, valid ? .OK : .BadAccount, parameters.indices.check);

      case 32...39, 41...49, 52...54, 56...60, 62...63, 67...69, 71, 72, 83...87, 89, 90, 92,
           93, 96...98: // Variant 2.
        // The checksum is in digit 2 which must not be included in the computation.
        // But instead we have to include digit 9.
        workSlice = number10[0...1] + number10[3...9];
        let checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
          mappings: [.MapToZero, .DontMap, .ReturnDifference]);
        let valid = number10[2] == checksum;
        return (valid, valid ? .OK : .BadAccount, parameters.indices.check);

      case 40, 50, 91, 99: // Variant 3.
        return defaultTrueResult;

      case 1...31: // Variant 4.
        var inner1 = number10[2] * 10 + number10[3];
        var inner2 = number10[6] * 100 + number10[7] * 10 + number10[8];
        if 1...12 ~= inner1 && inner2 < 500 {
          return defaultTrueResult;
        }
        return defaultFalseResult;

      default:
        return defaultFalseResult;
      }

    case "61", "62", "63", "C7":
      let checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        mappings: [.DontMap, .DontMap, .ReturnDifference], backwards: true, useDigitSum: true);
      if expectedCheckSum == checksum {
        return (true, .OK, parameters.indices.check);
      }

    case "64":
      let checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        mappings: [.MapToZero, .MapToZero, .ReturnDifference], backwards: false, useDigitSum: false);
      if expectedCheckSum == checksum {
        return (true, .OK, parameters.indices.check);
      }

    case "66":
      let checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        mappings: [.MapToOne, .MapToZero, .ReturnDifference], useDigitSum: false);
      if expectedCheckSum == checksum {
        return (true, .OK, parameters.indices.check);
      }

    case "68":
      let valid = method68(number);
      return (valid, valid ? .OK : .BadAccount, parameters.indices.check);

    case "69":
      if number10[0] == 9 && number10[1] == 3 {
        return (true, .OK, parameters.indices.check);
      }

      if !(9700000000...9799999999 ~= accountAsInt) {
        // Variant 1. Only for numbers outside the range 9 700 000 000 through 9 799 999 999.
        // If that fails, try with variant 2.
        let checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
          mappings: [.MapToZero, .MapToZero, .ReturnDifference], useDigitSum: false);
        if expectedCheckSum == checksum {
          return (true, .OK, parameters.indices.check);
        }
      }

    case "71":
      let checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        mappings: [.MapToZero, .MapToOne, .ReturnDifference], backwards: false, useDigitSum: false);
      if expectedCheckSum == checksum {
        return (true, .OK, parameters.indices.check);
      }

    case "73":
      if number10[2] == 9 {
        let valid = method51(number10);
        return (valid, valid ? .OK : .BadAccount, parameters.indices.check);
      }

      for subMethod in ["73a", "73b", "73c"] {
        useMethod(subMethod);
        var checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
          mappings: [.MapToZero, .DontMap, .ReturnDifference]);
        if expectedCheckSum == checksum {
          return (true, .OK, parameters.indices.check);
        }
      }

      return defaultFalseResult;

    case "75":
      // A different work slice for accounts with 9 digits.
      var checksumPos = parameters.indices.check;
      if number.count == 9 {
        if number10[1] == 9 {
          workSlice = number10[2...6];
          checksumPos = 7;
        } else {
          workSlice = number10[1...5];
          checksumPos = 6;
        }
        expectedCheckSum = number10[checksumPos];
      }

      let checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        mappings: [.MapToZero, .DontMap, .ReturnDifference], backwards: false);
      if expectedCheckSum == checksum {
        return (true, .OK, checksumPos);
      }

    case "77":
      var checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        mappings: [.DontMap, .DontMap, .ReturnDivByModulus], useDigitSum: false);
      if checksum == 0 {
        return (true, .OK, parameters.indices.check);
      }

    case "83", "84", "85":
      if method == "84" {
        if number10[2] == 9 {
          let valid = method51(number10);
          return (valid, valid ? .OK : .BadAccount, parameters.indices.check);
        }
      } else {
        if number10[2] == 9 && number10[3] == 9 {
          useMethod(method + "d");
          var checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
            mappings: [.MapToZero, .MapToZero, .ReturnDifference], useDigitSum: false);
          let valid = expectedCheckSum == checksum;
          return (valid, valid ? .OK : .BadAccount, parameters.indices.check);
        }
      }

      for subMethod in [method + "a", method + "b", method + "c"] {
        useMethod(subMethod);
        var checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
          mappings: [.MapToZero, .MapToZero, .ReturnDifference], useDigitSum: false);
        if expectedCheckSum == checksum {
          return (true, .OK, parameters.indices.check);
        }
      }

      return defaultFalseResult;

    case "86":
      if number10[2] == 9 {
        let valid = method51(number10);
        return (valid, valid ? .OK : .BadAccount, parameters.indices.check);
      }

      useMethod("86a");
      var checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        mappings: [.MapToZero, .DontMap, .ReturnDifference]);
      if expectedCheckSum == checksum {
        return (true, .OK, parameters.indices.check);
      }

      useMethod("86b");
      checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        mappings: [.MapToZero, .MapToZero, .ReturnDifference], useDigitSum: false);
      if expectedCheckSum == checksum {
        return (true, .OK, parameters.indices.check);
      }

      return defaultFalseResult;

    case "87":
      if accountAsInt == 0 {
        return defaultFalseResult;
      }

      if number10[2] == 9 {
        let valid = method51(number10);
        return (valid, valid ? .OK : .BadAccount, parameters.indices.check);
      }

      if method87a(number10) {
        return (true, .OK, parameters.indices.check);
      }

      useMethod("87b");
      var checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        mappings: [.MapToZero, .MapToZero, .ReturnDifference], useDigitSum: false);
      if expectedCheckSum == checksum {
        return (true, .OK, parameters.indices.check);
      }

      useMethod("87c");
      checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        mappings: [.MapToZero, .DontMap, .ReturnDifference], useDigitSum: false);
      if expectedCheckSum == checksum {
        return (true, .OK, parameters.indices.check);
      }

      return defaultFalseResult;

    case "89":
      let checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        mappings: [.MapToZero, .MapToZero, .ReturnDifference]);
      if expectedCheckSum == checksum {
        return (true, .OK, parameters.indices.check);
      }

    case "90":
      if number10[2] == 9 {
        useMethod("90f")
        let checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
          mappings: [.MapToZero, .MapToZero, .ReturnDifference], useDigitSum: false);
        let valid = expectedCheckSum == checksum;
        return (valid, valid ? .OK : .BadAccount, parameters.indices.check);
      }

      for subMethod in ["90a", "90b"] {
        useMethod(subMethod);
        var checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
          mappings: [.MapToZero, .MapToZero, .ReturnDifference], useDigitSum: false);
        if expectedCheckSum == checksum {
          return (true, .OK, parameters.indices.check);
        }
      }

      useMethod("90c");
      var checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        mappings: [.MapToZero, .DontMap, .ReturnDifference], useDigitSum: false);
      if expectedCheckSum == checksum {
        if checksum == 7 || checksum == 8 || checksum == 9 {
          return defaultFalseResult; // Even though the checksum is correct those accounts are considered wrong.
        }
        return (true, .OK, parameters.indices.check);
      }

      useMethod("90d");
      checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        mappings: [.MapToZero, .DontMap, .ReturnDifference], useDigitSum: false);
      if expectedCheckSum == checksum {
        if checksum == 9 {
          return defaultFalseResult;
        }
        return (true, .OK, parameters.indices.check);
      }

      for subMethod in ["90e", "90g"] {
        useMethod(subMethod);
        checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
          mappings: [.MapToZero, .DontMap, .ReturnDifference], useDigitSum: false);
        if expectedCheckSum == checksum {
          return (true, .OK, parameters.indices.check);
        }
      }

      return defaultFalseResult;

    case "91":
      for subMethod in ["91a", "91b", "91c", "91d"] {
        useMethod(subMethod);
        var checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
          mappings: [.MapToZero, .MapToZero, .ReturnDifference], useDigitSum: false);
        if expectedCheckSum == checksum {
          return (true, .OK, parameters.indices.check);
        }
      }

    case "93":
      let valid = method93(number10);
      return (valid, valid ? .OK : .BadAccount, parameters.indices.check);

    case "97":
      var checksum = pattern6(accountAsInt / 10, modulus: parameters.modulus);
      if checksum == 10 {
        checksum = 0;
      }
      if Int(expectedCheckSum) == checksum {
        return (true, .OK, parameters.indices.check);
      }

    case "A4":
      let isSpecial = number10[2] == 9 && number10[3] == 9;

      if !isSpecial {
        useMethod("A4a");
        var checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
          mappings: [.MapToZero, .MapToZero, .ReturnDifference], useDigitSum: false);
        if expectedCheckSum == checksum {
          return (true, .OK, parameters.indices.check);
        }

        useMethod("A4b");
        checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
          mappings: [.MapToZero, .DontMap, .ReturnDifference], useDigitSum: false);
        if expectedCheckSum == checksum {
          return (true, .OK, parameters.indices.check);
        }
      }

      useMethod("A4c");
      var checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        mappings: [.MapToZero, .MapToZero, .ReturnDifference], useDigitSum: false);
      if expectedCheckSum == checksum {
        return (true, .OK, parameters.indices.check);
      }

      let valid = method93(number10);
      return (valid, valid ? .OK : .BadAccount, parameters.indices.check);

    case "A5":
      let checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        mappings: [.MapToZero, .DontMap, .ReturnDifference]);
      if expectedCheckSum == checksum {
        return (true, .OK, parameters.indices.check);
      }

      if number10[0] == 9 {
        return defaultFalseResult;
      }

    case "A6":
      if number10[2] == 9 {
        let valid = method51(number10);
        return (valid, valid ? .OK : .BadAccount, parameters.indices.check);
      }

      let checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        mappings: [.MapToZero, .DontMap, .ReturnDifference]);
      if expectedCheckSum == checksum {
        return (true, .OK, parameters.indices.check);
      }

      if number10[0] == 9 {
        return defaultFalseResult;
      }

    case "B5":
      let checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        mappings: [.MapToZero, .DontMap, .ReturnDifference], useDigitSum: false);
      if expectedCheckSum == checksum {
        return (true, .OK, parameters.indices.check);
      }

      if number10[0] == 8 || number10[0] == 9 {
        return defaultFalseResult;
      }

    case "B6":
      var checksum: UInt16;
      if !(number10[0] != 0 || 02691...02699 ~= intFromRange(number10[0...4])) {
        checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
          mappings: [.MapToZero, .MapToZero, .ReturnDifference], useDigitSum: false);
      } else {
        checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
          mappings: [.MapToZero, .MapToSpecial, .ReturnDifference], useDigitSum: false);
      }
      if expectedCheckSum == checksum {
        return (true, .OK, parameters.indices.check);
      }

    case "C8":
      var checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        mappings: [.MapToZero, .DontMap, .ReturnDifference]);
      if expectedCheckSum == checksum {
        return (true, .OK, parameters.indices.check);
      }

      for subMethod in ["C8b", "C8c"] {
        useMethod(subMethod);
        checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
          mappings: [.MapToZero, .MapToSpecial, .ReturnDifference], useDigitSum: false);
        if expectedCheckSum == checksum {
          return (true, .OK, parameters.indices.check);
        }
      }

    case "D2":
      var checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        mappings: [.MapToZero, .MapToZero, .ReturnDifference], useDigitSum: false);
      if expectedCheckSum == checksum {
        return (true, .OK, parameters.indices.check);
      }

      useMethod("D2b");
      checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        mappings: [.MapToZero, .DontMap, .ReturnDifference]);
      if expectedCheckSum == checksum {
        return (true, .OK, parameters.indices.check);
      }

      let valid = method68(number);
      return (valid, valid ? .OK : .BadAccount, parameters.indices.check);

    case "D3":
      let checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        mappings: [.MapToZero, .DontMap, .ReturnDifference]);
      if expectedCheckSum == checksum {
        return (true, .OK, parameters.indices.check);
      }
      let valid = method27(accountAsInt, number10);
      return (valid, valid ? .OK : .BadAccount, parameters.indices.check);

    case "D5":
      for subMethod in ["D5a", "D5b"] {
        useMethod(subMethod);
        var checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
          mappings: [.MapToZero, .MapToZero, .ReturnDifference], useDigitSum: false);
        if expectedCheckSum == checksum {
          return (true, .OK, parameters.indices.check);
        }

        if (number10[2] == 9 && number10[3] == 9) {
          return defaultFalseResult;
        }
      }

      for subMethod in ["D5c", "D5d"] {
        useMethod(subMethod);
        var checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
          mappings: [.DontMap, .DontMap, .ReturnDifference], useDigitSum: false);
        if expectedCheckSum == checksum {
          return (true, .OK, parameters.indices.check);
        }
      }

    case "D6":
      var checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        mappings: [.MapToZero, .MapToSpecial, .ReturnDifference], useDigitSum: false);
      if expectedCheckSum == checksum {
        return (true, .OK, parameters.indices.check);
      }

      useMethod("D6b");
      for flag in [false, true] {
        checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
          mappings: [.MapToZero, .DontMap, .ReturnDifference], useDigitSum: flag);
        if expectedCheckSum == checksum {
          return (true, .OK, parameters.indices.check);
        }
      }

    case "D7":
      let checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        mappings: [.DontMap, .DontMap, .ReturnRemainder], useDigitSum: true);
      if expectedCheckSum == checksum {
        return (true, .OK, parameters.indices.check);
      }

    case "D9":
      useMethod("00");
      var checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        mappings: [.MapToZero, .DontMap, .ReturnDifference]);
      if expectedCheckSum == checksum {
        return (true, .OK, parameters.indices.check);
      }

      useMethod("10");
      checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        mappings: [.MapToZero, .MapToZero, .ReturnDifference], useDigitSum: false);
      if expectedCheckSum == checksum {
        return (true, .OK, parameters.indices.check);
      }

      useMethod("18");
      checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        mappings: [.MapToZero, .DontMap, .ReturnDifference], useDigitSum: false);
      if expectedCheckSum == checksum {
        return (true, .OK, parameters.indices.check);
      }

    case "E0":
      var checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        mappings: [.DontMap, .DontMap, .ReturnSum], useDigitSum: true);
      checksum = (checksum + 7) % 10;
      if (checksum > 0) {
        checksum = parameters.modulus - checksum;
      }
      if expectedCheckSum == checksum {
        return (true, .OK, parameters.indices.check);
      }

    case "E1":
      let checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        mappings: [.MapToZero, .DontMap, .ReturnRemainder], useDigitSum: false);
      if expectedCheckSum == checksum {
        return (true, .OK, parameters.indices.check);
      }

    default:
      return defaultFalseResult;
    }

    if !allowAlternative {
      return defaultFalseResult;
    }

    // If we come here then the first attempt didn't return the right value and alternative rules may
    // have been defined for a method. A separate second chance case is however only implemented,
    // if either the first chance or this second chance can be shared among different methods.
    // Otherwise all different variants are implemented in the first method switch statement.
    switch method {
    case "13", "80", "96", "A8", "B5", "C2":
      useMethod(method + "b");
      let checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        mappings: [.MapToZero, .DontMap, .ReturnDifference]);
      let valid = expectedCheckSum == checksum;
      return (valid, valid ? .OK : .BadAccount, parameters.indices.check);

    case "69", "B8":
      useMethod(method + "b");
      let checksum = patternM10H(workSlice, modulus: parameters.modulus);
      let valid = expectedCheckSum == checksum;
      return (valid, valid ? .OK : .BadAccount, parameters.indices.check);

    case "50", "A3", "A5", "A9", "C0", "C7":
      useMethod(method + "b");
      let checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        mappings: [.MapToZero, .MapToZero, .ReturnDifference], useDigitSum: false);
      let valid = expectedCheckSum == checksum;
      return (valid, valid ? .OK : .BadAccount, parameters.indices.check);

    case "63":
      if number10[1] == 0 && number10[2] == 0 {
        useMethod("63b");
        let checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
          mappings: [.DontMap, .DontMap, .ReturnDifference], backwards: true, useDigitSum: true);
        let valid = expectedCheckSum == checksum;
        return (valid, valid ? .OK : .BadAccount, parameters.indices.check);
      }
      return defaultFalseResult;

    case "74":
      if number.count == 6 {
        let checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
          mappings: [.MapToZero, .DontMap, .ReturnDiff2HalfDecade]);
        let valid = expectedCheckSum == checksum;
        return (valid, valid ? .OK : .BadAccount, parameters.indices.check);
      }
      return defaultFalseResult;

    case "76":
      useMethod(method + "b");
      // 00 sub account not given. Actual main number is moved 2 digits to the right.
      let checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        mappings: [.DontMap, .DontMap, .ReturnRemainder], useDigitSum: false);
      let valid = expectedCheckSum == checksum;
      return (valid, valid ? .OK : .BadAccount, parameters.indices.check);

    case "77":
      useMethod(method + "b");
      let checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        mappings: [.MapToZero, .DontMap, .ReturnDiff2HalfDecade], useDigitSum: false);
      let valid = checksum == 0;
      return (valid, valid ? .OK : .BadAccount, parameters.indices.check);

    case "A2", "C9":
      useMethod(method + "b");
      let checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        mappings: [.MapToZero, .MapToSpecial, .ReturnDifference], useDigitSum: false);
      let valid = expectedCheckSum == checksum;
      return (valid, valid ? .OK : .BadAccount, parameters.indices.check);

    case "A7", "B1":
      useMethod(method + "b");
      let checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        mappings: [.MapToZero, .DontMap, .ReturnDifference], useDigitSum: false);
      let valid = expectedCheckSum == checksum;
      return (valid, valid ? .OK : .BadAccount, parameters.indices.check);

    case "B6":
      useMethod(method + "b");
      let valid = method5253(number, bankCode: bankCode, modulus: parameters.modulus, weights: parameters.weights);
      return (valid, valid ? .OK : .BadAccount, parameters.indices.check);

    case "B9":
      useMethod(method + "b");
      var checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        mappings: [.DontMap, .DontMap, .ReturnRemainder], useDigitSum: false);
      if expectedCheckSum == checksum {
        return (true, .OK, parameters.indices.check);
      }

      checksum += 5;
      if checksum > 10 {
        checksum -= 10;
      }
      let valid = expectedCheckSum == checksum;
      return (valid, valid ? .OK : .BadAccount, parameters.indices.check);

    default:
      return defaultFalseResult;
    }
  }

  private class func digitSum(number: UInt16) -> UInt16 {
    var result: UInt16 = 0;
    var temp = number;
    while temp > 0 {
      result += temp % 10;
      temp /= 10;
    }

    return result;
  }

  // MARK: - checksum computation functions.

  private class func patternM10H(digits: Slice<UInt16>, modulus: UInt16) -> UInt16 {
    var weightIndex = 0;
    var sum: UInt16 = 0;
    var lineIndex = 0; // Line (0-3) in the transformation table.
    for digit in reverse(digits) {
      sum += m10hTransformationTable[lineIndex][Int(digit)];
      if ++lineIndex == 4 {
        lineIndex = 0;
      }
    }

    return 10 - sum % 10; // Not the modulus.
  }

  private class func computeSumRemainder(digits: Slice<UInt16>, _ modulus: UInt16, _ weights: [UInt16],
    _ backwards: Bool, _ useDigitSum: Bool, _ compute: (UInt16, UInt16) -> UInt16) -> (sum: UInt16, remainder: UInt16) {
      var weightIndex = 0;
      var sum: UInt16 = 0;
      let d = backwards ? digits.reverse() : digits;

      for digit in d {
        if weightIndex == weights.count {
          break;
        }
        let product = compute(digit, weights[weightIndex]);
        ++weightIndex;
        if useDigitSum {
          sum += digitSum(product);
        } else {
          sum += product;
        }
      }
      return (sum, sum % modulus);
  }

  private class func pattern1(digits: Slice<UInt16>, modulus: UInt16, weights: [UInt16],
    mappings: [ResultMapping] = [.DontMap, .DontMap, .ReturnDifference], backwards: Bool = true,
    useDigitSum: Bool = true) -> UInt16 {
      let (sum, remainder) = computeSumRemainder(digits, modulus, weights, backwards, useDigitSum,
        { return $0 * $1; } // Standard computation function.
      );

      assert(mappings.count >= 3, "Mappings must have at least 3 entries.");

      switch remainder {
      case 0: fallthrough
      case 1:
        switch mappings[Int(remainder)] {
        case .MapToZero:
          return 0;
        case .MapToOne:
          return 1;
        case .MapToSpecial:
          return 99;
        default:
          break;
        }
        fallthrough // Otherwise use the standard computation.
      default:
        switch mappings[2] {
        case .ReturnRemainder:
          return remainder;
        case .ReturnDifference:
          return modulus - remainder;
        case .ReturnDiff2HalfDecade:
          let offset: UInt16 = sum % 10 < 5 ? 5 : 10; // e.g. 24 -> 25, 27 -> 30
          return (sum / 10) * 10 + offset - sum;
        case .ReturnDivByModulus:
          return sum / modulus;
        case .ReturnSum:
          return sum;

        default:
          assert(false, "Invalid mapping used.");
        }
      }
      return 0; // Never hit.
  }

  private class func pattern2(digits: Slice<UInt16>, modulus: UInt16, weights: [UInt16], backwards: Bool = true) -> UInt16 {
    let (sum, remainder) = computeSumRemainder(digits, modulus, weights, backwards, true,
      { return $0 * $1; }
    );

    if sum > 0 {
      let factor = (sum - 1) % modulus;
      if factor == 0 {
        return 0;
      }
      return 10 - factor;
    }
    return 99;
  }

  private class func pattern3(digits: Slice<UInt16>, modulus: UInt16, weights: [UInt16], backwards: Bool = true) -> UInt16 {
    var (sum, remainder) = computeSumRemainder(digits, modulus, weights, backwards, true,
      { return $0 * $1; }
    );

    while sum > 10 {
      sum = digitSum(sum);
    }

    if sum == 0 {
      return 0;
    }

    return modulus - sum;
  }

  private class func pattern4(digits: Slice<UInt16>, modulus: UInt16, weights: [UInt16], backwards: Bool = true) -> UInt16 {
    var (sum, remainder) = computeSumRemainder(digits, modulus, weights, backwards, false,
      { return ($0 * $1) % 10; /* Only use the LSD. */ }
    );

    if remainder == 0 {
      return 0;
    }
    return 10 - remainder;
  }

  private class func pattern5(digits: Slice<UInt16>, modulus: UInt16, weights: [UInt16], backwards: Bool = true) -> UInt16 {
    var (sum, remainder) = computeSumRemainder(digits, modulus, weights, backwards, true,
      { return ($0 * $1 + $1) % modulus; }
    );

    return sum % 10; // Only the LSD.
  }

  private class func pattern6(number: Int, modulus: UInt16) -> Int {
    return number % Int(modulus);
  }

  // MARK: - full methods

  private class func method27(accountAsInt: Int, _ number10: [UInt16]) -> Bool {
    if let parameters = methodParameters["27"] {
      let workSlice = number10[parameters.indices.start...parameters.indices.stop];
      let expectedCheckSum = number10[parameters.indices.check];
      if accountAsInt < 1000000 { // Simple checksum computation only for accounts less than 1 000 000.
        let checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
          mappings: [.MapToZero, .DontMap, .ReturnDifference]);
        if expectedCheckSum == checksum {
          return true;
        }
      }

      let checksum = patternM10H(workSlice, modulus: parameters.modulus);
      return expectedCheckSum == checksum;
    }
    return false;
  }

  private class func method51(number10: [UInt16]) -> Bool {
    // 4 step approach here. Try one variant after the other until one succeeds.
    // However, there's an exception for certain accounts. They use a different 2-step approach.
    if number10[2] == 9 {
      if let parameters = methodParameters["51e"] {
        let checksum = pattern1(number10[parameters.indices.start...parameters.indices.stop], modulus: parameters.modulus,
          weights: parameters.weights, mappings: [.MapToZero, .MapToZero, .ReturnDifference], useDigitSum: false);
        if number10[parameters.indices.check] == checksum {
          return true;
        }
      }

      if let parameters = methodParameters["51f"] {
        let checksum = pattern1(number10[parameters.indices.start...parameters.indices.stop], modulus: parameters.modulus,
          weights: parameters.weights, mappings: [.MapToZero, .MapToZero, .ReturnDifference], useDigitSum: false);
        if number10[parameters.indices.check] == checksum {
          return true;
        }
      }
      return false;
    }

    if let parameters = methodParameters["51a"] {
      let checksum = pattern1(number10[parameters.indices.start...parameters.indices.stop], modulus: parameters.modulus,
        weights: parameters.weights, mappings: [.MapToZero, .MapToZero, .ReturnDifference], useDigitSum: false);
      if number10[parameters.indices.check] == checksum {
        return true;
      }
    }

    if let parameters = methodParameters["51b"] {
      let checksum = pattern1(number10[parameters.indices.start...parameters.indices.stop], modulus: parameters.modulus,
        weights: parameters.weights, mappings: [.MapToZero, .MapToZero, .ReturnDifference], useDigitSum: false);
      if number10[parameters.indices.check] == checksum {
        return true;
      }
    }

    if let parameters = methodParameters["51c"] {
      let checksum = pattern1(number10[parameters.indices.start...parameters.indices.stop], modulus: parameters.modulus,
        weights: parameters.weights, mappings: [.MapToZero, .DontMap, .ReturnDifference]);
      if number10[parameters.indices.check] == checksum {
        return true;
      }
    }

    if number10[9] == 7 || number10[9] == 9 || number10[9] == 9 {
      return false;
    }

    if let parameters = methodParameters["51d"] {
      let checksum = pattern1(number10[parameters.indices.start...parameters.indices.stop], modulus: parameters.modulus,
        weights: parameters.weights, mappings: [.MapToZero, .MapToZero, .ReturnDifference], useDigitSum: false);
      if number10[parameters.indices.check] == checksum {
        return true;
      }
    }

    return false;
  }

  private class func method68(var number: [UInt16]) -> Bool {
    if number.count == 9 && number[0] == 4 {
      return true;
    }

    if number.count < 6 {
      return false;
    }

    if let parameters = methodParameters["68"] {
      var workSlice: Slice<UInt16>;
      if number.count == 10 {
        if number[3] != 9 {
          return false;
        }
        workSlice = number[3..<number.count - 1];
      } else {
        workSlice = number[0..<number.count - 1];
      }
      var checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
        mappings: [.MapToZero, .DontMap, .ReturnDifference]);
      if number.last == checksum {
        return true;
      }

      // Exclude digits 1 + 2.
      var weights = parameters.weights;
      weights[5] = 0;
      weights[6] = 0;
      checksum = pattern1(workSlice, modulus: parameters.modulus, weights: weights,
        mappings: [.MapToZero, .DontMap, .ReturnDifference]);
      return number.last == checksum;
    }
    return false;
  }

  private class func method87a(var number10: [UInt16]) -> Bool {
    // The code below + the tab data has been taken directly from the documentation and
    // ported to Swift.

    let tab1: [UInt16] = [0, 4, 3, 2, 6];
    let tab2: [UInt16] = [7, 1, 5, 9, 8];

    var i = 3;
    while number10[i] == 0 {
      ++i;
    }

    var c2 = (i + 1) % 2;
    var d2 = 0;
    var a5: Int = 0;
    var p: UInt16;

    while i < 9 {
      switch number10[i] {
      case 0:
        number10[i] = 5;
      case 1:
        number10[i] = 6;
      case 5:
        number10[i] = 10;
      case 6:
        number10[i] = 1;

      default:
        break;
      };

      if c2 == d2 {
        if number10[i] > 5 {
          if c2 == 0 && d2 == 0 {
            c2 = 1;
            d2 = 1;
            a5 += 6 - (Int(number10[i]) - 6);
          } else {
            c2 = 0;
            d2 = 0;
            a5 += Int(number10[i]);
          }
        } else {
          if c2 == 0 && d2 == 0 {
            c2 = 1;
            a5 += Int(number10[i]);
          } else {
            c2 = 0
            a5 += Int(number10[i]);
          }
        }
      } else {
        if number10[i] > 5 {
          if c2 == 0 {
            c2 = 1;
            d2 = 0;
            a5 -= 6 + (Int(number10[i]) - 6);
          } else {
            c2 = 0;
            d2 = 1;
            a5 -= Int(number10[i]);
          }
        } else {
          if c2 == 0 {
            c2 = 1;
            a5 -= Int(number10[i]);
          } else {
            c2 = 0;
            a5 -= Int(number10[i]);
          }
        }
      }
      ++i;
    }

    while a5 < 0 || a5 > 4 {
      if a5 > 4 {
        a5 -= 5;
      } else {
        a5 += 5;
      }
    }

    if d2 == 0 {
      p = tab1[a5];
    } else {
      p = tab2[a5];
    }

    if p == number10[9] {
      return true;
    } else {
      if number10[3] == 0 {
        if p > 4 {
          p -= 5;
        } else {
          p += 5;
        }

        if p == number10[9] {
          return true;
        }
      }
    }

    return false;
  }

  private class func method93(number10: [UInt16]) -> Bool {
    for subMethod in ["93a", "93b", "93c", "93d"] {
      if let parameters = methodParameters[subMethod] {
        let checksum = pattern1(number10[parameters.indices.start...parameters.indices.stop],
          modulus: parameters.modulus, weights: parameters.weights,
          mappings: [.MapToZero, .MapToZero, .ReturnDifference], useDigitSum: false);
        if number10[parameters.indices.check] == checksum {
          return true;
        }
      }
    }

    return false;
  }

  private class func method5253(number: [UInt16], bankCode: String, modulus: UInt16, weights: [UInt16]) -> Bool {
    // Start with constructing the old ESER account number from the given parameters.
    // At most 12 digits long.
    switch number.count {
    case 8...9: // Standard computation only for 8 and 9 digits.
      break;
    case 10:
      if number[0] == 9 { // Use method "20" for these numbers.
        // Documentation is not clear here. Only use 20 with 52's params or with 20's params?
        if let parameters = methodParameters["20"] {
          let workSlice = number[parameters.indices.start...parameters.indices.stop];
          var checksum = pattern1(workSlice, modulus: parameters.modulus, weights: parameters.weights,
            mappings: [.MapToZero, .MapToZero, .ReturnDifference], useDigitSum: false);
          return number[parameters.indices.check] == checksum;
        } else {
          return false;
        }
      }
    default:
      return false;
    }

    // Code for method 52 and 53 differes only in handling for 8 and 9 digit account numbers.
    var temp = [UInt16](bankCode.utf16);
    var eserAccount: [UInt16] = [];
    for n in temp[temp.count - 4..<temp.count] {
      eserAccount.append(n - 48);
    }
    eserAccount.append(number[0]);
    eserAccount.append(0); // The existing checksum in number[1].
    var checkSumWeightIndex = eserAccount.count;
    
    var startFound = false;
    let startIndex = number.count == 8 ? 2 : 3;
    for n in number[startIndex..<number.count] {
      if !startFound && n == 0 {
        continue;
      }
      startFound = true;
      eserAccount.append(n);
    }
    checkSumWeightIndex = eserAccount.count - checkSumWeightIndex;
    
    // Compute standard remainder for the given modulus.
    var weightIndex = 0;
    var sum: UInt16 = 0;
    for digit in reverse(eserAccount) {
      sum += digit * weights[weightIndex++];
    }
    var remainder = sum % modulus;
    
    // Find the factor that makes the equation:
    //   (remainder + factor * weight-for-checksum) % 11
    // return 10. This factor is then the checksum.
    for factor in 0..<modulus {
      if (remainder + factor * weights[checkSumWeightIndex]) % 11 == 10 {
        // Factor found. Same as checksum?
        if factor == number[number.count == 8 ? 1 : 2] {
          return true;
        }
        break;
      }
    }
    return false;
  }

  /// Checks if we have a mapping for the given account/bank code pair.
  /// If so either account or bank code (or both) are replaced according to the mapping and true is returned.
  /// If there's no mapping then false is returned.
  internal class func checkSpecialAccount(inout account: String, inout bankCode: String) -> Bool {
    if let mappingTuple = mappings[bankCode.toInt()!] {
      // One or more mapping details. Take the first that applies.
      for entry in mappingTuple.details {
        if entry.rangeStart == 0 && entry.account == 0 {
          bankCode = String(entry.bankCode);
          return true;
        } else {
          if (entry.rangeStart == 0) || (entry.rangeStart...entry.rangeEnd ~= account.toInt()!) {
            if entry.account > 0 {
              account = String(entry.account);
            }
            if entry.bankCode > 0 {
              bankCode = String(entry.bankCode);
            }
            return true;
          }
        }
      }
    }
    return false;
  }

  /// In cases where we get a bank code which is no longer valid (and hence no longer in the official
  /// database) we may be able to get the new bank code from our internal mappings. This works howver
  /// only if we have an account cluster for the given old bank code. We can then see if there's at
  /// least one cluster for the same IBAN rule (so we ensure account and bank code belong together).
  class func bankCodeFromAccountCluster(account: Int, bankCode: Int) -> Int {
    if let mappingTuple = mappings[bankCode] {
      return bankCodeFromAccount(account, forRule: mappingTuple.rule)
    }

    return -1;
  }

  /// For some bank codes we have a mapping to a new bank code for a specific account range,
  /// not a generic one in the official database. This mapping totally depends on the account,
  /// not the original bank code.
  class func bankCodeFromAccount(account: Int, forRule rule: Int) -> Int {
    for mappingTuple in mappings {
      if mappingTuple.1.rule != rule {
        continue;
      }
      for entry in mappingTuple.1.details {
        if entry.rangeStart...entry.rangeEnd ~= account {
          return entry.bankCode;
        }
      }
    }

    return -1;
  }
  
}

