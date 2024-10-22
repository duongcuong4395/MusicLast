//
//  MainView.swift
//  MusicLast
//
//  Created by Macbook on 14/10/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var appVM: AppViewModel
    
    @StateObject var menuVM = MenuViewModel()
    
    @StateObject var pageVM = PageViewModel()
    @StateObject var albumVM = AlbumViewModel()
    @StateObject var artistVM = ArtistViewModel()
    @StateObject var trackVM = TrackViewModel()
    
    @Namespace private var animation
    
    var body: some View {
        VStack {
            HStack {
                Text("Last.fm")
                    .font(.system(size: 35, weight: .bold, design: .serif))
                    .foregroundStyle(.red)
                    .onTapGesture {
                        guard menuVM.menu != .Search else { return }
                        withAnimation {
                            menuVM.menu = .Search
                        }
                    }
                Spacer()
                Image(systemName: "heart")
                    .font(.title2)
                appVM.dataViewStyle.itemView
                    .onTapGesture {
                        withAnimation(.spring()) {
                            appVM.dataViewStyle = appVM.dataViewStyle == .Grid3X3 ? .Stack : .Grid3X3
                        }
                    }
            }
            
            Text("Get your own music profile at Last.fm, the world’s largest social music platform.")
                .font(.caption)
            menuVM.menu.getView(with: animation)
        }
        .padding()
        .environmentObject(pageVM)
        .environmentObject(menuVM)
        .environmentObject(albumVM)
        .environmentObject(artistVM)
        .environmentObject(trackVM)
        .onChange(of: appVM.textSearch) { oldValue, newValue in
            print("== searchChange", newValue)
            if newValue.isEmpty {
                withAnimation(.spring()) {
                    albumVM.models = []
                    artistVM.models = []
                    trackVM.models = []
                }
            } else {
                albumVM.search(by: appVM.textSearch)
                artistVM.search(by: appVM.textSearch)
                trackVM.search(by: appVM.textSearch)
            }
            
        }
    }
}

struct SearchPageView: View {
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var pageVM: PageViewModel
    @EnvironmentObject var albumVM: AlbumViewModel
    @EnvironmentObject var artistVM: ArtistViewModel
    @EnvironmentObject var trackVM: TrackViewModel
    var animation: Namespace.ID
    
    var body: some View {
        VStack {
            
            TextFieldSearchView(listModels: .constant([albumVM.models, artistVM.models, trackVM.models]) ) {
                print("Search text")
            }
            Divider()
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
            pageVM.page.getView(with: animation)
        }
    }
}

struct TextFieldSearchView: View {
    @EnvironmentObject var appVM: AppViewModel
    
    @Binding var listModels: [[Any]]

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
