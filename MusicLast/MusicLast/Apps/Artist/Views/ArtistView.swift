//
//  ArtistView.swift
//  MusicLast
//
//  Created by Macbook on 14/10/24.
//

import SwiftUI

struct ArtistView: View {
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var artistVM: ArtistViewModel
    @Environment(\.openURL) var openURL
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    ForEach(artistVM.models, id: \.name) { album in
                        album.getItemView {
                            EmptyView()
                        } playURL: {
                            
                            openURL(URL(string: album.url ?? "")!)
                        }
                    }
                }
            }
        }
        
    }
    
}
