//
//  ContinentalTests.swift
//  ContinentalTests
//
//  Created by Bruno Scheele on 29/10/15.
//  Copyright © 2015 Noodlewerk Apps. All rights reserved.
//

import XCTest
@testable import Continental

class ContinentalTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        XCTAssert(continentCodeForCountryCode("NL") == "EU")
    }
}
