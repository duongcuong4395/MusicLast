//
//  MainView.swift
//  MusicLast
//
//  Created by Macbook on 14/10/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var appVM: AppViewModel
    
    @StateObject var pageVM = PageViewModel()
    @StateObject var albumVM = AlbumViewModel()
    @StateObject var artistVM = ArtistViewModel()
    @StateObject var trackVM = TrackViewModel()
    
    var body: some View {
        VStack {
            Text("Last.fm")
                .font(.system(size: 20, weight: .bold, design: .serif))
                .foregroundStyle(.red)
            Text("Get your own music profile at Last.fm, the world’s largest social music platform.")
                .font(.caption)
            TextFieldSearchView(listModels: []) {
                print("Search text")
            }
            HStack {
                ForEach(Page.allCases, id: \.self) { page in
                    page.getItemView(isActive: pageVM.page == page)
                        .onTapGesture {
                            withAnimation {
                                pageVM.page = page
                            }
                        }
                }
            }
            pageVM.page.getView()
        }
        .padding()
        .environmentObject(albumVM)
        .environmentObject(artistVM)
        .environmentObject(trackVM)
        .onChange(of: appVM.textSearch) { oldValue, newValue in
            albumVM.search(by: appVM.textSearch)
            artistVM.search(by: appVM.textSearch)
            trackVM.search(by: appVM.textSearch)
        }
    }
}

struct TextFieldSearchView: View {
    @EnvironmentObject var appVM: AppViewModel
    
    @State var listModels: [[Any]]

    @State var showClear: Bool = true
    
    var action: () -> Void
    
    var body: some View {
        HStack{
            Image(systemName: "magnifyingglass")
                //.foregroundStyleItemView(by: appMode)
                .padding(.leading, 5)
            TextField("Enter album, track, artist", text: $appVM.textSearch)
                //.foregroundStyleItemView(by: appMode)
                
            if showClear {
                if !appVM.textSearch.isEmpty {
                    Button(action: {
                        self.appVM.textSearch = ""
                        for i in 0..<listModels.count {
                            listModels[i] = []
                        }
                    }, label: {
                        Image(systemName: "xmark.circle")
                    })
                    //.foregroundStyleItemView(by: appMode)
                    .padding(.trailing, 5)
                }
            }
        }
        .padding(.vertical, 3)
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 10, style: .continuous)
        )
        //.edgesIgnoringSafeArea(.bottom)
        .onChange(of: appVM.textSearch) { oldValue, newValue in
            action()
        }
    }
}


extension View {
    func toAnyView() -> AnyView {
        AnyView(self)
    }
}
