//
//  AlbumFolksEarlGreyTests.swift
//  AlbumFolksEarlGreyTests
//
//  Created by Carlos Correia on 08/03/2018.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import XCTest
import EarlGrey

class AlbumFolksEarlGreyTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
  
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        //let vc = storyboard.instantiateViewController(withIdentifier: "AlbumVCTestEntrance") as! AlbumVC
        //_ = vc.view
        
        EarlGrey.select(elementWithMatcher: grey_keyWindow())
            .assert(grey_sufficientlyVisible())
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
