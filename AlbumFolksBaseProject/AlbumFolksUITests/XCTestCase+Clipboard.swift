//
//  UIPasteboardHelpers.swift
//  AlbumFolks
//
//  Created by Carlos Correia on 08/03/2018.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

//Examples Taken from this pod: http://cocoapods.org/pods/BDTests

import XCTest


    /**
     Removes all tests. Removes:stubs, pasteboards
     
     - return: none
     */
    fileprivate func removeTest(){
        
        let currentItems = UIPasteboard.general.items
        var newItems = [[String:Any]]()
        for item in currentItems{
            if let _ = item["data"] {
                
            }else{
                newItems.append(item)
            }
        }
        if #available(iOS 10.0, *) {
            UIPasteboard.general.setItems([[:]], options: [:])
        } else {
            UIPasteboard.general.items = [[:]]
        }
        UIPasteboard.general.addItems(newItems)
    }
    
    /**
     SET CLIPBOARD
     */
    public func setClipboard(_ key: String, value: Any) {
        
        removeTest()
        
        var newItems = [[String:Any]]()
        
        newItems.append(["key":value])
        UIPasteboard.general.addItems(newItems)
        
    }

