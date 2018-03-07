//
//  AlbumFolksUITests.swift
//  AlbumFolksUITests
//
//  Created by Carlos Correia on 01/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import XCTest

class ActivateAppTests: XCTestCase {
    
    //weirdly, works the same as if initialized in the setUp function, I prefer to keep it here
    lazy var app : XCUIApplication = {
       let app = XCUIApplication()
        
        app.launchArguments.append("--uitesting")
        app.activate()
        
        return app
    }()
        
    override func setUp() {
        super.setUp()

        // In UI tests it is usually best to stop immediately when a failure occurs. - actually this bool is not working for activation methodology.
        continueAfterFailure = false
      
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    func test1_InvalidSearchReturnsNoResults() {
        
        self.goToSearch(app)
        self.typeSearch(app, "_123_n0t_ex1st")

        let artistCell = app.tables.cells["ArtistCell"].firstMatch
        self.verifyResponseElementNotExist(app, element: artistCell)

    }
    

    func test2_VerifyArtistCellOnSearch() {
        
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
    
    func test3_ArtistAlbumsHaveBasicArtistInfo() {
        self.goToArtistAlbums(app, searchQuery: "Elliott Smith", launching: false)
    }
    
}
