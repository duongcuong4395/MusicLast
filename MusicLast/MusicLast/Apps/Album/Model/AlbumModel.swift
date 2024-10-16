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
    func getItemView(with optionVIew: @escaping () -> some View) -> some View {
        AlbumItemView(model: self)
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
    var rank: Int?
    
    enum CodingKeys: String, CodingKey {
        case attrFor = "for"
        case rank = "rank"
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






struct AlbumItemView: View {
    @StateObject var albumDetailVM = AlbumDetailViewModel()
    
    @Environment(\.openURL) var openURL
    var model: AlbumModel
    @StateObject var modelDetailVM = AlbumDetailViewModel()
    var body: some View {
        HStack(alignment: .top) {
            KFImage(URL(string: model.image[2].text ?? ""))
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
                    if let url = URL(string: model.url ?? "") {
                        openURL(url)
                    }
                }
            VStack(alignment: .leading) {
                Text(model.name)
                    .font(.system(size: 14, weight: .bold, design: .serif))
                HStack {
                    Image(systemName: "person.crop.circle")
                        .font(.caption.bold())
                    Text(model.artist)
                        .font(.caption.bold())
                }
                if let detail = modelDetailVM.model {
                    AlbumDetailItemView(model: detail)
                }
            }
            Spacer()
        }
        .onAppear{
            modelDetailVM.getInfor(by: model.name, and: model.artist)
        }
    }
}
