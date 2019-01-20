//
//  ArtistInfoHeaderCell.swift
//  AlbumFolks
//
//  Created by Carlos Correia on 02/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import UIKit
import Kingfisher

class ArtistInfoHeaderCell : UICollectionReusableView {
    
    static let REUSE_ID = String(describing: ArtistInfoHeaderCell.self)
    
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var tags: UILabel!
    @IBOutlet weak var seeMore: UIButton!
    
    @IBOutlet weak var artistInfoStatic: UILabel!
    @IBOutlet weak var artistAlbumsStatic: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    var loadingView : UIView?
    var artistInfoCallback : (() -> ())?
    var lastFmUrl : URL?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.layer.cornerRadius = imageView.bounds.width / 2
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    public func setContent(_ artist: Artist) {
        
        if let url = artist.photoUrl {
            
            self.imageView.kf.setImage(with: url, placeholder: UIImage(named_pod: "loading_misc")!, options: nil, progressBlock: nil, completionHandler: {
                [weak self] result in
                
                guard let sself = self else {
                    return
                }
                
                switch result {
                case .success(let value):
                    sself.imageView.image = value.image
                case .failure:
                    sself.imageView.image = UIImage(named_pod: "no_media")!
                }
                
            })
            
        } else {
            self.imageView.image = UIImage(named_pod: "no_media")!
        }
        
        if let url = artist.lastFmUrl {
            lastFmUrl = url
        }
    }
    
    public func setDetailContent(_ detail: ArtistDetail) {
        
        if let view = loadingView {
            view.removeFromSuperview()
        }
        
        //Unhide previous hidden content (progressBar was showing)
        tags.isHidden = false
        infoLabel.isHidden = false
        artistInfoStatic.isHidden = false
        
        infoLabel.text = detail.description
        tags.text = detail.getTagsString()
        
        seeMore.isHidden = (detail.description?.trimmingCharacters(in: .whitespaces) ?? "") == "" || !(infoLabel.isTruncated || lastFmUrl != nil)
    }
    
    public func setArtistInfoCallback(_ callback: @escaping () -> ()) {
        self.artistInfoCallback = callback
    }
    
    public func setActivityIndicatorView() {
        loadingView = LoadingIndicatorView.create(centerX: self.center.x, originY: imageView.frame.maxY + 12, size: (artistAlbumsStatic.frame.minY - imageView.frame.maxY) * 0.7)
        self.addSubview(loadingView!)
    }
    
  
    
    @IBAction func seeMorePressed(_ sender: UIButton) {
        if let callback = artistInfoCallback {
            callback()
        }
    }
    
}
