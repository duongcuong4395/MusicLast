//
//  AlbumView.swift
//  MusicLast
//
//  Created by Macbook on 14/10/24.
//

import SwiftUI

struct AlbumView: View {
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var albumVM: AlbumViewModel
    
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    ForEach(albumVM.models, id: \.name) { album in
                        album.getItemView {
                            EmptyView()
                        }
                    }
                }
            }
        }
        
    }
    
}
