//
//  AlertDialog.swift
//  AlbumFolks
//
//  Created by NTW-laptop on 04/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import UIKit

class AlertDialog : UIAlertController {
    
    var testAccessiblityObject = AccessibilityObject()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let title = title, title.contains("Connection") {
            self.view.accessibilityIdentifier = "AlertDialogConnection"
        } else {
            self.view.accessibilityIdentifier = "AlertDialog"
        }
        
    }
    
    class func present(title: String,message: String, vController: UIViewController, action: ((UIAlertAction) -> ())? = nil) {
        let ac = AlertDialog(title: title, message: message, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: action))
        vController.present(ac, animated: true, completion: nil)
    }
}

class AccessibilityObject : NSObject, UIAccessibilityIdentification {
    //This is not too interesting, as majority of UI elements are sublcasses of UIView, and if they're not, such as this, just as an object reference, dont get triggered.
    var accessibilityIdentifier: String?

    override init() {
        self.accessibilityIdentifier = "AlertDialogTest"
    }
    
}
