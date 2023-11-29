//
//  MainView.swift
//  OthelloGame
//
//

import Foundation
import SwiftUI

struct MainView: View {
    @StateObject var viewModel = OthelloViewModel()

    var body: some View {
        TabView {
            ContentView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "gamecontroller")
                    Text("Game")
                }

            SettingsView(settingsViewModel: viewModel.settingsViewModel, viewModel: viewModel)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
