//
//  IBANtoolsDETests.swift
//  IBANtools
//
//  Created by Mike Lischke on 14.12.14.
//  Copyright (c) 2014 Mike Lischke. All rights reserved.
//

import Cocoa
import XCTest
import IBANtools

class IBANtoolsDETests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

  func testDefault() {
    XCTAssertEqual(IBANtools.convertToIBAN("532013018", bankCode: "100 900 44", countryCode: "DE"), "DE10100900440532013018", "Default 1");

    // Bank codes with replacements.
    XCTAssertEqual(IBANtools.convertToIBAN("12345", bankCode: "100 601 98", countryCode: "DE"), "DE70370601930000012345", "Default 1");
    XCTAssertEqual(IBANtools.convertToIBAN("12345", bankCode: "   1  3 0 6 1 0 8 8   ", countryCode: "DE"), "DE23130610780000012345", "Default 1");
    XCTAssertEqual(IBANtools.convertToIBAN("12345", bankCode: "82060800", countryCode: "DE"), "DE15520604100000012345", "Default 1");
  }

  func testRule2() {
    XCTAssertEqual(IBANtools.convertToIBAN("532013018", bankCode: "72020700", countryCode: "dE"), "DE09720207000532013018", "1");
    XCTAssertEqual(IBANtools.convertToIBAN("12345", bankCode: "720207001", countryCode: "de"), "DE637202070010000012345", "2");
    XCTAssertEqual(IBANtools.convertToIBAN("12645", bankCode: "720207001", countryCode: "de"), "", "3");
    XCTAssertEqual(IBANtools.convertToIBAN("12865", bankCode: "720207001", countryCode: "de"), "", "4");
  }

  func testRule3() {
    XCTAssertEqual(IBANtools.convertToIBAN("12345", bankCode: "10010424", countryCode: "de"), "DE77100104240000012345", "1");
    XCTAssertEqual(IBANtools.convertToIBAN("12345", bankCode: "20010424", countryCode: "de"), "DE21200104240000012345", "2");
    XCTAssertEqual(IBANtools.convertToIBAN("12345", bankCode: "36010424", countryCode: "de"), "DE09360104240000012345", "3");
    XCTAssertEqual(IBANtools.convertToIBAN("12345", bankCode: "50010424", countryCode: "de"), "DE47500104240000012345", "4");
    XCTAssertEqual(IBANtools.convertToIBAN("12345", bankCode: "51010400", countryCode: "de"), "DE55510104000000012345", "5");
    XCTAssertEqual(IBANtools.convertToIBAN("12345", bankCode: "51010800", countryCode: "de"), "DE87510108000000012345", "6");
    XCTAssertEqual(IBANtools.convertToIBAN("12345", bankCode: "55010400", countryCode: "de"), "DE52550104000000012345", "7");
    XCTAssertEqual(IBANtools.convertToIBAN("12345", bankCode: "55010424", countryCode: "de"), "DE19550104240000012345", "8");
    XCTAssertEqual(IBANtools.convertToIBAN("12345", bankCode: "55010625", countryCode: "de"), "DE70550106250000012345", "9");
    XCTAssertEqual(IBANtools.convertToIBAN("12345", bankCode: "60010424", countryCode: "de"), "DE88600104240000012345", "10");
    XCTAssertEqual(IBANtools.convertToIBAN("12345", bankCode: "70010424", countryCode: "de"), "DE32700104240000012345", "11");
    XCTAssertEqual(IBANtools.convertToIBAN("12345", bankCode: "86010424", countryCode: "de"), "DE20860104240000012345", "12");

    XCTAssertEqual(IBANtools.convertToIBAN("6161604670", bankCode: "10010424", countryCode: "de"), "", "1");
    XCTAssertEqual(IBANtools.convertToIBAN("6161604670", bankCode: "20010424", countryCode: "de"), "", "2");
    XCTAssertEqual(IBANtools.convertToIBAN("6161604670", bankCode: "36010424", countryCode: "de"), "", "3");
    XCTAssertEqual(IBANtools.convertToIBAN("6161604670", bankCode: "50010424", countryCode: "de"), "", "4");
    XCTAssertEqual(IBANtools.convertToIBAN("6161604670", bankCode: "51010400", countryCode: "de"), "", "5");
    XCTAssertEqual(IBANtools.convertToIBAN("6161604670", bankCode: "51010800", countryCode: "de"), "", "6");
    XCTAssertEqual(IBANtools.convertToIBAN("6161604670", bankCode: "55010400", countryCode: "de"), "", "7");
    XCTAssertEqual(IBANtools.convertToIBAN("6161604670", bankCode: "55010424", countryCode: "de"), "", "8");
    XCTAssertEqual(IBANtools.convertToIBAN("6161604670", bankCode: "55010625", countryCode: "de"), "", "9");
    XCTAssertEqual(IBANtools.convertToIBAN("6161604670", bankCode: "60010424", countryCode: "de"), "", "10");
    XCTAssertEqual(IBANtools.convertToIBAN("6161604670", bankCode: "70010424", countryCode: "de"), "", "11");
    XCTAssertEqual(IBANtools.convertToIBAN("6161604670", bankCode: "86010424", countryCode: "de"), "", "12");
  }

  func testRule4() {
    /*
    26580070 732502200 DRESDEFF265 DE32265800700732502200 Standard
    26580070 7325022 DRESDEFF265 DE32265800700732502200 verschobenes Konto
    26580070 8732502200 DRESDEFF265 DE60265800708732502200 gültige Kontoart
    26580070 4820379900 DRESDEFF265 DE37265800704820379900 gültige Kontoart
    50080000 1814706100 ungültig Kontoart
    50080000 2814706100 ungültig Kontoart
    50080000 3814706100 ungültig Kontoart
    50080000 4814706100 DRESDEFFXXX DE70500800004814706100 gültige Kontoart
    50080000 5814706100 ungültig Kontoart
    50080000 6814706100 DRESDEFFXXX DE77500800006814706100 gültige Kontoart
    50080000 7814706100 DRESDEFFXXX DE32500800007814706100 gültige Kontoart
    50080000 8814706100 DRESDEFFXXX DE84500800008814706100 gültige Kontoart
    50080000 9814706100 DRESDEFFXXX DE39500800009814706100 gültige Kontoart
    50080000 23165400 DRESDEFFXXX DE42500800000023165400 gültige 6-stellige StammNr
    50080000 231654 DRESDEFFXXX DE42500800000023165400 verschobene 6-stellige St.Nr
    50080000 4350300 DRESDEFFXXX DE21500800000004350300 gültige 5-stellige StammNr
    50080000 43503 DRESDEFFXXX DE21500800000004350300 verschobene 5-stellige St.Nr
    50080000 526400 DRESDEFFXXX ungültig 4-stellige St.Nr
    50089400 526400 DRESDEFFI01 DE49500894000000526400 4-stellige St.Nr, o. PZiffer
    10080000 998761700 DRESDEFF100 D E73100800000998761700 gültiges IT-Konto
    12080000 998761700 gesperrte BLZ/ITKonto
    26580070 43434280 DRESDEFF265 Prüfziffer 10 unzulässig
    26580070 343428000 DRESDEFF265 Prüfziff 10 geschoben unzul.
    26580070 99021000 DRESDEFF265 DE10265800709902100000 Prüfziffer 0 geschoben
    50540028 4217386 COBADEFFXXX DE24505400280421738600 verschobenes Konto
    50540028 4217387 verschoben falsche PZ
    72040046 111198800 COBADEFFXXX DE10720400460111198800 Standard
    72040046 111198700 falsche Prüfziffer
    50540028 420086100 COBADEFFXXX DE46505400280420086100 Standard
    50540028 421573704 COBADEFFXXX DE13505400280421573704 Standard mit U-Kto
    50540028 421679200 COBADEFFXXX DE26505400280421679200 Standard
    65440087 130023500 COBADEFFXXX DE63654400870130023500 Standard
    23040022 104414 COBADEFFXXX DE29230400220010441400 verschobene 6-stellige St.Nr
    23040022 104417 6-stellige St.Nr falsche PZ
    12040000 40050700 COBADEFFXXX DE27120400000040050700 Standard
    23040022 101337 COBADEFFXXX DE73230400220010133700 verschobene 6-stellige St.Nr
    23040022 10503101 COBADEFFXXX DE77230400220010503101 gültige 6-stellige StammNr
    12040000 52065002 COBADEFFXXX DE12120400000052065002 gültige 6-stellige StammNr
    50040000 930125001 COBADEFFXXX DE97500400000930125001 Standard
    70040041 930125000 COBADEFFXXX DE89700400410930125000 Standard
    50040000 930125006 COBADEFFXXX DE59500400000930125006 Standard
    10045050 930125001 gesperrte BLZ
    50040033 930125004 gesperrte BLZ
    70045050 930125007 gesperrte BLZ
    20041111 130023500 COBADEHDXXX DE81200411110130023500 comdirect
    37080040 111 DRESDEFF370 DE69370800400215022000 Spendenkontonummer
    50040000 101010 COBADEFFXXX DE46500400000311011100 Spendenkontonummer
    */
  }

  func testRule5() {
  }

  func testRule6() {
  }

  func testRule7() {
  }

  func testRule8() {
  }

  func testRule9() {
  }

  func testRule10() {
  }

  func testRule11() {
  }

  func testRule12() {
  }

  func testRule13() {
  }

  func testRule14() {
  }

  func testRule15() {
  }

  func testRule16() {
  }

  func testRule17() {
  }

  func testRule18() {
  }

  func testRule19() {
  }

  func testRule20() {
  }

  func testRule21() {
  }

  func testRule22() {
  }

  func testRule23() {
  }

  func testRule24() {
  }

  func testRule25() {
  }
}