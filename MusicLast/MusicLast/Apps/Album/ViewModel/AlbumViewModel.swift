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
    func updateDetail(at model: AlbumModel, by item: AlbumDetailModel) {
        if let index = models.firstIndex(where: { $0.name == model.name }) {
            models[index].detail = item
        }
    }
    
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



class AlbumDetailViewModel: ObservableObject {
    @Published var model: AlbumDetailModel?
}

extension AlbumDetailViewModel : MusicLastAPIEvent{
    func getInfor(by album: String, and artist: String? = "", completion: @escaping (AlbumDetailModel?) -> Void) {
        Task {
            let response = try await self.getInforAlbum(by: album, and: artist ?? "") as AlbumDetailResponse
            DispatchQueue.main.async {
                withAnimation {
                    self.model = response.album
                    
                    print("=== getInfor",album, artist, response.album?.tags ?? [])
                    completion(self.model)
                }
            }
            
        }
        
    }
}


