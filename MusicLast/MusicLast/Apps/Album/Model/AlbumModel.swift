//
//  AlbumModel.swift
//  MusicLast
//
//  Created by Macbook on 14/10/24.
//

import Foundation

struct APIResponse: Codable {
    var results: Results
}

// MARK: - Results
struct Results: Codable {
    var opensearchQuery: OpensearchQuery
    var opensearchTotalResults, opensearchStartIndex, opensearchItemsPerPage: String?
    var albummatches: Albummatches?
    var artistmatches: Artistmatches?
    var trackmatches: Trackmatches?
    var attr: Attr?

    enum CodingKeys: String, CodingKey {
        case opensearchQuery = "opensearch:Query"
        case opensearchTotalResults = "opensearch:totalResults"
        case opensearchStartIndex = "opensearch:startIndex"
        case opensearchItemsPerPage = "opensearch:itemsPerPage"
        case albummatches
        case artistmatches
        case trackmatches
        case attr = "@attr"
    }
}

// MARK: - Albummatches
struct Albummatches: Codable {
    var albums: [AlbumModel]
    
    enum CodingKeys: String, CodingKey {
        case albums = "album"
    }
}


// MARK: - Album
struct AlbumModel: Codable {
    var name, artist: String
    var url: String?
    var image: [ImageModel]
    var streamable, mbid: String?
}

import SwiftUI
import Kingfisher

extension AlbumModel {
    
    @MainActor
    func getItemView(with optionVIew: @escaping () -> some View, playURL: @escaping () -> Void) -> some View {
        HStack(alignment: .top) {
             KFImage(URL(string: image[2].text ?? ""))
                .placeholder { progress in
                    RoundedRectangle(cornerRadius: 15)
                        .fadeInEffect(duration: 100, isLoop: true)
                }
                .resizable()
                .scaledToFill()
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .frame(width: 100, height: 100)
                .overlay {
                    Image(systemName: "play.circle")
                        .font(.title2)
                }
                .onTapGesture {
                    playURL()
                }
            VStack(alignment: .leading) {
                Text(name)
                    .font(.system(size: 14, weight: .bold, design: .serif))
                Text(artist)
                    .font(.caption)
            }
            Spacer()
        }
    }
}

// MARK: - Image
struct ImageModel: Codable {
    var text: String?
    var size: String // Size

    enum CodingKeys: String, CodingKey {
        case text = "#text"
        case size
    }
}

enum Size: String, Codable {
    case extralarge = "extralarge"
    case large = "large"
    case medium = "medium"
    case small = "small"
    case mega = "mega"
    
}

// MARK: - Attr
struct Attr: Codable {
    var attrFor: String?

    enum CodingKeys: String, CodingKey {
        case attrFor = "for"
    }
}

// MARK: - OpensearchQuery
struct OpensearchQuery: Codable {
    var text, role, searchTerms, startPage: String?

    enum CodingKeys: String, CodingKey {
        case text = "#text"
        case role, searchTerms, startPage
    }
}







