//
//  TopTrackView.swift
//  MusicLast
//
//  Created by Macbook on 16/10/24.
//

import SwiftUI

struct ListTopTrackView: View {
    @EnvironmentObject var artistTopTracksVM: ArtistTopTracksViewModel
    @EnvironmentObject var appVM: AppViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("Top Tracks")
                    .font(.title3)
                Spacer()
            }
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: appVM.dataViewStyle.column, spacing: 5) {
                    ForEach(artistTopTracksVM.models, id: \.name) { track in
                        TopTrackItemView(model: track)
                    }
                }
            }
        }
    }
}

import SwiftUI
import Kingfisher

struct TopTrackItemView: View {
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var artistTopTracksVM: ArtistTopTracksViewModel
    @StateObject var modelDetailVM = AlbumDetailViewModel()
    @Namespace var animation
    var model: ArtistTrackModel
    
    var body: some View {
        VStack(alignment: .leading) {
            if appVM.dataViewStyle != .Stack {
                VStack(alignment: .leading) {
                    KFImage(URL(string: model.image?[2].text ?? ""))
                        .resizable()
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(width: 100, height: 100)
                        .matchedGeometryEffect(id: "topTrack_image_\(model.name ?? "")", in: animation)
                    Text("\(model.name ?? "")")
                        .font(.caption.bold())
                        .lineLimit(2)
                        .frame(height: 40)
                        //.matchedGeometryEffect(id: "topAlbum_name_\(model.name ?? "")", in: animation)
                }
            }
            else {
                
                VStack(alignment: .leading) {
                    Text("\(model.name ?? "")")
                        .font(.system(size: 14, weight: .bold, design: .serif))
                        .padding(.leading, 40)
                    
                    if let detail = model.trackDetail {
                        TrackDetailItemView(track: detail, optionView: {
                            EmptyView().toAnyView()
                        })
                        .padding(.leading, 30)
                        .padding(.trailing, 5)
                        .padding(.vertical, 5)
                    }
                }
                .overlay {
                    VStack {
                        HStack(alignment: .top) {
                            KFImage(URL(string: model.image?[2].text ?? ""))
                                .placeholder { progress in
                                    RoundedRectangle(cornerRadius: 15)
                                        .fadeInEffect(duration: 100, isLoop: true)
                                }
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 30, height: 30)
                                .shadow(color: .pink, radius: 5, x: 5, y: 5)
                            
                                .matchedGeometryEffect(id: "topTrack_image_\(model.name ?? "")", in: animation)
                            
                            Spacer()
                        }
                        Spacer()
                    }
                }
                
                
                
            }
        }
        .onAppear{
            guard model.trackDetail == nil else { return }
            artistTopTracksVM.setTrackDetail(by: model.artist?.name ?? "", and: model.name  ?? "")
            /*
            guard model.detail == nil else { return }
            modelDetailVM.getInfor(by: model.name ?? "", and: model.artist?.name ?? "") { obj in
                guard let obj = obj else { return }
                artistTopTracksVM.updateDetail(at: model, by: obj)
            }
             */
        }
    }
}
