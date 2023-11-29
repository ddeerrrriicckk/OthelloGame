//
//  BottomBotton.swift
//  OthelloGame
//
//

import SwiftUI

struct BottomButton: View {
    @ObservedObject var viewModel: OthelloViewModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .frame(width: UIScreen.main.bounds.width * 0.9)
            if !viewModel.showPassTurnButton {
                Button(action: {
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
            } else {
                HStack {
                    Button(action: {
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
                    Spacer()
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
                .frame(width: UIScreen.main.bounds.width * 0.8)
            }
            
        }
    }
}

struct BottomButton_Previews: PreviewProvider {
    static var previews: some View {
        BottomButton(viewModel: OthelloViewModel())
    }
}
