//
//  TrackModel.swift
//  MusicLast
//
//  Created by Macbook on 14/10/24.
//

import Foundation
import SwiftUI
import Kingfisher

// MARK: - Trackmatches
struct Trackmatches: Codable {
    var tracks: [TrackModel]
    
    enum CodingKeys: String, CodingKey {
        case tracks = "track"
    }
}

// MARK: - Track
struct TrackModel: Codable {
    var id: UUID = UUID()
    var name, artist: String
    var url: String?
    var streamable: String?
    var listeners: String?
    var images: [ImageModel]
    var mbid: String?
    
    enum CodingKeys: String, CodingKey {
        case images = "image"
        case name, artist
    }
}


extension TrackModel {
    @MainActor
    func getItemView(with optionVIew: @escaping () -> some View, playURL: @escaping () -> Void) -> some View {
        HStack(alignment: .top) {
             KFImage(URL(string: images[2].text ?? ""))
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


// MARK: - Welcome
struct InfoTrackResponse: Codable {
    var track: Track?
}

// MARK: - Track
struct Track: Codable {
    var streamable: Streamable?
    var duration: Int?
    var url: String?
    var image: [ImageModel]?
    var name, playcount, listeners, mbid: String?
    var attr: Attr?
    var artist: Artist?
    
    var album: Album?
    var toptags: Toptags?
    var wiki: Wiki?

    enum CodingKeys: String, CodingKey {
        case streamable, duration, url, name
        case playcount, listeners, mbid
        case attr = "@attr"
        case artist, image, wiki, toptags
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode các thuộc tính khác
        streamable = try container.decodeIfPresent(Streamable.self, forKey: .streamable)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        playcount = try container.decodeIfPresent(String.self, forKey: .playcount)
        listeners = try container.decodeIfPresent(String.self, forKey: .listeners)
        mbid = try container.decodeIfPresent(String.self, forKey: .mbid)
        attr = try container.decodeIfPresent(Attr.self, forKey: .attr)
        artist = try container.decodeIfPresent(Artist.self, forKey: .artist)
        image = try container.decodeIfPresent([ImageModel].self, forKey: .image)
        wiki = try container.decodeIfPresent(Wiki.self, forKey: .wiki)
        toptags = try container.decodeIfPresent(Toptags.self, forKey: .toptags)

        // Xử lý duration
        if let durationString = try? container.decode(String.self, forKey: .duration) {
            duration = Int(durationString)
        } else {
            duration = try container.decodeIfPresent(Int.self, forKey: .duration)
        }
    }
}

// MARK: - Toptags
struct Toptags: Codable {
    var tag: [Tag]?
}


struct TrackDetailItemView: View {
    @Environment(\.openURL) var openURL
    let track: Track
    
    var optionView: () -> AnyView
    
    @State var toggleShowDetailInfor: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "person.wave.2.fill")
                    .font(.caption.bold())
                Text("\(formatString(value: track.listeners ?? "") ?? "")")
                    .font(.caption.bold())
                
                Image(systemName: "play.circle")
                    .font(.caption.bold())
                Text("\(formatString(value: track.playcount ?? "") ?? "")")
                    .font(.caption.bold())
                Spacer()
                optionView()
            }
            
            Text("\(track.wiki?.summary ?? "")")
                .font(.caption)
                .lineLimit(toggleShowDetailInfor ? nil : 3)
                .onTapGesture {
                    withAnimation(.spring()) {
                        toggleShowDetailInfor.toggle()
                    }
                }
            HStack(alignment: .top, spacing: 15) {
                ForEach(track.toptags?.tag ?? [], id: \.name) { tag in
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
