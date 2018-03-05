//
//  AlbumViewPopulator.swift
//  AlbumFolks
//
//  Created by NTW-laptop on 17/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//


class AlbumViewPopulator {
    var inMemoryImage : UIImage?
    var photoUrl : URL?
    var name : String
    var tags : String?
    var hashString : String
    var tracks = [TrackViewPopulator]()
    var artist : ArtistPopulator
    
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
