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
        HStack(spacing: 20) {
            getIcon(isActive: isActive)
            Text(self.rawValue)
                .font(isActive ? .callout.bold() : .callout)
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .background(.ultraThinMaterial.opacity(isActive ? 1 : 0), in: RoundedRectangle(cornerRadius: 15, style: .continuous))
    }
    
    @ViewBuilder
    func getView(with animation: Namespace.ID) -> some View {
        switch self {
        case .Album:
            AlbumView()
                .font(.caption)
        case .Artist:
            ArtistView(animation: animation)
        case .Track:
            TrackView()
        }
    }
    
    @ViewBuilder
    func getIcon(isActive: Bool = false) -> some View {
        switch self {
        case .Album:
            Image(systemName: isActive ? "magazine.fill" : "magazine")
        case .Artist:
            Image(systemName: isActive ? "person.2.crop.square.stack.fill" : "person.2.crop.square.stack")
        case .Track:
            Image(systemName: isActive ? "newspaper.fill" : "newspaper")
        }
    }
}

class PageViewModel: ObservableObject {
    @Published var page: Page = .Album
}
