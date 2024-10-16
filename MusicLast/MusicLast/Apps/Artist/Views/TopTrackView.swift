//
//  TopTrackView.swift
//  MusicLast
//
//  Created by Macbook on 16/10/24.
//

import SwiftUI

struct ListTopTrackView: View {
    @EnvironmentObject var artistTopTracksVM: ArtistTopTracksViewModel
    
    @State var column: [GridItem] = [GridItem(), GridItem(), GridItem()]
    
    var body: some View {
        VStack {
            HStack {
                Text("Top Tracks")
                    .font(.title3)
                Spacer()
                Image(systemName: self.column.count == 1 ? "square.grid.3x3" : "square.fill.text.grid.1x2")
                    .font(.title2)
                    .padding()
                    .onTapGesture {
                        withAnimation {
                            self.column = self.column.count == 1 ? [GridItem(), GridItem(), GridItem()] : [GridItem()]
                        }
                    }
            }
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: column, spacing: 5) {
                    ForEach(artistTopTracksVM.models, id: \.name) { track in
                        TopTrackItemView(model: track, isShowMore: self.column.count == 1)
                    }
                }
            }
        }
    }
}

import SwiftUI
import Kingfisher

struct TopTrackItemView: View {
    @EnvironmentObject var artistTopTracksVM: ArtistTopTracksViewModel
    var model: ArtistTrackModel
    var isShowMore: Bool = false
    
    @StateObject var modelDetailVM = AlbumDetailViewModel()
    @Namespace var animation
    
    var body: some View {
        VStack(alignment: .leading) {
            if !isShowMore {
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
                HStack(alignment: .top) {
                    KFImage(URL(string: model.image?[2].text ?? ""))
                        .resizable()
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(width: 100, height: 100)
                        .matchedGeometryEffect(id: "topTrack_image_\(model.name ?? "")", in: animation)
                    VStack(alignment: .leading) {
                        Text("\(model.name ?? "")")
                            .font(.system(size: 14, weight: .bold, design: .serif))
                            
                        /*
                        if let detail = model.detail {
                            AlbumDetailItemView(model: detail)
                        }
                         */
                    }
                    Spacer()
                }
                
                
            }
        }
        .onAppear{
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
