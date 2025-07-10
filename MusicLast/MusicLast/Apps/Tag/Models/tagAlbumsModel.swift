//
//  tagAlbumsModel.swift
//  MusicLast
//
//  Created by Macbook on 22/10/24.
//

import Foundation

// MARK: - Welcome
struct TagAlbumsResponse: Codable {
    var albums: Albums?
}

// MARK: - Albums
struct Albums: Codable {
    var album: [Album]?
    var attr: Attr?

    enum CodingKeys: String, CodingKey {
        case album
        case attr = "@attr"
    }
}
