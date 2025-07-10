//
//  AlbumViewModel.swift
//  MusicLast
//
//  Created by Macbook on 14/10/24.
//

import Foundation


class AlbumViewModel: ObservableObject {
    @Published var models: [Album] = []
}



import SwiftUI

extension AlbumViewModel: MusicLastAPIEvent {
    func updateDetail2(at model: Album, by item: AlbumDetailModel) {
        if let index = models.firstIndex(where: { $0.name == model.name }) {
            models[index].detail = item
        }
    }
    
    func updateDetail(at albumName: String, by item: AlbumDetailModel) {
        if let index = models.firstIndex(where: { $0.name == albumName }) {
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

// With artist
extension AlbumViewModel {
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

// With Tag
extension AlbumViewModel {
    func getList(by tag: String, and limit: Int, of page: Int) {
        Task {
            let response = try await self.getAlbums(by: tag, and: limit, of: page) as TagAlbumsResponse
            DispatchQueue.main.async {
                self.models = response.albums?.album ?? []
            }
        }
    }
    
    func pullList(from listTag: [Tag]) {
        for item in listTag {
            Task {
                let response = try await self.getAlbums(by: item.name ?? "", and: 5, of: 1) as TagAlbumsResponse
                DispatchQueue.main.async {
                    self.models += response.albums?.album ?? []
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
                    
                    completion(self.model)
                }
            }
            
        }
        
    }
}


