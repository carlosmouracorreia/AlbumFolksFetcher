//
//  Helpers.swift
//  AlbumFolksUITests
//
//  Created by af on 07.03.18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import XCTest

extension XCTestCase {
    
    internal func goToArtistAlbums(_ app: XCUIApplication, searchQuery: String, launching: Bool = true) {
        
        XCTContext.runActivity(named: "GoToArtistAlbums", block: { _ in
            
            let artistCell = app.tables.cells["ArtistCell"].firstMatch

            if launching {
                
                self.typeSearch(app, searchQuery)
                self.verifyResponseElementExist(app, element: artistCell)
            }
            
            artistCell.tap()
        })
    }
    
    
    internal func goToSearch(_ app: XCUIApplication) {
        
        XCTContext.runActivity(named: "EnterSearch", block: { _ in
            app.navigationBars["AlbumFolks"].buttons["Search"].firstMatch.tap()
        })
    }
    
    internal func typeSearch(_ app: XCUIApplication, _ searchText: String) {
        
        XCTContext.runActivity(named: "TypeSearch", block: { _ in
            
            
            let searchSearchField = app.navigationBars["AlbumFolks.SearchArtistsVC"].searchFields["Search"]
            searchSearchField.clearAndEnterText(searchText)
            
            guard let text = searchSearchField.value as? String else {
                return
            }
            
            let searchExpectation = XCTNSPredicateExpectation(predicate: NSPredicate(format: "%@ == %@", searchText, text), object: app)
            //more than enough time for the user to finish searching
            wait(for: [searchExpectation], timeout: 2)
        })
        
    }
    
    internal func verifyResponseElementExist(_ app: XCUIApplication, element: XCUIElement, timeout: TimeInterval = 10) {
        
        XCTContext.runActivity(named: "VerifyResponseElementExist", block: { _ in
            
            let artistNameExpectation = XCTNSPredicateExpectation(predicate: NSPredicate(format: "true == %@", NSNumber(value: element.exists)), object: app)
            
            //time for network call
            wait(for: [artistNameExpectation], timeout: timeout)
        })
    }
    
    
    internal func verifyResponseElementNotExist(_ app: XCUIApplication, element: XCUIElement, timeout: TimeInterval = 10) {
        
        XCTContext.runActivity(named: "VerifyResponseElementDoesntExist", block: { _ in
            
            let artistNameExpectation = XCTNSPredicateExpectation(predicate: NSPredicate(format: "false == %@", NSNumber(value: element.exists)), object: app)
            
            //time for network call
            wait(for: [artistNameExpectation], timeout: timeout)
        })
    }

}
