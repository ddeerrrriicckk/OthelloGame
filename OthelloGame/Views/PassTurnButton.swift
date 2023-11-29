//
//  PassTurnButton.swift
//  OthelloGame
//
//

import SwiftUI

struct PassTurnButton: View {
    @ObservedObject var viewModel: OthelloViewModel
    
    var body: some View {
        if viewModel.showPassTurnButton {
            Button(action: {
                viewModel.passTurn()
            }) {
                Text("Pass Turn")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
    }
}

struct PassTurnButton_Previews: PreviewProvider {
    static var previews: some View {
        PassTurnButton(viewModel: OthelloViewModel())
    }
}
