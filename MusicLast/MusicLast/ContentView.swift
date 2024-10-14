//
//  ContentView.swift
//  MusicLast
//
//  Created by Macbook on 14/10/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var appVM = AppViewModel()
    var body: some View {
        VStack {
            MainView()
        }
        .environmentObject(appVM)
    }
}
