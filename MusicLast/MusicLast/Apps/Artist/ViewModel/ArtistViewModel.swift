//
//  ArtistViewModel.swift
//  MusicLast
//
//  Created by Macbook on 14/10/24.
//

import Foundation
import SwiftUI

class ArtistViewModel: ObservableObject {
    @Published var models: [ArtistModel] = []
}

extension ArtistViewModel: MusicLastAPIEvent {
    func search(with limit: Int? = 30, and page: Int? = 1, by artist: String) {
        Task {
            let response = try await self.searchArtist(with: limit ?? 30, and: page ?? 1, by: artist)  as APIResponse
            DispatchQueue.main.async {
                withAnimation {
                    self.models = response.results.artistmatches?.artists ?? []
                }
            }
        }
    }
}
