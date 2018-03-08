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


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
        let x = ArtistAlbumsVC.UIPopulator.self
        let y = SearchArtistsVC.UIPopulator.self
        
        UserDefaults.standard.set(true, forKey: "connection")
        
        if CommandLine.arguments.contains("--uitesting") {
         
            if CommandLine.arguments.contains("-mockDisableConnection") {
                UserDefaults.standard.set(false, forKey: "connection")
            }
            
            if CommandLine.arguments.contains("-UIPopulator"), let index = CommandLine.arguments.index(of: "-UIPopulator"), let afterIndex = CommandLine.arguments.index(index, offsetBy: 1, limitedBy: 0) {
                if let c: NSObject.Type = NSClassFromString("\(CommandLine.arguments[afterIndex])_UIPopulator") as? NSObject.Type {
                    let obj = c.init()
                    if let uiEntryPoint = obj as? UIEntryPointProtocol {
                        self.window?.rootViewController = uiEntryPoint.rootViewController()
                    }
                }
            }
        }
        
        return true
    }

   
    
}


//Idea comes from here : https://developer.apple.com/library/content/documentation/Swift/Conceptual/BuildingCocoaApps/InteractingWithObjective-CAPIs.html#//apple_ref/doc/uid/TP40014216-CH4-ID55
protocol UIEntryPointProtocol {
    func rootViewController() -> UIViewController
}
