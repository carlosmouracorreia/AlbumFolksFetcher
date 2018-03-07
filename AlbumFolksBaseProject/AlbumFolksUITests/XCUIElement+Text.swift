//
//  XCUIElement+Text.swift
//  AlbumFolksUITests
//
//  Created by af on 07.03.18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import XCTest

extension XCUIElement {
    /**
     Taken from: https://stackoverflow.com/questions/32821880/ui-test-deleting-text-in-text-field
     Removes any current text in the field before typing in the new value
     - Parameter text: the text to enter into the field
     */
    func clearAndEnterText(_ text: String) {
        
        guard let stringValue = self.value as? String else {
            self.typeText(text)
            return
        }
        
        var deleteString = String()
        for _ in stringValue {
            deleteString += XCUIKeyboardKey.delete.rawValue
        }
        self.typeText(deleteString)
        self.typeText(text)
    }
}
