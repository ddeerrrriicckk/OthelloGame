//
//  SettingsViewModel.swift
//  OthelloGame
//
//

import Foundation

class SettingsViewModel: ObservableObject {
    @Published var showLegalMoves: Bool = true
    @Published var gameMode: GameMode = .playerVsPlayer
    @Published var aiDifficulty: AIDifficulty = .easy
    @Published var enablePassingTurns = false
    
    enum GameMode: String, CaseIterable, Identifiable {
        case playerVsPlayer = "Player vs Player"
        case playerVsAI = "Player vs AI"

        var id: String { rawValue }
    }
}
