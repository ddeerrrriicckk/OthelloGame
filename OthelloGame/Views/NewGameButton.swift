//
//  NewGameButton.swift
//  OthelloGame
//
//

import SwiftUI

struct NewGameButton: View {
    @ObservedObject var viewModel: OthelloViewModel

    var body: some View {
        Button(action: {
//            viewModel.startNewGame()
            viewModel.isGameReset = true
            if(viewModel.isGameReset) {
                viewModel.activeAlert = .gameReset
            }
        }) {
            Text("Start a new game")
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
}
