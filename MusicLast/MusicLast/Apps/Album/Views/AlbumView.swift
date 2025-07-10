//
//  AlbumView.swift
//  MusicLast
//
//  Created by Macbook on 14/10/24.
//

import SwiftUI

struct AlbumView: View {
    @EnvironmentObject var albumVM: AlbumViewModel
    
    var body: some View {
        VStack {
            ListAlbumView(models: albumVM.models) {}
        }
    }
}

struct ListAlbumView: View {
    @EnvironmentObject var appVM: AppViewModel
    var models: [Album]
    var title: String? = nil
    
    var endListItemAction: () -> Void
    
    var body: some View {
        VStack {
            if let title = title {
                HStack {
                    Text(title)
                        .font(.title3)
                    Spacer()
                }
            }
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: appVM.dataViewStyle.column, spacing: 5) {
                    ForEach(models, id: \.name) { album in
                        album.getItemView {
                            EmptyView().toAnyView()
                        }
                        /*
                        if ind == models.count - 1 {
                            Image(systemName: "ellipsis")
                                .font(.title3.bold())
                                .onTapGesture {
                                    endListItemAction()
                                }
                        }
                        */
                    }
                }
            }
        }
        
    }
}
