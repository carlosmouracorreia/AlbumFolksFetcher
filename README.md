# AlbumFolks

[![CI Status](http://img.shields.io/travis/carloscorreia94/AlbumFolks.svg?style=flat)](https://travis-ci.org/carloscorreia94/AlbumFolks)
[![Version](https://img.shields.io/cocoapods/v/AlbumFolks.svg?style=flat)](http://cocoapods.org/pods/AlbumFolks)
[![License](https://img.shields.io/cocoapods/l/AlbumFolks.svg?style=flat)](http://cocoapods.org/pods/AlbumFolks)
[![Platform](https://img.shields.io/cocoapods/p/AlbumFolks.svg?style=flat)](http://cocoapods.org/pods/AlbumFolks)

This library allows for plug-n-play track (album information) download providing a simple UI/interface for search/fetch. Its inspired on [this original project](https://github.com/carlosmouracorreia/AlbumFolks) (persistent album info storage)


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## To Use - API_KEY

Although there's a filled AF_LASTFM_API_KEY_VALUE for the example project you should provide your own when installing the Pod. [Get it here](https://www.last.fm/api/authentication)

Then simply change the global constant **AF_LASTFM_API_KEY_VALUE**.

## Installation

AlbumFolks is available through (not yet) [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'AlbumFolks'
```

## Simple Usage

Consult Example ViewController [here](https://github.com/carlosmouracorreia/AlbumFolksFetcher/blob/master/Example/AlbumFolks/ViewController.swift).

```Swift

 AF_LASTFM_API_KEY_VALUE = "YOUR API KEY"

 @IBAction func searchClicked(_ sender: UIBarButtonItem) {
        let albumFolksController = AlbumFolksController(passingDelegate: self)
        self.present(albumFolksController, animated: true, completion: nil)
    }

```

```Swift

extension ViewController : TrackChosenDelegate {
    func trackChoosen(_ track: TrackViewPopulator) {

        if let image = track.album.inMemoryImage {
            self.albumImage.image = image
        }
        
        self.trackName.text = "Track: \(track.number) - \(track.title)"

        self.trackLength.text = "Track Length: \(track.lengthStatic ?? "No Info")"
        
        self.album.text = "Album: \(track.album.name)"
        
        self.artist.text = "Artist: \(track.album.artist.name)"
        
        self.tags.text = "Tags: \(track.album.tags ?? "No Info")"
    }
}

```

## Configurable Parameters 

All configurable parameters start with the prefix **AF**. You can make use of these to tune useful parameters.

### Search (SearchArtistsVC)

```Swift
/* When not searching */
public var AF_MAX_RECENT_SEARCH_ENTRIES : Int

/* I recommend 2,3 minimum */
public var AF_MIN_SEARCH_QUERY_LENGTH : Int

/* Limit for the API Query - Limit number to display on the screen */
public var AF_MAX_SEARCH_RESULTS : Int

/* Last FM API present a lot of irrelevant pages w/unadmissible content... */
public var AF_MAX_PAGE_NUMBER : Int
 
/* load less pages as you write more content */
public var AF_PAGE_DECREMENT_FACTOR_PER_EXTRA_CHAR : Int
```

### Artist Albums (ArtistAlbumsVC)

```Swift

/* After this threshold user gets a link displayed to open a webbrowser  */
public var AF_MAX_ALBUMS_TO_SHOW : Int
```

## Dependencies

### Pods

* Alamofire
* AlamofireObjectMapper (and ObjectMapper)
* AlamofireImage
* PopupDialog (Directly inserted into AlbumFolks)

### Bridging Code (Copied Objective-C)

* UIScrollView+InfiniteScroll

## Testing

[AlbumVCEntryPointsTests.swift](https://github.com/carlosmouracorreia/AlbumFolksFetcher/blob/master/Example/AlbumFolks_ExampleTests/AlbumVCEntryPointTests.swift) - Data flow testing corresponding to the core user interaction with the App i.e, visualize albums either from the API or saved.

[LaunchAppTests.swift - UI Testing](https://github.com/carlosmouracorreia/AlbumFolksFetcher/blob/master/Example/AlbumFolks_ExampleUITests/LaunchAppTests.swift) 

[Consult UI Testing implementation details here](https://github.com/carlosmouracorreia/AlbumFolksFetcher/blob/master/Documentation/UITesting.md)

## Author

carlosmouracorreia, pm.correia.carlos@gmail.com

I'm also on Twitter - [twitter.com/correiask8](https://twitter.com/correiask8)

## License

AlbumFolks is available under the MIT license. See the LICENSE file for more info.
