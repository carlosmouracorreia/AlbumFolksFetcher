//
//  Constants.swift
//  AlbumFolks
//
//  Created by NTW-laptop on 04/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

public var LASTFM_API_KEY_VALUE = ""

class Constants {
    struct COMMON_KEYS {
        static let API_KEY = "api_key"
        static let METHOD_KEY = "method"
        static let FORMAT_KEY_AND_VALUE = "format=json"
        static let ID = "mbid"
    }
    
    struct API_URLS {
        static let ArtistDetail = API_URL_FORMAT_AND_METHOD + "artist.getinfo&mbid=%@"
        static let ArtistAlbums = API_URL_FORMAT_AND_METHOD + "artist.getTopAlbums&mbid=%@"
        static let ArtistAutoCompleteSearch = API_URL_FORMAT_AND_METHOD + "artist.search&artist=%@&limit=%@&page=%@"
        static let AlbumDetailById = API_URL_FORMAT_AND_METHOD + "album.getInfo&mbid=%@"
        static let AlbumDetailByNameAndArtist = API_URL_FORMAT_AND_METHOD + "album.getInfo&album=%@&artist=%@"
    }
    
    static let API_URL = "https://ws.audioscrobbler.com/2.0/"
    static let API_URL_WITH_API_KEY = API_URL + "?\(COMMON_KEYS.API_KEY)=\(LASTFM_API_KEY_VALUE)"
    static let API_URL_FORMAT = API_URL_WITH_API_KEY + "&\(COMMON_KEYS.FORMAT_KEY_AND_VALUE)"
    static let API_URL_FORMAT_AND_METHOD = API_URL_FORMAT + "&\(COMMON_KEYS.METHOD_KEY)="
    
}
