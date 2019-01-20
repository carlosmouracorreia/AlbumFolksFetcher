//
//  AlbumCell.swift
//  AlbumFolks
//
//  Created by Carlos Correia on 02/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import UIKit
import Kingfisher

class AlbumCell : UICollectionViewCell, CAAnimationDelegate {
    
    static let REUSE_ID = String(describing: AlbumCell.self)
    
    // MARK: - Properties
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var albumArtist: UILabel!
    
    
    var hasDetail = true
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.imageView.layer.cornerRadius = 5.0
        self.imageView.clipsToBounds = true
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageView.image = nil
        self.imageView.layer.borderColor = nil
        self.imageView.layer.borderWidth = 0.0
    }
    
    public func setContent(_ album: Album) {
        
        if album.photoUrl == nil {
            setImageFrom(image: UIImage(named_pod: "no_media")!)
        }
                
        self.albumName.text = album.name
        self.albumArtist.text = album.artist.name
    }
    
    public func setSearchCellContent() {
        setImageFrom(image: UIImage(named_pod: "add_album")!)
        self.imageView.layer.borderColor = UIColor.black.cgColor
        self.imageView.layer.borderWidth = 3.0
        self.albumName.text = "Last FM API"
        self.albumArtist.text = "Search Albums"
    }
    
 
    
    public func setImageFrom(image: UIImage, hadDetail: Bool = true) {
        self.imageView.image = image
       
        if !hadDetail && self.hasDetail {
            self.unsetTransparencyAnimated()
            
        } else {
            self.imageView.alpha = !self.hasDetail ? 0.3 : 1.0
        }
    }
    
    public func setImageFrom(url: URL?, hadDetail: Bool, completion: @escaping (UIImage) -> ()) {
        
        guard let url = url else {
            setNoMediaImage(hadDetail: hadDetail)
            return
        }
        
        self.imageView.kf.setImage(with: url, placeholder: UIImage(named_pod: "loading_misc")!, options: nil, progressBlock: nil, completionHandler: {
            [weak self] result in
            
            guard let sself = self else {
                return
            }
            
            switch result {
            case .success(let value):
                completion(value.image)
            case .failure:
                print("Error loading image for url: \(url.absoluteString)")
                sself.setNoMediaImage(hadDetail: hadDetail)
            }
            
        })
        
        
    }
    
    public func setNoMediaImage(hadDetail: Bool) {
        let image = UIImage(named_pod: "no_media")!
        self.setImageFrom(image: image, hadDetail: hadDetail)
    }
    
    private func unsetTransparencyAnimated() {
        self.imageView.alpha = 0.3
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "opacity");
        animation.delegate = self
        animation.fromValue = 0.3
        animation.toValue = 1
        animation.duration = 0.4
        self.imageView.layer.add(animation, forKey: nil)
        self.imageView.alpha = 1.0
    }
    
    public static func fetchPhoto(_ album: Album, downloader: ImageDownloader, completion: @escaping () -> ()) {
        
        if album.loadedImage == nil, let photoUrl = album.photoUrl {
            fetchPhotoFrom(photoUrl, downloader: downloader, completion: {
                image in
                album.loadedImage = image
                completion()
            })
        }
        
    }
    
    
    public static func fetchPhotoFrom(_ url: URL, downloader: ImageDownloader, completion: @escaping (UIImage) -> ()) {
        
        downloader.downloadImage(with: url, options: nil, progressBlock: nil, completionHandler: {
            result in
            
            switch result {
            case .success(let value):
                completion(value.image)
            case .failure(_):
                break
            }
        })
    }
}

