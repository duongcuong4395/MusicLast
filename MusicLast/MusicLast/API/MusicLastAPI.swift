//
//  MusicLastAPI.swift
//  MusicLast
//
//  Created by Macbook on 14/10/24.
//

import Foundation
import Alamofire



enum APIMethod: String {
    case Album
    case Artist
    case Track
}

//case Chart
//case Tag

enum MusicLastAPIEndPoint<T: Decodable> {
    case SearchAlbum(limit: Int, page: Int, album: String)
    case SearchArtist(limit: Int, page: Int, artist: String)
    case SearchTrack(limit: Int, page: Int, artist: String?, track: String)
    
}

extension MusicLastAPIEndPoint: HttpRouter {
    typealias responseDataType = T
    
    var baseURL: String {
        AppUtility.BaseURL
    }
    
    var path: String {
        switch self {
        case .SearchAlbum(limit: _, page: _, album: _)
            , .SearchArtist(limit: _, page: _, artist: _)
            , .SearchTrack(limit: _, page: _, artist: _, track: _):
            "2.0/"
        }
    }
    
    var menthod: Alamofire.HTTPMethod {
        switch self {
        case .SearchAlbum(limit: _, page: _, album: _)
            , .SearchArtist(limit: _, page: _, artist: _)
            , .SearchTrack(limit: _, page: _, artist: _, track: _):
                .get
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        return nil
    }
    
    var parameters: Alamofire.Parameters? {
        switch self {
        case .SearchAlbum(limit: let limit, page: let page, album: let album):
            return ["limit": limit, "page": page, "method": "album.search", "album": album, "api_key": AppUtility.Key, "format": "json"]
        case .SearchArtist(limit: let limit, page: let page, artist: let artist):
            return ["limit": limit, "page": page, "method": "artist.search", "artist": artist, "api_key": AppUtility.Key, "format": "json"]
        case .SearchTrack(limit: let limit, page: let page, artist: let artist, track: let track):
            return ["limit": limit, "page": page, "method": "track.search", "album": artist, "track": track, "api_key": AppUtility.Key, "format": "json"]
        }
    }
    
    var body: Data? {
        return  nil
    }
}


protocol MusicLastAPIEvent {
    //func searchAlbum(with limit: Int, and page: Int, by album: String)
    //func searchArtist(with limit: Int, and page: Int, by artist: String)
    //func searchTrack(with limit: Int, and page: Int, by track: String, of artist: String)
}

extension MusicLastAPIEvent {
    func performRequest<T: Decodable>(for api: MusicLastAPIEndPoint<T>) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            let request = APIRequest(router: api)
            request.callAPI { result in
                switch result {
                case .Successs(let data):
                    continuation.resume(returning: data)
                case .Failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func searchAlbum<T: Decodable>(with limit: Int, and page: Int, by album: String) async throws -> T  {
        return try await performRequest(for: .SearchAlbum(limit: limit, page: page, album: album))
    }
    
    func searchArtist<T: Decodable>(with limit: Int, and page: Int, by artist: String) async throws -> T {
        return try await performRequest(for: .SearchArtist(limit: limit, page: page, artist: artist))
    }
    
    func searchTrack<T: Decodable>(with limit: Int, and page: Int, by track: String, of artist: String) async throws -> T {
        return try await performRequest(for: .SearchTrack(limit: limit, page: page, artist: artist, track: track))
    }
}
