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
    
class AppViewModel: ObservableObject {
    @Published var textSearch: String = ""
}
