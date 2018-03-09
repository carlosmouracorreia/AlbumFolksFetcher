//
//  TrackViewPopulator.swift
//  AlbumFolks
//
//  Created by NTW-laptop on 17/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

public class TrackViewPopulator {
    public var number: Int
    public var title: String
    public var album: AlbumViewPopulator
    public var lengthStatic: String?
    
    init(album: AlbumViewPopulator, number: Int, title: String, lengthStatic: String?) {
        self.album = album
        self.number = number
        self.title = title
        self.lengthStatic = lengthStatic
    }
}
