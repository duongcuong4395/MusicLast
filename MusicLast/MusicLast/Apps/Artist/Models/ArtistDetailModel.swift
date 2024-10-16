//
//  ArtistDetailModel.swift
//  MusicLast
//
//  Created by Macbook on 16/10/24.
//

import Foundation

struct ArtistDetailResponse: Codable {
    var artist: ArtistDetailModel?
}

// MARK: - WelcomeArtist
struct ArtistDetailModel: Codable {
    var name, mbid: String?
    var url: String?
    var image: [ImageModel]?
    var streamable, ontour: String?
    var stats: Stats?
    var similar: Similar?
    var tags: Tags?
    var bio: Bio?
}

// MARK: - Bio
struct Bio: Codable {
    var links: Links?
    var published, summary, content: String?
}

// MARK: - Links
struct Links: Codable {
    var link: Link?
}

// MARK: - Link
struct Link: Codable {
    var text, rel: String?
    var href: String?

    enum CodingKeys: String, CodingKey {
        case text = "#text"
        case rel, href
    }
}

// MARK: - Similar
struct Similar: Codable {
    var artist: [ArtistModel]?
}

// MARK: - Stats
struct Stats: Codable {
    var listeners, playcount: String?
}


import SwiftUI
import Kingfisher

struct ArtistDetailItemView: View {
    @Environment(\.openURL) var openURL
    var model: ArtistDetailModel
    
    @State var toggleShowDetailInfor: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "person.wave.2.fill")
                    .font(.caption.bold())
                Text("\(formatString(value: model.stats?.listeners ?? "") ?? "")")
                    .font(.caption.bold())
                
                Spacer()
                
                Image(systemName: "play.circle")
                    .font(.caption.bold())
                Text("\(formatString(value: model.stats?.playcount ?? "") ?? "")")
                    .font(.caption.bold())
            }
            HStack(spacing: 5) {
                Text("Similar To:")
                    .font(.caption.bold())
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(model.similar?.artist ?? [], id: \.name) { similar in
                            VStack {
                                
                                KFImage(URL(string: similar.images[2].text ?? ""))
                                    .placeholder { progress in
                                        Circle()
                                            .fadeInEffect(duration: 100, isLoop: true)
                                    }
                                    .resizable()
                                    .scaledToFill()
                                    
                                    .clipShape(Circle())
                                    .frame(width: 30, height: 30)
                                    .onTapGesture {
                                        if let url = URL(string: similar.url ?? "") {
                                            openURL(url)
                                        }
                                    }
                                
                                Text(similar.name)
                                    .font(.caption2)
                                    .frame(height: 40)
                            }
                            .frame(width: 70)
                        }
                    }
                }
                .padding(0)
            }
            Text("\(model.bio?.summary ?? "")")
                .font(.caption)
                .lineLimit(toggleShowDetailInfor ? nil : 3)
                .onTapGesture {
                    withAnimation {
                        toggleShowDetailInfor.toggle()
                    }
                }
            HStack(alignment: .top, spacing: 15) {
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
