//
//  ArtistTrackModel.swift
//  MusicLast
//
//  Created by Macbook on 16/10/24.
//

import Foundation

struct ArtistTopTrackResponse: Codable {
    var toptracks: ArtistTopTrackModel?
}

// MARK: - Toptracks
struct ArtistTopTrackModel: Codable {
    var track: [ArtistTrackModel]?
    var attr: ToptracksAttr?

    enum CodingKeys: String, CodingKey {
        case track
        case attr = "@attr"
    }
}

struct ArtistTrackModel: Codable {
    var streamable: String
    var duration: Int?
    var url: String?
    var image: [ImageModel]?
    var name, playcount, listeners, mbid: String?
    var attr: ArtistTrackAttr?
    var artist: ArtistClass?

    enum CodingKeys: String, CodingKey {
        case streamable, duration, url, name
        case playcount, listeners, mbid
        case attr = "@attr"
        case artist, image
    }
}

struct ArtistTrackAttr: Codable {
    var attrFor: String?
    var rank: String?
    var page, perPage, totalPages, total: String?
    var artist: String?
    
    enum CodingKeys: String, CodingKey {
        case attrFor = "for"
        case rank = "rank"
        case page, perPage, totalPages, total, artist
    }
}

// MARK: - ToptracksAttr
struct ToptracksAttr: Codable {
    var artist: String
    var page, perPage, totalPages, total: String?
}

