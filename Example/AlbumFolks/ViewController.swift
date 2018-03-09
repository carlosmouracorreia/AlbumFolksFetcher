//
//  ViewController.swift
//  AlbumFolks
//
//  Created by Carlos Correia on 01/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import AlbumFolks
import AlamofireImage

class ViewController: UIViewController {
    
    @IBAction func searchClicked(_ sender: UIBarButtonItem) {
        let albumFolksController = AlbumFolksController(passingDelegate: self)
        self.present(albumFolksController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var albumImage: UIImageView! {
        didSet {
            self.albumImage.clipsToBounds = true
            self.albumImage.contentMode = .scaleAspectFill
            self.albumImage.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var trackLength: UILabel!
    @IBOutlet weak var album: UILabel!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var tags: UILabel!
    
    
    fileprivate let imageDownloader = ImageDownloader()
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
    }
    

    
    @IBAction func albumImageClicked(_ sender: UITapGestureRecognizer) {
        
        //Take care of the API KEY
        let albumFolksController = AlbumFolksController(passingDelegate: self)
        self.present(albumFolksController, animated: true, completion: nil)
    }
    
    open func setUITestContents(_ contents: String) {
        self.trackName.text = contents
    }
    
}

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

