//
//  ArtistDetailView.swift
//  MusicLast
//
//  Created by Macbook on 16/10/24.
//

import SwiftUI

struct ArtistDetailView: View {
    @EnvironmentObject var artistVM: ArtistViewModel
    @EnvironmentObject var menuVM: MenuViewModel
    @StateObject var artistTopAlbumsVM = ArtistTopAlbumsViewModel()
    
    var animation: Namespace.ID
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            menuVM.switchMenu(by: .Search)
                        }
                        
                    }
                Text("Back")
                    .font(.title3)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            menuVM.switchMenu(by: .Search)
                        }
                    }
                Spacer()
                Image(systemName: "heart")
                    .font(.title2)
            }
            Divider()
            if let artist = artistVM.modelDetail {
                ArtistItemView(model: artist) {
                    EmptyView().toAnyView()
                }
                .matchedGeometryEffect(id: "Artist_\(artist.name)", in: animation)
            }
            
            // MARK: Top Album
            ListTopAlbumView()
            // MARK: Top Tracks
            
            Spacer()
            
        }
        .onAppear{
            if let artist = artistVM.modelDetail {
                artistTopAlbumsVM.getTopAlbums(with: artist.name)
            }
            
        }
        .environmentObject(artistTopAlbumsVM)
    }
}
