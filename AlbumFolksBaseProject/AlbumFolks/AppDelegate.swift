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
    fileprivate let uiInjectionPoints = [ArtistAlbumsVC.UIPopulator.self, SearchArtistsVC.UIPopulator.self]

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UserDefaults.standard.set(true, forKey: "connection")
        
        if CommandLine.arguments.contains("--uitesting") {
            
            if CommandLine.arguments.contains("-mockDisableConnection") {
                UserDefaults.standard.set(false, forKey: "connection")
            }
            
            if CommandLine.arguments.contains("-UIPopulator"), let index = CommandLine.arguments.index(of: "-UIPopulator"),
                let afterIndex = CommandLine.arguments.index(index, offsetBy: 1, limitedBy: 0) {
                self.changeController(byStringIdentifier: CommandLine.arguments[afterIndex])
            }
            
        }
        
        // Not getting notified - workaround with a Timer
        // NotificationCenter.default.addObserver(self, selector: #selector(pasteboardChanged), name: .UIPasteboardChanged, object: nil)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkPasteboardChanges), userInfo: nil, repeats: true)
        
        return true
    }

    
    @objc func checkPasteboardChanges(_ timer : Timer) {
        if UIPasteboard.general.changeCount != pasteBoardChangeCount {
            
            if let id = UIPasteboard.general.string {
                self.changeController(byStringIdentifier: id)
                self.pasteBoardChangeCount = UIPasteboard.general.changeCount
            }
        }
    }
    
    
    private func changeController(byStringIdentifier controllerToGo: String) {
        
        if let c: NSObject.Type = NSClassFromString("\(controllerToGo)_UIPopulator") as? NSObject.Type {
            
            let obj = c.init()
            if let uiEntryPoint = obj as? UIEntryPointProtocol {
                self.window?.rootViewController = uiEntryPoint.rootViewController()
            }
        }
    }
    
}

protocol UIEntryPointProtocol {
    func rootViewController() -> UIViewController
}
