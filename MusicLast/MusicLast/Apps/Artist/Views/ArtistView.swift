//
//  ArtistView.swift
//  MusicLast
//
//  Created by Macbook on 14/10/24.
//

import SwiftUI

struct ArtistView: View {
    @EnvironmentObject var menuVM: MenuViewModel
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var artistVM: ArtistViewModel
    
    var animation: Namespace.ID
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 10) {
                    ForEach(artistVM.models, id: \.name) { artist in
                        artist.getItemView {
                            getOptionView(with: artist).toAnyView()
                                
                        }
                        .matchedGeometryEffect(id: "Artist_\(artist.name)", in: animation)
                    }
                }
            }
        }
    }
    
    func getOptionView(with artist: ArtistModel) -> some View {
        HStack(spacing: 25) {
            Image(systemName: "heart")
                .font(.title2)
                
                .shadow(color: .pink, radius: 3, x: 3, y: 3)
            Image(systemName: "ellipsis.circle")
                .font(.title2)
                
                .shadow(color: .pink, radius: 3, x: 3, y: 3)
            
                .onTapGesture {
                    withAnimation {
                        artistVM.modelDetail = artist
                        menuVM.switchMenu(by: .ArtistDetail)
                    }
                }
        }
        .padding()
    }
}
