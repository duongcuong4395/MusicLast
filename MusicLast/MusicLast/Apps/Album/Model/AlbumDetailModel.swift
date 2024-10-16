//
//  AlbumDetailModel.swift
//  MusicLast
//
//  Created by Macbook on 14/10/24.
//

import Foundation


// MARK: - Welcome
struct AlbumDetailResponse: Codable {
    var album: AlbumDetailModel?
}

// MARK: - Album
struct AlbumDetailModel: Codable {
    var artist: String?
    var mbid: String?
    var tags: Tags?
    var playcount: String?
    var image: [ImageModel]?
    var tracks: Tracks?
    var url: String?
    var name, listeners: String?
    var wiki: Wiki?
}


// MARK: - Tags
struct Tags: Codable {
    var tag: [Tag]?
}

// MARK: - Tag
struct Tag: Codable {
    var url: String?
    var name: String?
}

// MARK: - Tracks
struct Tracks: Codable {
    var track: [Track]?
}

// MARK: - Track
struct Track: Codable {
    var streamable: Streamable?
    var duration: Int?
    var url: String?
    var name: String?
    var attr: Attr?
    var artist: ArtistClass?

    enum CodingKeys: String, CodingKey {
        case streamable, duration, url, name
        case attr = "@attr"
        case artist
    }
}

// MARK: - ArtistClass
struct ArtistClass: Codable {
    var url: String?
    var name: String?
    var mbid: String?
}

// MARK: - Streamable
struct Streamable: Codable {
    var fulltrack, text: String?

    enum CodingKeys: String, CodingKey {
        case fulltrack
        case text = "#text"
    }
}

// MARK: - Wiki
struct Wiki: Codable {
    var published, summary, content: String?
}

import SwiftUI

struct AlbumDetailItemView: View {
    @Environment(\.openURL) var openURL
    var model: AlbumDetailModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "person.wave.2.fill")
                    .font(.caption.bold())
                Text("\(formatString(value: model.listeners ?? "") ?? "")")
                    .font(.caption.bold())
                
                Spacer()
                
                Image(systemName: "play.circle")
                    .font(.caption.bold())
                Text("\(formatString(value: model.playcount ?? "") ?? "")")
                    .font(.caption.bold())
            }
            HStack {
                Text("\(model.wiki?.summary ?? "")")
                    .font(.caption)
                .lineLimit(1)
            }
            HStack(alignment: .top) {
                ForEach(model.tags?.tag ?? [], id: \.name) { tag in
                    Text("#\(tag.name ?? "")")
                        .font(.caption2)
                        .foregroundStyle(.blue)
                        .onTapGesture {
                            if let url = URL(string: tag.url ?? "") {
                                openURL(url)
                            }
                        }
                }
            }
        }
    }
}
