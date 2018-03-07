//
//  LaunchAppTests.swift
//  AlbumFolksUITests
//
//  Created by af on 07.03.18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

//
//  AlbumFolksUITests.swift
//  AlbumFolksUITests
//
//  Created by Carlos Correia on 01/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import XCTest

class LaunchAppTests: XCTestCase {
    
    var app : XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        self.app = XCUIApplication()
        app.launch()
        
        self.goToSearch(app)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    func testVerifyArtistCellOnSearch() {
        
        self.typeSearch(app, "King Gizzard")
        
        XCTContext.runActivity(named: "VerifyArtistCellOnSearch", block: { activity in
            
            let artistCell = app.tables.cells["ArtistCell"].firstMatch
            
            self.verifyResponseElementExist(app, element: artistCell)
            
            let cellAttachment = XCTAttachment(screenshot: artistCell.screenshot())
            cellAttachment.lifetime = .keepAlways
            activity.add(cellAttachment)
            
            // TODO: do more validation here
            
        })
        
        
    }
    
    func testArtistAlbumsHaveBasicArtistInfo() {
        self.goToArtistAlbums(app, searchQuery: "Elliott Smith", launching: true)
    }
    
}
