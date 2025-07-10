//
//  TagViewModel.swift
//  MusicLast
//
//  Created by Macbook on 22/10/24.
//

import Foundation

class TagViewModel: ObservableObject {
    @Published var models: [Tag] = []
    @Published var tagsSelected: [(tag: Tag, albums: [Album])] = []
}

extension TagViewModel {
    func sortList() {
        self.models = self.models.sorted(by: {$0.name ?? "" < $1.name ?? ""})
    }
}

// MARK: For Models
extension TagViewModel {
    func remove(at item: Tag) {
        self.models.removeAll(where: {$0.name == item.name})
        sortList()
    }
     
    func add(item: Tag) {
        models.append(item)
        sortList()
    }
}

// MARK: For Selected
extension TagViewModel{
    func select(by tag: Tag) {
        self.tagsSelected.append((tag: tag, albums: []))
    }
    
    func RemoveTagSelected(by tag: Tag) {
        self.tagsSelected.removeAll(where: { $0.tag.name == tag.name })
    }
}

extension TagViewModel: MusicLastAPIEvent {
    func getList() {
        Task {
            let response = try await self.getTopTags() as TopTagsResponse
            DispatchQueue.main.async {
                self.models = response.toptags?.tags ?? []
                self.sortList()
            }
        }
    }
    
    func pullAlbum(from tag: Tag) {
        guard let index = tagsSelected.firstIndex(where: { $0.tag.name == tag.name }) else { return }
        
        Task {
            let currentPage: Int = Int(self.tagsSelected[index].albums.count / 5)
            let response = try await self.getAlbums(by: tag.name ?? "", and: 5, of: currentPage + 1) as TagAlbumsResponse
            
            DispatchQueue.main.async {
                self.tagsSelected[index].albums += response.albums?.album ?? []
            }
        }
    }
    
    func updateDetail(at albumName: String, by item: AlbumDetailModel) {
        if let index = models.firstIndex(where: { $0.name == albumName }) {
            models[index].detail = item
        }
    }
    
}
