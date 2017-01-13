//
//  JChanTests.swift
//  JChanTests
//
//  Created by John Estropia on 2016/09/14.
//  Copyright © 2016年 eureka, Inc. All rights reserved.
//

import XCTest
@testable import JChan

class JChanTests: XCTestCase {
    
    func test_ThatJChanLiterals_Work() {
        
        let jchan: JChan = [
            "a": 1,
            "b": 2,
            "c": [3, 4, 5.5],
            "d": ["e": true, "f": ["g": [false, true, false], "h": 6.78]]
        ]
        let jchan2: JChan = [
            "a": 1,
            "b": 2,
            "c": [3, 4, 5.5],
            "d": ["e": true, "f": ["g": [false, true, false], "h": 6.78]]
        ]
        let dummy: NSDictionary = [
            "a": 1,
            "b": 2,
            "c": [3, 4, 5.5],
            "d": ["e": true, "f": ["g": [false, true, false], "h": 6.78]]
        ]
        XCTAssertTrue(jchan.reference is NSDictionary)
        XCTAssertTrue(jchan.reference as! NSDictionary == jchan2.reference as! NSDictionary)
        XCTAssertTrue((jchan.reference as! NSDictionary).isEqual(dummy))
        print(type(of: ((jchan.reference as! NSDictionary)["c"] as! NSArray)[0]))
        print(type(of: (dummy["c"] as! NSArray)[0]))
        
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
