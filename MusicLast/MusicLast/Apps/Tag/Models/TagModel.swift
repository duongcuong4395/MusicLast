//
//  TagModel.swift
//  MusicLast
//
//  Created by Macbook on 22/10/24.
//

import Foundation


// MARK: - Welcome
struct TopTagsResponse: Codable {
    var toptags: ToptagsModel?
}

// MARK: - Toptags
struct ToptagsModel: Codable {
    var attr: Attr?
    var tags: [Tag]?

    enum CodingKeys: String, CodingKey {
        case attr = "@attr"
        case tags = "tag"
    }
}

// MARK: - Toptags
struct Toptags: Codable {
    var tag: [Tag]?
}
