//
//  Track.swift
//  AlbumFolks
//
//  Created by NTW-laptop on 04/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import UIKit
import Alamofire

class Track : Codable {
    
    let number: Int
    let title: String
    var lengthStatic: String?
    
    required init?(map: Map){
        
        guard let _: String = map["name"].value() else {
            return nil
        }
        
        guard let rank: String = map["@attr.rank"].value(), let _ : Int = Int(rank) else {
            return nil
        }
    }
    
    
    func mapping(map: Map) {
        let rank : String = map["@attr.rank"].value()!
        number = Int(rank)!
        title <- map["name"]
        
        if let duration : String = map["duration"].value(), let intDuration = Int(duration), let _ : Int? = intDuration > 0 ? 1 : nil {
            lengthStatic = stringFromTimeIn(seconds: intDuration)
        }

    }
    
    private func stringFromTimeIn(seconds : Int) -> String {
        let hourTime = seconds / 3600
        let secondTime = (seconds % 3600) % 60
        let secondFormattedTime = secondTime < 10 ? "0\(secondTime)" : "\(secondTime)"
        
        if hourTime < 1 {
            return "\((seconds % 3600) / 60):\(secondFormattedTime)"
        } else {
            return "\(hourTime):\((seconds % 3600) / 60):\(secondFormattedTime)"
        }
    }
}

extension Track {
    enum CodingKeys: String, CodingKey {
        case title = "name"
        case number = "@attr.rank"
    }
}
