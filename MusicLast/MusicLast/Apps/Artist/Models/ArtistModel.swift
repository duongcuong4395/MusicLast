//
//  ArtistModel.swift
//  MusicLast
//
//  Created by Macbook on 14/10/24.
//

import Foundation
import SwiftUI
import Kingfisher

// MARK: - Artistmatches
struct Artistmatches: Codable {
    var artists: [ArtistModel]
    
    enum CodingKeys: String, CodingKey {
        case artists = "artist"
    }
}

// MARK: - Artist
struct ArtistModel: Codable {
    var name, listeners, mbid: String
    var url: String?
    var streamable: String?
    var images: [ImageModel]
    
    enum CodingKeys: String, CodingKey {
        case images = "image"
        case name, listeners, mbid
    }
}

extension ArtistModel {
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
            }
            Spacer()
        }
    }
}
