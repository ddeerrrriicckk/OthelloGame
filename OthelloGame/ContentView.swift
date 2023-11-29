//
//  ContentView.swift
//  OthelloGame
//
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = OthelloViewModel()    
    var body: some View {
        VStack(spacing: 0)  {
            ScoreView(viewModel: viewModel).frame(height: UIScreen.main.bounds.height / 10)
            PlayerTurnView(viewModel: viewModel)
            OthelloBoardView(viewModel: viewModel)
                .aspectRatio(1, contentMode: .fit)
                .padding()
            BottomButton(viewModel: viewModel).frame(height: UIScreen.main.bounds.height / 10)
        }
        .alert(item: $viewModel.activeAlert) { activeAlert in
            switch activeAlert {
                case .gameOver:
                    let winnerMessage: String
                    let scoreDark = viewModel.board.getNumberOfPieces(for: .dark)
                    let scoreLight = viewModel.board.getNumberOfPieces(for: .light)

                    if scoreDark > scoreLight {
                        winnerMessage = "Dark wins!"
                    } else if scoreLight > scoreDark {
                        winnerMessage = "Light wins!"
                    } else {
                        winnerMessage = "Game over. Tie!"
                    }

                    return Alert(
                        title: Text("Game over"),
                        message: Text(winnerMessage),
                        primaryButton: .default(Text("OK")),
                        secondaryButton: .default(Text("New Game")) {
                            viewModel.startNewGame()
                        }
                    )

                case .gameReset:
                    return Alert(
                        title: Text("Are you sure?"),
                        message: Text("Starting a new game will reset the board and all progress will be lost."),
                        primaryButton: .destructive(Text("Confirm")) {
                            viewModel.startNewGame()
                        },
                        secondaryButton: .cancel()
                    )
                case .illegalMove:
                    return Alert(
                        title: Text("Illegal Move"),
                        dismissButton: .default(Text("OK"))
                    )
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
