//
//  ArtistCell.swift
//  AlbumFolks
//
//  Created by Carlos Correia on 02/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import UIKit
import Kingfisher

class ArtistCell : UITableViewCell {
    
    static let REUSE_ID = String(describing: ArtistCell.self)
    
    @IBOutlet weak var artistName : UILabel!
    @IBOutlet weak var listeners: UILabel!
    @IBOutlet weak var customImageView : UIImageView!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.customImageView.kf.cancelDownloadTask()
        self.customImageView.image = nil
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.accessibilityIdentifier = "ArtistCell"
        
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
            setImage(UIImage(named_pod: "no_media")!)
        }
        
    }
    
   
    public func setImage(_ image: UIImage) {
        self.customImageView.image = image
    }
    
    
    public func setImage(_ url: URL) {
        
        self.customImageView.kf.setImage(with: url, placeholder: UIImage(named_pod: "loading_misc")!, options: nil, progressBlock: nil, completionHandler: {
            [weak self] result in
            
            guard let sself = self else {
                return
            }
            
            switch result {
            case .success:
                break
            case .failure:
                sself.setImage(UIImage(named_pod: "no_media")!)

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
