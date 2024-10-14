//
//  AlbumViewModel.swift
//  MusicLast
//
//  Created by Macbook on 14/10/24.
//

import Foundation


class AlbumViewModel: ObservableObject {
    @Published var models: [AlbumModel] = []
}

import SwiftUI

extension AlbumViewModel: MusicLastAPIEvent {
    func search(with limit: Int? = 30, and page: Int? = 1, by album: String) {
        Task {
            let response = try await self.searchAlbum(with: limit ?? 30, and: page ?? 1, by: album) as APIResponse
            DispatchQueue.main.async {
                withAnimation {
                    self.models = response.results.albummatches?.albums ?? []
                }

            }
        }
    }
}



