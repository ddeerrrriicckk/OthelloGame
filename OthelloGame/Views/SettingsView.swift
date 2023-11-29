//
//  SettingsView.swift
//  OthelloGame
//
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @ObservedObject var settingsViewModel: SettingsViewModel
    @ObservedObject var viewModel: OthelloViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Toggle("Display all currently legal moves", isOn: $settingsViewModel.showLegalMoves)
                Toggle("Passing turns model", isOn: $settingsViewModel.enablePassingTurns)
                
                Section(header: Text("Game Mode")) {
                    Picker("Game Mode", selection: $settingsViewModel.gameMode) {
                        ForEach(SettingsViewModel.GameMode.allCases) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .disabled(settingsViewModel.enablePassingTurns)
                    .onChange(of: settingsViewModel.enablePassingTurns) { value in
                        if value {
                            settingsViewModel.gameMode = .playerVsPlayer
                        }
                    }
                }

                if settingsViewModel.gameMode == .playerVsAI {
                    Section(header: Text("AI Difficulty")) {
                        Picker("Difficulty", selection: $settingsViewModel.aiDifficulty) {
                            ForEach(AIDifficulty.allCases) { difficulty in
                                Text(difficulty.rawValue).tag(difficulty)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                }
                Section {
                    Button(action: {
                        viewModel.isGameReset = true
                        if(viewModel.isGameReset) {
                            viewModel.activeAlert = .gameReset
                        }
                    }) {
                        HStack {
                            Spacer()
                            Text("Save settings")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
