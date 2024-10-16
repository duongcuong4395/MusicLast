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
    var name: String
    var listeners, mbid: String?
    var url: String?
    var streamable: String?
    var images: [ImageModel]
    
    enum CodingKeys: String, CodingKey {
        case images = "image"
        case name, listeners, mbid, url, streamable
    }
}

extension ArtistModel {
    @MainActor
    func getItemView(with optionVIew: @escaping () -> some View) -> some View {
        ArtistItemView(model: self)
    }
}

struct ArtistItemView: View {
    @StateObject var artistDetailVM = ArtistDetailViewModel()
    @Environment(\.openURL) var openURL
    var model: ArtistModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                
                Text(model.name)
                    .font(.system(size: 14, weight: .bold, design: .serif))
                    .padding(.leading, 35)
            }
            
            if let detail = artistDetailVM.model {
                ArtistDetailItemView(model: detail)
                    .padding(.leading, 35)
                    .padding(.trailing, 5)
                    .padding(.vertical, 5)
                    .background{
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundStyle(.clear)
                            .background(.ultraThinMaterial.opacity(1), in: RoundedRectangle(cornerRadius: 5.0, style: .continuous))
                            .padding(.leading, 15)
                    }
            }
        }
        .overlay(content: {
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    KFImage(URL(string: model.images[2].text ?? ""))
                        .placeholder { progress in
                            RoundedRectangle(cornerRadius: 15)
                                .fadeInEffect(duration: 100, isLoop: true)
                        }
                        .resizable()
                        .scaledToFill()
                        
                        .clipShape(Circle())
                        .frame(width: 30, height: 30)
                        .onTapGesture {
                            print("=== ArtistModel", model)
                            if let url = URL(string: model.url ?? "") {
                                openURL(url)
                            }
                        }
                    Spacer()
                }
                Spacer()
            }
        })
        
        .onAppear{
            artistDetailVM.getInfor(with: model.name)
        }
    }
}
