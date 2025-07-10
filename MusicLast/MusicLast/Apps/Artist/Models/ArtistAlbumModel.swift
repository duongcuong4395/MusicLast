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



import SwiftUI
import Kingfisher

struct AlbumItemView2: View {
    @EnvironmentObject var albumVM: AlbumViewModel
    @StateObject var albumDetailVM = AlbumDetailViewModel()
    
    @Environment(\.openURL) var openURL
    //var model: AlbumModel
    var model: Album
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
                    Text(model.artist.name ?? "")
                        .font(.caption.bold())
                }
                if let detail = model.detail {
                    AlbumDetailItemView(model: detail)
                }
            }
            Spacer()
        }
        .onAppear{
            guard model.detail == nil else { return }
            modelDetailVM.getInfor(by: model.name, and: model.artist.name ?? "") { obj in
                guard let obj = obj else { return }
                albumVM.updateDetail(at: model.name, by: obj)
            }
        }
    }
}

