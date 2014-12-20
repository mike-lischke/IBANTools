//
//  DERules.swift
//  IBANtools
//
//  Created by Mike Lischke on 14.12.14.
//  Copyright (c) 2014 Mike Lischke. All rights reserved.
//

import Foundation

// BIAN conversion rules specific to Germany.

@objc(DERules)
private class DERules : IBANRules {

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
  }

  override class func initialize() {
    let bundle = NSBundle(forClass: DERules.self);
    let resourcePath = bundle.pathForResource("bank_codes", ofType: "txt", inDirectory: "de");
    if resourcePath != nil && NSFileManager.defaultManager().fileExistsAtPath(resourcePath!) {
      let content = NSString(contentsOfFile: resourcePath!, encoding: NSUTF8StringEncoding, error: nil);
      if content != nil {
        // Extract bank code mappings.
        for line in content!.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()) {
          if line.length < 168 {
            continue; // Not a valid line.
          }

          let s: NSString = line as NSString;
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

          if line.length > 168 {
            // Extended bank code file.
            entry.rule = line.substringWithRange(NSMakeRange(168, 4)).toInt()!;
            entry.ruleVersion = line.substringWithRange(NSMakeRange(172, 2)).toInt()!;
          }
          Static.institutes[bankCode!] = entry;
        }
      }
    }
  }

  override class func convertToIBAN(inout account: String, inout _ bankCode: String) -> String? {
    let bank = bankCode.toInt();
    var rule = 0;
    var version = 0;
    if bank != nil {
      if let institute = Static.institutes[bank!] {
        // Replace bank code by new one if there's one.
        if institute.isDeleted {
          return "";
        }

        if institute.replacement > 0 {
          bankCode = String(institute.replacement);
        }

        rule = institute.rule;
        version = institute.ruleVersion;
      }
    }

    switch bankCode {
    case "720207001":
      return rule2(&account, version);

    case "10010424": fallthrough
    case "20010424": fallthrough
    case "36010424": fallthrough
    case "50010424": fallthrough
    case "51010400": fallthrough
    case "51010800": fallthrough
    case "55010400": fallthrough
    case "55010424": fallthrough
    case "55010625": fallthrough
    case "60010424": fallthrough
    case "70010424": fallthrough
    case "86010424": // Aareal Bank AG
      return rule3(&account, version);

    case "10050000": fallthrough
    case "10050005": fallthrough
    case "10050006": fallthrough
    case "10050007":
      return rule4(&account, version);

    default:
      break;
    }

    return nil;
  }

  private class func rule0(inout account: String, _ version: Int) -> String? {
    return nil; // Use default rule.
  }

  private class func rule1(inout account: String, _ version: Int) -> String? {
    return ""; // Account or bank code not used in payments (anymore).
  }

  // Augsburger Aktienbank
  private class func rule2(inout account: String, _ version: Int) -> String? {
    // No IBANs for nnnnnnn86n and nnnnnnn6nn.
    if account[advance(account.endIndex, -3)] == "6" {
      return "";
    }

    if (account[advance(account.endIndex, -2)] == "6") && (account[advance(account.endIndex, -3)] == "8") {
      return "";
    }

    return nil; // nil for: use default rule.
  }

  private class func rule3(inout account: String, _ version: Int) -> String? {
    if account == "6161604670" {
      return "";
    }

    return nil;
  }

  // Landesbank Berlin / Berliner Sparkasse
  private class func rule4(inout account: String, _ version: Int) -> String? {
    switch account {
    case "135":
      account = "0990021440";
    case "1111":
      account = "6600012020";
    case "1900":
      account = "0920019005";
    case "7878":
      account = "0780008006";
    case "8888":
      account = "0250030942";
    case "9595":
      account = "1653524703";
    case "97097":
      account = "0013044150";
    case "112233":
      account = "0630025819";
    case "336666":
      account = "6604058903";
    case "484848":
      account = "0920018963";
    default:
      return nil;
    }
    return nil;
  }

  // Commerzbank AG
  private class func rule0005(bankCode: String, inout account: String, _ version: Int) -> String? {
    let code = bankCode.toInt()!;
    let number = account.toInt()!;

    // For certain bank codes a specific range of account numbers are closed off and not
    // available for IBAN calculations. Certain other's are generally not used.
    let bankCodes1: [Int: Int] = [ // Dict used as set.
      10080900: 0, 25780022: 0, 42080082: 0, 53080030: 0,
      64380011: 0, 79080052: 0, 12080000: 0, 25980027: 0,
      42680081: 0, 54080021: 0, 65080009: 0, 79380051: 0,
      13080000: 0, 26080024: 0, 43080083: 0, 54280023: 0,
      65180005: 0, 79580099: 0, 14080000: 0, 26281420: 0,
      44080055: 0, 54580020: 0, 65380003: 0, 80080000: 0,
      15080000: 0, 26580070: 0, 44080057: 0, 54680022: 0,
      66280053: 0, 81080000: 0, 16080000: 0, 26880063: 0,
      44580070: 0, 55080065: 0, 66680013: 0, 82080000: 0,
      17080000: 0, 26981062: 0, 45080060: 0, 57080070: 0,
      67280051: 0, 83080000: 0, 18080000: 0, 28280012: 0,
      46080010: 0, 58580074: 0, 69280035: 0, 84080000: 0,
      20080055: 0, 29280011: 0, 47880031: 0, 59080090: 0,
      70080056: 0, 85080200: 0, 20080057: 0, 30080055: 0,
      49080025: 0, 60080055: 0, 70080057: 0, 86080055: 0,
      21080050: 0, 30080057: 0, 50080055: 0, 60080057: 0,
      70380006: 0, 86080057: 0, 21280002: 0, 31080015: 0,
      50080057: 0, 60380002: 0, 71180005: 0, 87080000: 0,
      21480003: 0, 32080010: 0, 50080081: 0, 60480008: 0,
      72180002: 0, 21580000: 0, 33080030: 0, 50080082: 0,
      61080006: 0, 73180011: 0, 22180000: 0, 34080031: 0,
      50680002: 0, 61281007: 0, 73380004: 0, 22181400: 0,
      34280032: 0, 50780006: 0, 61480001: 0, 73480013: 0,
      22280000: 0, 36280071: 0, 50880050: 0, 62080012: 0,
      74180009: 0, 24080000: 0, 36580072: 0, 51080000: 0,
      62280012: 0, 74380007: 0, 24180001: 0, 40080040: 0,
      51380040: 0, 63080015: 0, 75080003: 0, 25480021: 0,
      41280043: 0, 52080080: 0, 64080014: 0, 76080053: 0
    ];

    let bankCodes2: [Int: Int] = [
      10045050: 0, 50040033: 0, 70045050: 0, 10040085: 0,
      35040085: 0, 36040085: 0, 44040085: 0, 50040085: 0,
      67040085: 0, 82040085: 0
    ];

    if (bankCodes1[code] != nil && number >= 998000000 && number <= 999499999)
      || (bankCodes2[code] != nil) {
      return "";
    }

    // Special account numbers. Convert to real ones.
    let mappings: [Int: (Int, Int)] = [ // bank code: pseudo account, real account
      30040000: (0000000036, 0002611036), 47880031: (0000000050, 0519899900),
      47840065: (0000000050, 0001501030), 47840065: (0000000055, 0001501030),
      70080000: (0000000094, 0928553201), 70040041: (0000000094, 0002128080),
      47840065: (0000000099, 0001501030), 37080040: (0000000100, 0269100000),
      38040007: (0000000100, 0001191600), 37080040: (0000000111, 0215022000),
      51080060: (0000000123, 0012299300), 36040039: (0000000150, 0001616200),
      68080030: (0000000202, 0416520200), 30040000: (0000000222, 0348010002),
      38040007: (0000000240, 0001090240), 69240075: (0000000444, 0004455200),
      60080000: (0000000502, 0901581400), 60040071: (0000000502, 0005259502),
      55040022: (0000000555, 0002110500), 39080005: (0000000556, 0204655600),
      39040013: (0000000556, 0001065556), 57080070: (0000000661, 0604101200),
      26580070: (0000000700, 0710000000), 50640015: (0000000777, 0002222222),
      30040000: (0000000999, 0001237999), 86080000: (0000001212, 0480375900),
      37040044: (0000001888, 0212129101), 25040066: (0000001919, 0001419191),
      10080000: (0000001987, 0928127700), 50040000: (0000002000, 0007284003),
      20080000: (0000002222, 0903927200), 38040007: (0000003366, 0003853330),
      37080040: (0000004004, 0233533500), 37080040: (0000004444, 0233000300),
      43080083: (0000004630, 0825110100), 50080000: (0000006060, 0096736100),
      10040000: (0000007878, 0002678787), 10080000: (0000008888, 0928126501),
      50080000: (0000009000, 0026492100), 79080052: (0000009696, 0300021700),
      79040047: (0000009696, 0006802102), 39080005: (0000009800, 0208457000),
      50080000: (0000042195, 0900333200), 32040024: (0000047800, 0001555150),
      37080040: (0000055555, 0263602501), 38040007: (0000055555, 0003055555),
      50080000: (0000101010, 0090003500), 50040000: (0000101010, 0003110111),
      37040044: (0000102030, 0002223444), 86080000: (0000121200, 0480375900),
      66280053: (0000121212, 0625242400), 16080000: (0000123456, 0012345600),
      29080010: (0000124124, 0107502000), 37080040: (0000182002, 0216603302),
      12080000: (0000212121, 4050462200), 37080040: (0000300000, 0983307900),
      37040044: (0000300000, 0003000007), 37080040: (0000333333, 0270330000),
      38040007: (0000336666, 0001052323), 55040022: (0000343434, 0002179000),
      85080000: (0000400000, 0459488501), 37080040: (0000414141, 0041414100),
      38040007: (0000414141, 0001080001), 20080000: (0000505050, 0500100600),
      37080040: (0000555666, 0055566600), 20080000: (0000666666, 0900732500),
      30080000: (0000700000, 0800005000), 70080000: (0000700000, 0750055500),
      70080000: (0000900000, 0319966601), 37080040: (0000909090, 0269100000),
      38040007: (0000909090, 0001191600), 70080000: (0000949494, 0575757500),
      70080000: (0001111111, 0448060000), 70040041: (0001111111, 0001521400),
      10080000: (0001234567, 0920192001), 38040007: (0001555555, 0002582666),
      76040061: (0002500000, 0004821468), 16080000: (0003030400, 4205227110),
      37080040: (0005555500, 0263602501), 75040062: (0006008833, 0600883300),
      12080000: (0007654321, 0144000700), 70080000: (0007777777, 0443540000),
      70040041: (0007777777, 0002136000), 64140036: (0008907339, 0890733900),
      70080000: (0009000000, 0319966601), 61080006: (0009999999, 0202427500),
      12080000: (0012121212, 4101725100), 29080010: (0012412400, 0107502000),
      34280032: (0014111935, 0645753800), 38040007: (0043434343, 0001181635),
      30080000: (0070000000, 0800005000), 70080000: (0070000000, 0750055500),
      44040037: (0111111111, 0003205655), 70040041: (0400500500, 0004005005),
      60080000: (0500500500, 0901581400), 60040071: (0500500500, 0005127006)
    ];

    if let entry = mappings[code]? {
        if entry.0 == number {
          account = String(entry.1);
        }
    }
    return nil;
  }
  
}