//
//  AppDelegate.swift
//  AlbumFolks
//
//  Created by Carlos Correia on 01/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    fileprivate var pasteBoardChangeCount = UIPasteboard.general.changeCount

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
        let x = ArtistAlbumsVC.UIPopulator.self
        let y = SearchArtistsVC.UIPopulator.self
        
        UserDefaults.standard.set(true, forKey: "connection")
        
        if CommandLine.arguments.contains("--uitesting") {
            
            if CommandLine.arguments.contains("-mockDisableConnection") {
                UserDefaults.standard.set(false, forKey: "connection")
            }
            
            var controllerToGo : String?
            
            if CommandLine.arguments.contains("-UIPopulator"), let index = CommandLine.arguments.index(of: "-UIPopulator"), let afterIndex = CommandLine.arguments.index(index, offsetBy: 1, limitedBy: 0) {
                controllerToGo = CommandLine.arguments[afterIndex]
            } else {
                controllerToGo = UIPasteboard.general.string
            }
            
            if let controllerToGo = controllerToGo {
                self.changeController(byStringIdentifier: controllerToGo)
            }
            
            UIPasteboard.general.string = ""
            
        }
        
        // NOT Working - NotificationCenter.default.addObserver(self, selector: #selector(pasteboardChanged), name: .UIPasteboardChanged, object: nil)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkPasteboardChanges), userInfo: nil, repeats: true)
        
        return true
    }

    private func changeController(byStringIdentifier controllerToGo: String) {
        if let c: NSObject.Type = NSClassFromString("\(controllerToGo)_UIPopulator") as? NSObject.Type {
            let obj = c.init()
            if let uiEntryPoint = obj as? UIEntryPointProtocol {
                self.window?.rootViewController = uiEntryPoint.rootViewController()
            }
        }
    }
    
    @objc func checkPasteboardChanges(_ timer : Timer) {
        if UIPasteboard.general.changeCount != pasteBoardChangeCount {
            
            if let id = UIPasteboard.general.string {
                self.changeController(byStringIdentifier: id)
                self.pasteBoardChangeCount = UIPasteboard.general.changeCount
            }
        }
    }
}

//Idea comes from here : https://developer.apple.com/library/content/documentation/Swift/Conceptual/BuildingCocoaApps/InteractingWithObjective-CAPIs.html#//apple_ref/doc/uid/TP40014216-CH4-ID55
protocol UIEntryPointProtocol {
    func rootViewController() -> UIViewController
}

/**
 READ CLIPBOARD
 
 */
public func readClipboard()-> [String: Any]?{
    
    let items =  UIPasteboard.general.items
    
    if items.count > 0 {
        return items[0]
    }
    return nil
    
}
