//
//  ArtistCell.swift
//  AlbumFolks
//
//  Created by Carlos Correia on 02/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import UIKit
import AlamofireImage

class ArtistCell : UITableViewCell {
    
    static let REUSE_ID = String(describing: ArtistCell.self)
    
    @IBOutlet weak var artistName : UILabel!
    @IBOutlet weak var listeners: UILabel!
    @IBOutlet weak var customImageView : UIImageView!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.customImageView.af_cancelImageRequest()
        self.customImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        customImageView.layer.cornerRadius = customImageView.bounds.size.width / 2
        customImageView.clipsToBounds = true
        customImageView.contentMode = .scaleAspectFill

    }
    
    public func setContent(artist: Artist) {
        self.listeners.isHidden = false
        self.customImageView.isHidden = false

        self.artistName.text = artist.name
        self.listeners.text = artist.listeners != nil ? "\(getListenersPretty(artist.listeners!)) Listeners" : ""
        
        if artist.photoUrl == nil {
            setImage(UIImage(named: "no_media")!)
        }
        
    }
    
   
    public func setImage(_ image: UIImage) {
        self.customImageView.image = image
    }
    
    
    public func setImage(_ url: URL) {
        self.customImageView.af_setImage(withURL: url, placeholderImage: UIImage(named: "loading_misc")!, completion: {
            response in
            
            if let _ = response.result.value {
                
            } else {
                self.setImage(UIImage(named: "no_media")!)
            }
        })
    }
    
    
    private func getListenersPretty(_ listeners: Int) -> String {
        let numberString = String(listeners)
        switch listeners {
        case let x where x >= 1000000:
            let number = numberString.dropLast(6)
            return "\(number) Million"
        case let x where x >= 1000:
            let number = numberString.dropLast(3)
            return "\(number) Thousand"
        case let x where x < 1000:
            return numberString
        default:
            return ""
        }
    }
}
