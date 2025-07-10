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
    //var albums: [AlbumModel]
    var albums: [Album]
    
    enum CodingKeys: String, CodingKey {
        case albums = "album"
    }
}


// MARK: - Album
/*
struct AlbumModel: Codable {
    var name, artist: String
    var url: String?
    var image: [ImageModel]
    var streamable, mbid: String?
    var detail: AlbumDetailModel?
}
*/



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
    var page, perPage, totalPages: String?
    var artist: String?
    var position: String?
    var offset: Int?
    var numRes: Int?
    var total: Int?
    
    enum CodingKeys: String, CodingKey {
        case attrFor = "for"
        case rank = "rank"
        case page, perPage, totalPages, artist
        case position
        case offset
        case numRes = "num_res"
        case total
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        attrFor = try container.decodeIfPresent(String.self, forKey: .page)
        page = try container.decodeIfPresent(String.self, forKey: .page)
        perPage = try container.decodeIfPresent(String.self, forKey: .perPage)
        totalPages = try container.decodeIfPresent(String.self, forKey: .totalPages)
        artist = try container.decodeIfPresent(String.self, forKey: .artist)
        
        position = try container.decodeIfPresent(String.self, forKey: .position)
        offset = try container.decodeIfPresent(Int.self, forKey: .offset)
        numRes = try container.decodeIfPresent(Int.self, forKey: .numRes)
        
        if let totalString = try? container.decode(String.self, forKey: .total) {
            rank = Int(totalString)
        } else {
            rank = try container.decodeIfPresent(Int.self, forKey: .total)
        }
        
        if let rankString = try? container.decode(String.self, forKey: .rank) {
            rank = Int(rankString)
        } else {
            rank = try container.decodeIfPresent(Int.self, forKey: .rank)
        }
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



// MARK: - Album
struct Album: Codable { // , Equatable
    /*
    static func == (lhs: Album, rhs: Album) -> Bool {
        lhs.name == rhs.name
    }
    */
    
    var name: String
    var artist: Artist
    var playcount: Int?
    var streamable, mbid: String?
    var url: String?
    var image: [ImageModel]
    var title: String?
    var attr: Attr?
    var detail: AlbumDetailModel?
    enum CodingKeys: String, CodingKey {
        case artist, title, mbid, url, image
        case attr = "@attr"
        case name, playcount, detail
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        
        // Kiểm tra xem artist là String hay đối tượng Artist
        if let artistName = try? container.decode(String.self, forKey: .artist) {
            artist = Artist(name: artistName, mbid: nil, url: nil)
        } else {
            artist = try container.decode(Artist.self, forKey: .artist)
        }
        
        playcount = try? container.decode(Int.self, forKey: .playcount)
        mbid = try? container.decode(String.self, forKey: .mbid)
        url = try? container.decode(String.self, forKey: .url)
        image = try container.decode([ImageModel].self, forKey: .image)
        title = try? container.decode(String.self, forKey: .title)
        attr = try? container.decode(Attr.self, forKey: .attr)
        detail = try? container.decode(AlbumDetailModel.self, forKey: .detail)
    }
}

import SwiftUI
import Kingfisher

extension Album {
    
    @MainActor
    func getItemView(with optionVIew: @escaping () -> some View) -> some View {
        AlbumModelItemView(model: self)
    }
}

struct AlbumModelItemView: View {
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var albumVM: AlbumViewModel
    @StateObject var albumDetailVM = AlbumDetailViewModel()
    
    @Environment(\.openURL) var openURL
    var model: Album
    @StateObject var modelDetailVM = AlbumDetailViewModel()
    var body: some View {
        
        ZStack {
            if appVM.dataViewStyle == .Grid3X3 {
                VStack {
                    KFImage(URL(string: model.image[2].text ?? ""))
                        .resizable()
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(width: 50, height: 50)
                        //.matchedGeometryEffect(id: "topAlbum_image_\(model.name)", in: animation)
                    Text("\(model.name)")
                        .font(.caption.bold())
                        .lineLimit(2)
                        .frame(height: 40)
                }
            }
            else {
                HStack(alignment: .top) {
                    KFImage(URL(string: model.image[2].text ?? ""))
                        .resizable()
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(width: 100, height: 100)
                        //.matchedGeometryEffect(id: "topAlbum_image_\(model.name)", in: animation)
                    VStack(alignment: .leading) {
                        Text("\(model.name)")
                            .font(.system(size: 14, weight: .bold, design: .serif))
                        if let detail = model.detail {
                            AlbumDetailItemView(model: detail)
                        }
                    }
                    Spacer()
                }
                
                
            }
        }
        .onAppear{
            guard model.detail == nil else { return }
            modelDetailVM.getInfor(by: model.name, and: model.artist.name) { obj in
                guard let obj = obj else { return }
                albumVM.updateDetail(at: model.name, by: obj)
                
                tagVM.
            }
        }
    }
}


struct AlbumItemView: View {
    //@EnvironmentObject var artistTopAlbumsVM: ArtistTopAlbumsViewModel
    var model: Album
    var isShowMore: Bool = false
    
    @StateObject var modelDetailVM = AlbumDetailViewModel()
    @Namespace var animation
    
    var body: some View {
        ZStack {
            if !isShowMore {
                VStack {
                    KFImage(URL(string: model.image[2].text ?? ""))
                        .resizable()
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(width: 50, height: 50)
                        .matchedGeometryEffect(id: "topAlbum_image_\(model.name)", in: animation)
                    Text("\(model.name)")
                        .font(.caption.bold())
                        .lineLimit(2)
                        .frame(height: 40)
                }
            }
            else {
                HStack(alignment: .top) {
                    KFImage(URL(string: model.image[2].text ?? ""))
                        .resizable()
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(width: 100, height: 100)
                        .matchedGeometryEffect(id: "topAlbum_image_\(model.name)", in: animation)
                    VStack(alignment: .leading) {
                        Text("\(model.name)")
                            .font(.system(size: 14, weight: .bold, design: .serif))
                        if let detail = model.detail {
                            AlbumDetailItemView(model: detail)
                        }
                    }
                    Spacer()
                }
                
                
            }
        }
        .onAppear{
            guard model.detail == nil else { return }
            modelDetailVM.getInfor(by: model.name, and: model.artist.name ?? "") { obj in
                guard let obj = obj else { return }
                //artistTopAlbumsVM.updateDetail(at: model, by: obj)
            }
        }
    }
}
