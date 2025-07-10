//
//  TopTagView.swift
//  MusicLast
//
//  Created by Macbook on 22/10/24.
//

import SwiftUI
import WrappingHStack

struct TopTagView: View {
    @EnvironmentObject var tagVM: TagViewModel
    @EnvironmentObject var albumVM: AlbumViewModel
    
    @Namespace var anim
    
    var body: some View {
        ZStack {
            VStack {
                WrappingHStack {
                    ForEach(tagVM.tagsSelected, id: \.tag.name) { tag in
                        tag.tag.getItemView()
                            .matchedGeometryEffect(id: "tag_\(tag.tag.name ?? "")", in: anim)
                            .onTapGesture {
                                withAnimation{
                                    tagVM.add(item: tag.tag)
                                    tagVM.RemoveTagSelected(by: tag.tag)
                                }
                            }
                    }
                }
                if tagVM.tagsSelected.count > 0 {
                    Divider()
                        .padding()
                    
                } else {
                    ScrollView(showsIndicators: false) {
                        WrappingHStack(horizontalSpacing: 10, verticalSpacing: 10) {
                            ForEach(tagVM.models, id: \.name) { tag in
                                tag.getItemView()
                                    .matchedGeometryEffect(id: "tag_\(tag.name ?? "")", in: anim)
                                    .onTapGesture {
                                        withAnimation {
                                            tagVM.select(by: tag)
                                            tagVM.remove(at: tag)
                                            
                                            tagVM.pullAlbum(from: tag)
                                        }
                                    }
                            }
                        }
                    }
                }
                
                ForEach(tagVM.tagsSelected, id: \.tag.name) { tag in
                    ListAlbumView(models: tag.albums) {
                        withAnimation {
                            tagVM.pullAlbum(from: tag.tag)
                        }
                    }
                }
            }
        }
    }
}

import AVKit

struct VideoPlayerView: View {
    let videoURL: URL
    
    var body: some View {
        VideoPlayer(player: AVPlayer(url: videoURL))
            .onAppear() {
                let player = AVPlayer(url: videoURL)
                player.play()
            }
    }
}

import WebKit

struct WebView: UIViewRepresentable {
    let url: URL?

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = url {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}
