//
//  MenuViewModel.swift
//  MusicLast
//
//  Created by Macbook on 14/10/24.
//

import Foundation

enum Menu: String, CaseIterable {
    case Search
    case ArtistDetail
}

import SwiftUI
extension Menu {
    @ViewBuilder
    func getView(with animation: Namespace.ID) -> some View {
        switch self {
        case .Search:
            SearchPageView(animation: animation)
        case .ArtistDetail:
            ArtistDetailView(animation: animation)
        }
    }
}

class MenuViewModel: ObservableObject {
    @Published var menu: Menu = .Search
}

extension MenuViewModel {
    func switchMenu(by menu: Menu) {
        self.menu = menu
    }
}

enum Page: String, CaseIterable {
    case Album
    case Artist
    case Track
}

import SwiftUI
extension Page {
    func getItemView(isActive: Bool = false) -> some View {
        HStack {
            Text(self.rawValue)
                .font(isActive ? .caption.bold() : .caption)
                .padding()
                .background(.ultraThinMaterial.opacity(isActive ? 1 : 0), in: RoundedRectangle(cornerRadius: 15, style: .continuous))
        }
    }
    
    @ViewBuilder
    func getView(with animation: Namespace.ID) -> some View {
        switch self {
        case .Album:
            AlbumView()
        case .Artist:
            ArtistView(animation: animation)
        case .Track:
            TrackView()
        }
    }
}

class PageViewModel: ObservableObject {
    @Published var page: Page = .Album
}
