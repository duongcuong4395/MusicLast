//
//  ArtistAlbumModel.swift
//  MusicLast
//
//  Created by Macbook on 16/10/24.
//

import Foundation


struct ArtistTopalbumsResponse: Codable {
    var topalbums: ArtistTopalbumsModel?
}

// MARK: - Topalbums
struct ArtistTopalbumsModel: Codable {
    var albums: [Album]?
    var attr: Attr?

    enum CodingKeys: String, CodingKey {
        case albums = "album"
        case attr = "@attr"
    }
}

// MARK: - Album
struct Album: Codable {
    var name: String?
    var playcount: Int?
    var mbid: String?
    var url: String?
    var artist: ArtistClass?
    var image: [ImageModel]?
    var detail: AlbumDetailModel?
}




