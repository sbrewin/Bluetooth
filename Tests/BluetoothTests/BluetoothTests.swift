//
//  BluetoothTests.swift
//  Bluetooth
//
//  Created by Alsey Coleman Miller on 11/28/17.
//  Copyright © 2017 PureSwift. All rights reserved.
//

import XCTest
import Foundation
@testable import Bluetooth

final class BluetoothTests: XCTestCase {
    
    static let allTests = [
        ("testAddress", testAddress),
        ("testDataParsing", testDataParsing)
        ]
    
    func testAddress() {
        
        let addressString = "00:1A:7D:DA:71:13"
        //59:80:ED:81:EE:35
        //AC:BC:32:A6:67:42
        let addressBytes: Address.ByteValue = (0x00, 0x1A, 0x7D, 0xDA, 0x71, 0x13)
        
        guard let address = Address(rawValue: addressString)
            else { XCTFail("Could not parse"); return }
        
        XCTAssert(address.rawValue == addressString, "\(address.rawValue)")
        
        XCTAssert(address == Address(bigEndian: Address(bytes: addressBytes)))
    }
    
    func testDataParsing() {
        
        func parseAdvertisingReport(_ readBytes: Int, _ data: [UInt8]) -> [Address] {
            
            let eventData = Array(data[3 ..< readBytes])
            
            guard let meta = HCIGeneralEvent.LowEnergyMetaParameter(byteValue: eventData),
                let lowEnergyEvent = LowEnergyEvent(rawValue: meta.subevent)
                else { XCTFail("Could not parse"); return [] }
            
            XCTAssert(lowEnergyEvent == .advertisingReport, "Invalid event type \(lowEnergyEvent)")
            
            guard let advertisingReport = LowEnergyEvent.AdvertisingReportEventParameter(byteValue: meta.data)
                else { XCTFail("Could not parse"); return [] }
            
            return advertisingReport.reports.map { $0.address }
        }
        
        do {
            
            let readBytes = 26
            let data: [UInt8] = [4, 62, 23, 2, 1, 0, 0, 66, 103, 166, 50, 188, 172, 11, 2, 1, 6, 7, 255, 76, 0, 16, 2, 11, 0, 186, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
            
            XCTAssert(parseAdvertisingReport(readBytes, data) == [Address(rawValue: "AC:BC:32:A6:67:42")!])
        }
        
        do {
            
            let readBytes = 38
            let data: [UInt8] = [4, 62, 35, 2, 1, 0, 1, 53, 238, 129, 237, 128, 89, 23, 2, 1, 6, 19, 255, 76, 0, 12, 14, 8, 69, 6, 92, 128, 96, 83, 24, 163, 199, 32, 154, 91, 3, 191, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
            
            XCTAssert(parseAdvertisingReport(readBytes, data) == [Address(rawValue: "59:80:ED:81:EE:35")!])
        }
    }
}
