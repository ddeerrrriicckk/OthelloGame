//
//  PlayerTurnView.swift
//  OthelloGame
//
//

import SwiftUI

struct PlayerTurnView: View {
    @ObservedObject var viewModel: OthelloViewModel
    
    var body: some View {
        Text("Current player：\(viewModel.board.currentPlayer == .dark ? "Dark" : "Light")")
            .foregroundColor(.black)
    }
}

