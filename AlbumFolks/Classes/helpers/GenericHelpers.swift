//
//  Generic.swift
//  AlbumFolks
//
//  Created by NTW-laptop on 06/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import Foundation

class GenericHelpers {
    class func mainQueueDelay(_ delay: Double, closure: @escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }


    class func getBundle() -> Bundle? {
    	let podBundle = Bundle(for: GenericHelpers.self)        
        if let bundleURL = podBundle.url(forResource: "AlbumFolks", withExtension: "bundle") {         
            if let bundle = Bundle(url: bundleURL) {
               return bundle   
            }    
        }

        assertionFailure("Could not create a path to the bundle")
        fatalError()
        
    }
}

extension UIImage {
    
    convenience init?(named_pod: String) {
        self.init(named: named_pod, in: GenericHelpers.getBundle(), compatibleWith: nil)
    }
}
