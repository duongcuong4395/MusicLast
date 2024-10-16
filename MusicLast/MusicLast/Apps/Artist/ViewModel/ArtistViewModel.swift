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
    @Published var modelDetail: ArtistModel?
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
    
    func updateDetail(at model: ArtistModel, by item: ArtistDetailModel) {
        if let index = models.firstIndex(where: { $0.name == model.name }) {
            models[index].detail = item
        }
    }
}



class ArtistDetailViewModel: ObservableObject {
    @Published var model: ArtistDetailModel?
    @Published var isLoading: Bool = false
}

extension ArtistDetailViewModel : MusicLastAPIEvent{
    func getInfor(with artist: String, completion: @escaping (ArtistDetailModel?) -> Void) {
        self.isLoading = true
        Task {
            let response = try await self.getInforArtist(by: artist) as ArtistDetailResponse
            DispatchQueue.main.async {
                withAnimation {
                    self.model = response.artist
                    self.isLoading = false
                    completion(self.model)
                }
            }
        }
    }
}

class ArtistTopAlbumsViewModel: ObservableObject {
    @Published var models: [Album] = []
}

extension ArtistTopAlbumsViewModel : MusicLastAPIEvent{
    
    func updateDetail(at model: Album, by item: AlbumDetailModel) {
        if let index = models.firstIndex(where: { $0.name == model.name }) {
            models[index].detail = item
        }
    }
    
    func getTopAlbums(with artist: String) {
        Task {
            let response = try await self.getTopAlbums(by: artist) as ArtistTopalbumsResponse
            DispatchQueue.main.async {
                withAnimation {
                    self.models = response.topalbums?.albums ?? []
                }
            }
        }
    }
}

class ArtistTopTracksViewModel: ObservableObject {
    @Published var models: [ArtistTrackModel] = []
}

extension ArtistTopTracksViewModel: MusicLastAPIEvent {
    func getTopTracks(by artist: String) {
        Task {
            let res = try await self.getTopTracks(by: artist) as ArtistTopTrackResponse
            DispatchQueue.main.async {
                self.models = res.toptracks?.track ?? []
            }
        }
    }
}
