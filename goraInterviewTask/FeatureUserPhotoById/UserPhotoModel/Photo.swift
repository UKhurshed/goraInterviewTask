//
//  Photo.swift
//  goraInterviewTask
//
//  Created by Khurshed Umarov on 23.01.2022.
//

import Foundation

/// Photo  structure for response
struct Photo : Codable{
    let albumID, id: Int
        let title: String
        let url, thumbnailURL: String

        enum CodingKeys: String, CodingKey {
            case albumID = "albumId"
            case id, title, url
            case thumbnailURL = "thumbnailUrl"
        }
}
