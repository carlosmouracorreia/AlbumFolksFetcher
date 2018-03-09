//
//  AlbumViewPopulator.swift
//  AlbumFolks
//
//  Created by NTW-laptop on 17/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//


public class AlbumViewPopulator {
    public var inMemoryImage : UIImage?
    public var photoUrl : URL?
    public var name : String
    public var tags : String?
    public var hashString : String
    public var tracks = [TrackViewPopulator]()
    public var artist : ArtistPopulator
    
    init(album: Album, image: UIImage? = nil) {
        
        self.inMemoryImage = image
        self.photoUrl = album.photoUrl
        self.name = album.name
        self.artist = ArtistPopulator(name: album.artist.name, mbid: album.artist.mbid, photoUrl: album.artist.photoUrl, lastFmUrl: album.artist.lastFmUrl)
        self.hashString = String(album.hashValue)
        
        guard let detail = album.albumDetail else {
            assertionFailure("Couldn't fetch album detail")
            return
        }
        
        self.tags = detail.getTagsString()
        
        
        for _track in detail.tracks {
            let track = TrackViewPopulator(album: self, number: _track.number, title: _track.title, lengthStatic: _track.lengthStatic)
            self.tracks.append(track)
        }
    }
    
}
