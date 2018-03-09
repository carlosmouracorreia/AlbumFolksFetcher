//
//  ArtistDetail.swift
//  AlbumFolks
//
//  Created by Carlos Correia on 02/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import ObjectMapper
import Alamofire



class ArtistDetail : Mappable {
    fileprivate var tags : [Tag]?
    var description : String!
    
    required init?(map: Map){
      
        
        guard let _: String = map["bio.summary"].value() else {
            return nil
        }
        
    }
    
    func mapping(map: Map) {
        description <- map["bio.summary"]
        cropDescription()
        tags <- map["tags.tag"]
    }
    
    
    func getTagsString() -> String? {
        if let tags = tags {
            return Tag.getTagsString(tags)
        }
        return nil
    }
    
    private func cropDescription() {
       
        let descriptionSplitHrefTag = description.components(separatedBy: "<a href=\"")
        if descriptionSplitHrefTag.count > 1 {
            description = descriptionSplitHrefTag[0]
        }
    }
    
    static func fetchNetworkData(artistId: String, successCallback: @escaping (ArtistDetail) -> (), errorCallback: @escaping (NetworkError) -> ()) {
        
        let URL = String(format: Constants.API_URLS.ArtistDetail,artistId)
        
            Alamofire.request(URL).responseObject(keyPath: "artist") { (response: DataResponse<ArtistDetail>) in
                    let (success, error) = CoreNetwork.handleResponse(response)
                
                    if let error = error {
                        errorCallback(error)
                    } else {
                        successCallback(success!)
                    }
            }
    }
    
}
