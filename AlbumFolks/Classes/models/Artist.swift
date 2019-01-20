//
//  Artist.swift
//  AlbumFolks
//
//  Created by Carlos Correia on 03/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import Alamofire
import ObjectMapper

class Artist : Mappable {
    
    var detail: ArtistDetail?
    var albums : [Album]?
    var requestedAlbumDetails : Dictionary<Album,Bool>?
    
    var photoUrl : URL?
    var lastFmUrl : URL?
    var listeners : Int?
    
    var name : String!
    var mbid : String!
    
    
    init(_ artistPopulator: ArtistPopulator) {
        
        self.name = artistPopulator.name
        self.mbid = artistPopulator.mbid
        self.lastFmUrl = artistPopulator.lastFmUrl
        self.photoUrl = artistPopulator.photoUrl
        
    }
   
    required init?(map: Map){
        
        // We're certified of having an associated artist (Inmplicitly unwrapped optional artist variable) upon Album object usage
        
        guard let _: String = map["name"].value() else {
            return nil
        }
        
        // We just return Artists if they have mbid associated
        guard let mbid: String = map["mbid"].value(), let _ : Int? = mbid.isEmpty ? nil : 1 else {
            return nil
        }
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        mbid <- map["mbid"]
        photoUrl = LastFmImage.getImageUrl(imageMap: map,imageKey: "image")
        
        var urlString : String?
        urlString <- map["url"]
        
        if let urlString = urlString, let url = URL(string: urlString) {
            self.lastFmUrl = url
        }
        
        var listenersString : String?
        listenersString <- map["listeners"]
        
        if let listenersString = listenersString, let listeners = Int(listenersString) {
            self.listeners = listeners
        }
        
    }
    
    static func fetchAutoCompleteSearch(query: String, pagination: Pagination, successCallback: @escaping (PaginatedArtists) -> (), errorCallback: @escaping (NetworkError) -> ()) {
        let urlString = String(format: Constants.API_URLS.ArtistAutoCompleteSearch,query,String(AF_SEARCH_MAX_SEARCH_RESULTS),String(pagination.page))
        if let url = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            AF.request(url).responseObject(keyPath: "results") { (response: DataResponse<PaginatedArtists>) in
                let (success, error) = CoreNetwork.handleResponse(response)
                
                if let error = error {
                    errorCallback(error)
                } else {
                    successCallback(success!)
                }
            }
        } else {
            errorCallback(.WrongContent)
        }
        
       
    }

}
