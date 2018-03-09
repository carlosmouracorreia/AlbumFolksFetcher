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
    fileprivate func removeItems(){
        
        if #available(iOS 10.0, *) {
            UIPasteboard.general.setItems([[:]], options: [:])
        } else {
            UIPasteboard.general.items = [[:]]
        }
    }
    
    /**
     SET CLIPBOARD
     */
    public func setClipboard(_ key: String, value: Any) {
        
        removeItems()
        
        var newItems = [[String:Any]]()
        
        newItems.append([key:value])
        UIPasteboard.general.addItems(newItems)
        
    }

