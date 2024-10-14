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
