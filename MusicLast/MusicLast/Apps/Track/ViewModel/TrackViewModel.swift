//
//  TrackViewModel.swift
//  MusicLast
//
//  Created by Macbook on 14/10/24.
//

import Foundation
import SwiftUI

class TrackViewModel: ObservableObject {
    @Published var models: [TrackModel] = []
}

extension TrackViewModel: MusicLastAPIEvent {
    func search(with limit: Int? = 30, and page: Int? = 1, by track: String, of artist: String? = "") {
        Task {
            let response = try await self.searchTrack(with: limit ?? 30, and: page ?? 1, by: track, of: artist ?? "")  as APIResponse
            DispatchQueue.main.async {
                withAnimation {
                    self.models = response.results.trackmatches?.tracks ?? []
                }
            }
            
        }
    }
}


class TrackDetailViewModel: ObservableObject {
    @Published var model: Track?
}

extension TrackDetailViewModel: MusicLastAPIEvent {
    func getTrackDetail(by artist: String, and track: String) {
        Task {
            let response = try await self.getInfoTrack(by: artist, and: track) as InfoTrackResponse
            self.model = response.track
        }
    }
}

