//
//  AppViewModel.swift
//  MusicLast
//
//  Created by Macbook on 14/10/24.
//

import Foundation

class AppUtility {
    static let envDict = Bundle.main.infoDictionary?["LSEnvironment"] as! Dictionary<String, String>
    
    static let BaseURL = envDict["BaseURL"]! as String
    static let Key = envDict["Key"]! as String
}
 
import SwiftUI

enum DataViewStyle: String, CaseIterable {
    case Grid3X3
    case Stack
    
    var itemView: some View {
        VStack {
            switch self {
            case .Grid3X3:
                Image(systemName: "square.grid.3x3")
            case .Stack:
                Image(systemName: "square.fill.text.grid.1x2")
            }
        }
        .font(.title2)
        .padding()
    }
    
    var column: [GridItem] {
        switch self {
        case .Grid3X3:
            return [GridItem(), GridItem(), GridItem()]
        case .Stack:
            return [GridItem()]
        }
    }
}

class AppViewModel: ObservableObject {
    @Published var textSearch: String = ""
    
    @Published var dataViewStyle: DataViewStyle = .Grid3X3
}
