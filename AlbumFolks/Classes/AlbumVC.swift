//
//  AlbumVC.swift
//  AlbumFolks
//
//  Created by Carlos Correia on 03/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import UIKit
import AlamofireImage
/**
 * Again, I didn't subclass UITableViewController as it makes it more flexible to change the layout/incrementally add more components starting with an embedded UITableView in a blank ViewController
 **/
class AlbumVC : UIViewController {
    
    @IBOutlet var albumInfoHeader: AlbumVcHeaderView!
    @IBOutlet weak var tableView : UITableView!
    fileprivate var storedImage : UIImage?
    public var trackChosenDelegate : TrackChosenDelegate?
    
    var albumViewPopulator: AlbumViewPopulator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = albumViewPopulator.name
        self.tableView.tableHeaderView = albumInfoHeader
       
        if let albumImage = albumViewPopulator.inMemoryImage {
            self.albumInfoHeader.imageView.image = albumImage
            self.storedImage = albumImage
        } else if let photoUrl = albumViewPopulator.photoUrl {
            self.albumInfoHeader.imageView.af_setImage(withURL: photoUrl, placeholderImage: UIImage(named_pod: "loading_misc")!, completion: {
                [weak self] response in
                
                guard let _self = self else {
                    return
                }
                
                if response.result.value == nil {
                    _self.albumInfoHeader.imageView.image = UIImage(named_pod: "no_media")!
                }
                
            })
        } else {
            self.albumInfoHeader.imageView.image = UIImage(named_pod: "no_media")!
        }
        
        albumInfoHeader.albumArtist.text = albumViewPopulator.artist.name
        albumInfoHeader.albumTags.text = albumViewPopulator.tags
        
      
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
    }

}

extension AlbumVC : UITableViewDelegate, UITableViewDataSource {
    
    // MARK : UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumViewPopulator.tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as! TrackCell
        
        let track = albumViewPopulator.tracks[indexPath.row]
        
        cell.trackNr.text = String(track.number)
        cell.name.text = track.title
        cell.duration.text = track.lengthStatic
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let del = trackChosenDelegate {
            let track = albumViewPopulator.tracks[indexPath.row]
            del.trackChoosen(track)
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
}
