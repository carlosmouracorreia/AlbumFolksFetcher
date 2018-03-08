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
    
    var app : XCUIApplication! {
        didSet {
            app.launchArguments.append("--uitesting")
        }
    }
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        
        let ownStartTests = ["testSearchNoConnectionShowsPopup","testAlreadyOnSearch", "testAlreadyOnArtistAlbums"]
        
        //Tests that need to start the up on their on method (exame for command line arguments) don't require this
        if !ownStartTests.contains(where: { self.name.contains($0)}) {
        
            self.app = XCUIApplication()
            app.launch()
            self.goToSearch(app)
        }
      
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
    
    func testSearchNoConnectionShowsConnectionPopup() {
        
        //launch the app again so we cant send command line specific arguments
        self.app = XCUIApplication()
        app.launchArguments.append("-mockDisableConnection")
        app.launch()
        
        self.goToSearch(app)
        self.typeSearch(app, "What is the internet")
        
        let artistCell = app.tables.cells["ArtistCell"].firstMatch
        self.verifyResponseElementNotExist(app, element: artistCell)
        

        XCTAssert(self.app.alerts["AlertDialogConnection"].exists)
        
    }
    
    func testAlreadyOnSearch() {
        self.app = XCUIApplication()

        app.launchArguments.append("-UIPopulator")
        app.launchArguments.append("SearchArtistsVC")
        app.launch()
        
        XCTAssert(app.otherElements["SearchArtistsView"].exists)
    }
    
    func testAlreadyOnArtistAlbums() {
        self.app = XCUIApplication()
        app.launch()

        setClipboard("UIPopulator", value: "ArtistAlbumsVC")
        
        XCTAssert(app.otherElements["ArtistAlbumsView"].exists)
    }
}
