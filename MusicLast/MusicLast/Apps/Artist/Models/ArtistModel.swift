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
    
    var detail: ArtistDetailModel?
    
    enum CodingKeys: String, CodingKey {
        case images = "image"
        case name, listeners, mbid, url, streamable
        case detail
    }
}

extension ArtistModel {
    @MainActor
    func getItemView(with optionView: @escaping () -> AnyView) -> some View {
        ArtistItemView(model: self, optionView: optionView)
    }
}

struct ArtistItemView: View {
    @EnvironmentObject var artistVM: ArtistViewModel
    @StateObject var artistDetailVM = ArtistDetailViewModel()
    @Environment(\.openURL) var openURL
    var model: ArtistModel
    
    var optionView: () -> AnyView
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(model.name)
                    .font(.system(size: 14, weight: .bold, design: .serif))
                    .padding(.leading, 35)
            }
            if artistDetailVM.isLoading {
                ArtistDetailItemView(model: ArtistDetailModel()) {
                    EmptyView().toAnyView()
                }
            } else {
                if let detail = model.detail {
                    ArtistDetailItemView(model: detail, optionView: optionView)
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
            guard model.detail == nil else { return }
            artistDetailVM.getInfor(with: model.name) { obj in
                guard let obj = obj else { return }
                artistVM.updateDetail(at: model, by: obj)
            }
        }
    }
}
