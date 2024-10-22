//
//  TopAlbumIView.swift
//  MusicLast
//
//  Created by Macbook on 16/10/24.
//

struct ListTopAlbumView: View {
    @EnvironmentObject var artistTopAlbumsVM: ArtistTopAlbumsViewModel
    @EnvironmentObject var appVM: AppViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("Top Albums")
                    .font(.title3)
                Spacer()
            }
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: appVM.dataViewStyle.column, spacing: 5) {
                    ForEach(artistTopAlbumsVM.models, id: \.name) { album in
                        TopAlbumItemView(model: album, isShowMore: appVM.dataViewStyle == .Stack) //  self.column.count == 1
                    }
                }
            }
        }
        
    }
}

import SwiftUI
import Kingfisher

struct TopAlbumItemView: View {
    @EnvironmentObject var artistTopAlbumsVM: ArtistTopAlbumsViewModel
    var model: Album
    var isShowMore: Bool = false
    
    @StateObject var modelDetailVM = AlbumDetailViewModel()
    @Namespace var animation
    
    var body: some View {
        ZStack {
            if !isShowMore {
                VStack {
                    KFImage(URL(string: model.image?[2].text ?? ""))
                        .resizable()
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(width: 50, height: 50)
                        .matchedGeometryEffect(id: "topAlbum_image_\(model.name ?? "")", in: animation)
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
                        .matchedGeometryEffect(id: "topAlbum_image_\(model.name ?? "")", in: animation)
                    VStack(alignment: .leading) {
                        Text("\(model.name ?? "")")
                            .font(.system(size: 14, weight: .bold, design: .serif))
                            //.matchedGeometryEffect(id: "topAlbum_name_\(model.name ?? "")", in: animation)
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
            modelDetailVM.getInfor(by: model.name ?? "", and: model.artist?.name ?? "") { obj in
                guard let obj = obj else { return }
                artistTopAlbumsVM.updateDetail(at: model, by: obj)
            }
        }
    }
}
