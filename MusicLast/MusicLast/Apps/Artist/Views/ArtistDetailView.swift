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
    @StateObject var artistTopTracksVM = ArtistTopTracksViewModel()
    var animation: Namespace.ID
    
    var body: some View {
        ScrollView(showsIndicators: false) {
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
                    .frame(height: UIScreen.main.bounds.height/2.5)
                // MARK: Top Tracks
                ListTopTrackView()
                    .frame(height: UIScreen.main.bounds.height/2.5)
                Spacer()
                
            }
        }
        .onAppear{
            if let artist = artistVM.modelDetail {
                artistTopAlbumsVM.getTopAlbums(with: artist.name)
                artistTopTracksVM.getTopTracks(by: artist.name)
            }
            
        }
        .environmentObject(artistTopTracksVM)
        .environmentObject(artistTopAlbumsVM)
    }
}
