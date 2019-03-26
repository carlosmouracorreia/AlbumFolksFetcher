//
//  AppDelegate.swift
//  AlbumFolks
//
//  Created by carloscorreia94 on 02/23/2018.
//  Copyright (c) 2018 carloscorreia94. All rights reserved.
//

import UIKit
import AlbumFolks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    fileprivate var pasteBoardChangeCount = UIPasteboard.general.changeCount
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        /* https://github.com/carlosmouracorreia/AlbumFolksFetcher/blob/master/Documentation/UITesting.md
         Logic for UI Testing to work seamlessly needs to be within the app entrypoint
         */
        
        UserDefaults.standard.set(false, forKey: "no_connection")
        if CommandLine.arguments.contains("--uitesting") {

            AlbumFolksController.initUIClasses()
            
            if CommandLine.arguments.contains("-mockDisableConnection") {
                UserDefaults.standard.set(true, forKey: "no_connection")
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
            if let uiEntryPoint = obj as? AlbumFolks.UIEntryPointProtocol {
                self.window?.rootViewController = uiEntryPoint.rootViewController()
            }
        }
    }

}


