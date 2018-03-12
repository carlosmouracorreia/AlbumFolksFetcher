//
//  AlbumFolksController.swift
//  Alamofire
//
//  Created by Carlos Correia on 09/03/2018.
//


public class AlbumFolksController : UINavigationController {
    
    
    public static func initUIClasses() {
        //in order to make internal classes for UI testing work a.k.a UIPopulator
        let _ = [ArtistAlbumsVC.UIPopulator.self, SearchArtistsVC.UIPopulator.self]
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public init(passingDelegate: TrackChosenDelegate) {
        let storyboard = UIStoryboard(name: "Main", bundle: GenericHelpers.getBundle())
        let searchViewController = storyboard.instantiateViewController(withIdentifier: "SearchArtistsVC") as! SearchArtistsVC
        searchViewController.passingDelegate = passingDelegate
        super.init(rootViewController: searchViewController)

    }
}
