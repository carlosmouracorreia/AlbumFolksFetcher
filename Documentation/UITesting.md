# UI Testing Architecture

## Overview

The example application includes some [extra code](https://github.com/carlosmouracorreia/AlbumFolksFetcher/blob/master/Example/AlbumFolks/AppDelegate.swift) in the AppDelegate class to make it easier to test the app from a **user's perspective**. To do so, while preserving test qualities (especially isolation) , not having to reproduce users steps until getting to a specific user story, a common mechanism to deploy ViewControllers to the root of the navigation was implemented.

This is the important piece of code to enable communication in the AppDelegate:

```Swift

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
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
        
       ...
    }
```

## Internal Communication

In order to communicate with the App in a grey-box fashion (changing some of its internal state for the ease for black-box testing) 3 native mechanisms where used:


### CommandLine arguments

Suppose you want to say you want to enable UITesting and block the user connection.
In the testing file you'd do the following:

```Swift
 var app : XCUIApplication! {
        didSet {
            app.launchArguments.append("--uitesting")
        }
    }
```



```Swift
  func testSearchNoConnectionShowsConnectionPopup() {
        
        //launch the app again (outside of the setUp method) so we cant send command line specific arguments
        self.app = XCUIApplication()
        app.launchArguments.append("-mockDisableConnection")
        app.launch()
        
        self.goToSearch(app)
        self.typeSearch(app, "What is the internet")
        
        let artistCell = app.tables.cells["ArtistCell"].firstMatch
        self.verifyResponseElementNotExist(app, element: artistCell)
        

        XCTAssert(self.app.alerts.firstMatch.exists)
    }
```

### UIPasteboard

What if you'd like to change the rootViewController multiple times inside a test, i.e for multiple user stories, or even to link multiple user stories without the trouble of tapping a bunch of times?
Here's how you do it:

```Swift
     func testSearchVisibleDelayArtistAlbumsVisible() {
    
        self.app = XCUIApplication()
        app.launchArguments.append("-UIPopulator")
        app.launchArguments.append("SearchArtistsVC")
        app.launch()
        
        XCTAssert(app.otherElements["SearchArtistsView"].exists)
        sleep(1)
        
        UIPasteboard.general.string = "ArtistAlbumsVC"
        sleep(1)
        XCTAssert(app.otherElements["ArtistAlbumsView"].exists)
    }
```

There's a basic rationale behind the scenes. In the AppDelegate a timer to check the UIPasteboard is implemented:

```Swift
    	fileprivate var pasteBoardChangeCount = UIPasteboard.general.changeCount

    	...

        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkPasteboardChanges), userInfo: nil, repeats: true)
```

```Swift

  @objc func checkPasteboardChanges(_ timer : Timer) {
        if UIPasteboard.general.changeCount != pasteBoardChangeCount {
            
            if let id = UIPasteboard.general.string {
                self.changeController(byStringIdentifier: id)
                self.pasteBoardChangeCount = UIPasteboard.general.changeCount
            }
        }
    }
```


### UserDefaults (between internal components)

So in the first code example we've set this flag:

```Swift
  UserDefaults.standard.set(true, forKey: "no_connection")
```

How does this really work? Within the [CoreNetwork class](https://github.com/carlosmouracorreia/AlbumFolksFetcher/blob/master/AlbumFolks/Classes/helpers/CoreNetwork.swift) we verify for the existance of this flag and mock the network response in the affirmative scenario:

```Swift
   static func handleResponse<T>(_ response: DataResponse<T>) -> (T?,NetworkError?) {
        
        if UserDefaults.standard.bool(forKey: "no_connection") {
            return (nil,.Connection)
        }

        ...

    }
```

## Shortcuts 

There are two ways of making the app change it's rootViewController. Actually there's also only two shortcuts to go for now - The Search (SearchArtistsVC) and Artist Albums (ArtistAlbumsVC).

You may have noticed:


```Swift
   // Within test logic

   //Set initial viewController upon launching the App
   app.launchArguments.append("SearchArtistsVC")
        
   //Change it whenever you want 
   UIPasteboard.general.string = "ArtistAlbumsVC"
```

The big question might be, how does this work? And what If I want to do the same for the AlbumVC (Album information for instance).

Well first, you'd have to fork the repo and send a pretty pull request in the end :-)

The key is, we look for some code in run-time, making it all pretty organized inside the ViewController class we want to "inject".

The **changeViewController()** function gets called in the appDelegate upon a UIPasteboard change (UIPasteboard.general.string optional) or a command-line argument with "-UIPopulator" flag:

```Swift
     private func changeController(byStringIdentifier controllerToGo: String) {
        
        if let c: NSObject.Type = NSClassFromString("\(controllerToGo)_UIPopulator") as? NSObject.Type {
            
            let obj = c.init()
            if let uiEntryPoint = obj as? AlbumFolks.UIEntryPointProtocol {
                self.window?.rootViewController = uiEntryPoint.rootViewController()
            }
        }
    }
```

For the magic to happen, the compiler needs to know in compile time the classes name referenced from NSClassFromString. To do so, we make a small invocation after the UITesting validation (on the appDelegate didFinishLaunchWithOptions):

```Swift
     AlbumFolksController.initUIClasses()
```

```Swift
      public static func initUIClasses() {
        //in order to make internal classes for UI testing work a.k.a UIPopulator
        let _ = [ArtistAlbumsVC.UIPopulator.self, SearchArtistsVC.UIPopulator.self]
    }
```


By last we define our logic to populate the viewController with the necessary data/state, inside the class definition of itself - like this:

```Swift

@objc(ArtistAlbumsVC_UIPopulator) class UIPopulator : NSObject, UIEntryPointProtocol {
        func rootViewController() -> UIViewController {
            
            let storyboard = UIStoryboard(name: "Main", bundle: GenericHelpers.getBundle())
            let vc = storyboard.instantiateViewController(withIdentifier: "ArtistAlbumsVC") as! ArtistAlbumsVC
            vc.artist = Artist(ArtistPopulator(name: "Mac DeMarco", mbid: "f2492c31-54a8-4347-a1fc-f81f72873bbf", photoUrl: URL(string: "https://lastfm-img2.akamaized.net/i/u/174s/d329b2d3ce7e47b1c77bbb54c2c0dbbb.png"), lastFmUrl: URL(string: "https://www.last.fm/music/Mac+DeMarco")))
            let navigationVc = UINavigationController(rootViewController: vc)
            
            return navigationVc
        }
    }
 ```


 We also conform to the UIEntryPointProtocol so we don't have to do runtime check for methods too, making it a bit more type safe :-) 

```Swift
	public protocol UIEntryPointProtocol {
    	func rootViewController() -> UIViewController
	}
 ```

 So, in short, If we want to make a viewController (i.e ViewController) available within the UITesting enviornment (or maybe not just on the UI tesing...) the following had to happen:

  1. AlbumFolksController.initUIClasses() -> Add class reference (ViewController.UIPopulator.self) to the array
  2. in the class definition prefix make it just like this: @objc(ViewController_UIPopulator)
  3. Populate your custom data before returning the viewController (optional)

