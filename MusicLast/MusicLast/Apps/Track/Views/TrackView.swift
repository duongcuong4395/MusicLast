//
//  TrackView.swift
//  MusicLast
//
//  Created by Macbook on 14/10/24.
//

import SwiftUI

struct TrackView: View {
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var trackVM: TrackViewModel
    @Environment(\.openURL) var openURL
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    ForEach(trackVM.models, id: \.id) { album in
                        album.getItemView {
                            EmptyView()
                        } playURL: {
                            print("=== track.URL: ", album.url ?? "")
                            if let url = album.url {
                                openURL(URL(string: url)!)
                            }
                            
                        }
                    }
                }
            }
        }
        
    }
    
}
