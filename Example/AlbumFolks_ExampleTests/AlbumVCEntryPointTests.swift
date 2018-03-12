//
//  AlbumVCEntryPointTests.swift
//  AlbumFolksTests
//
//  Created by Carlos Correia on 07/03/2018.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import XCTest
@testable import AlbumFolks

class AlbumVCEntryPointTests: XCTestCase {
    
    
    var volatileAlbum : Album?
    var albumVC: AlbumVC!
    
    
    /**
     * In order to emulate app main functionality (see the stored album information) we need:
     1. A testing database clone - "context with new persistent store"
     2. A mocked album - instead of coming from the API or creating a mock object for network response I injected the JSON data directly from a file
     3. A testing ViewController - added a Storyboard ID to the Album VC for this purpose (it didn't needed it beforehand)
     
     
     Furthermore, the following tests follow the normal user journey on the app (omitting the process of album search and album click) i.e, visualizing an album coming from the API, saving it, and later consulting a saved album.
     **/
    override func setUp() {
        super.setUp()
        
        volatileAlbum = DeserializeHelpers.getTestAlbumFromJSONFile(testObj: self)
        
        let storyboard = UIStoryboard(name: "Main", bundle: GenericHelpers.getBundle())
        let vc = storyboard.instantiateViewController(withIdentifier: "AlbumVCTestEntrance") as! AlbumVC
        albumVC = vc
        
    }
    
    override func tearDown() {
        self.albumVC = nil
        super.tearDown()
    }
    
    /**
     * Test that an object with the same serialized structure as if it was coming from the API will be correctly validated and accepted by the instance models (Artist, Album, AlbumDetail)
     **/
    func testLoadVolatileAlbum() {
        XCTAssertNotNil(volatileAlbum)
    }
    
    
    /**
     * Test that the object transformation preserved the required attributes to show on a view
     **/
    func testAlbumViewPopulatorPropertiesFromVolatile() {
        guard let album = volatileAlbum else {
            XCTFail()
            return
        }
        
        let populator = AlbumViewPopulator(album: album)
        
        guard let detail = volatileAlbum?.albumDetail else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(String(album.hashValue), populator.hashString)
        XCTAssertEqual(album.artist.mbid, populator.artist.mbid)
        XCTAssertEqual(album.name, populator.name)
        XCTAssertEqual(detail.getTagsString(), populator.tags)
        XCTAssertEqual(detail.tracks.count, populator.tracks.count)
    }
    
    
    /**
     * Test that the view actually is showing to the user the same elements from the AlbumViewPopulator
     **/
    func testPopulateVCwithVolatileAlbum() {
        guard let album = volatileAlbum else {
            XCTFail()
            return
        }
        
        let populator = AlbumViewPopulator(album: album)
        albumVC.albumViewPopulator = populator
        _ = albumVC.view
        
        XCTAssertEqual(albumVC.albumInfoHeader.albumArtist.text ?? "", populator.artist.name)
        XCTAssertEqual(albumVC.navigationItem.title ?? "", populator.name)
        XCTAssertEqual(albumVC.tableView.numberOfRows(inSection: 0), populator.tracks.count)
        
    }
}
