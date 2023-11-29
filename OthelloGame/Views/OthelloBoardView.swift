//
//  OthelloBoardView.swift
//  OthelloGame
//
//

import SwiftUI

struct OthelloBoardView: View {
    @ObservedObject var viewModel: OthelloViewModel

    let gridSize = 8
    var body: some View {
        //The GeometryReader is used to dynamically determine the size of the view.
        GeometryReader { geometry in
            //Multiplying by 0.9 to create a buffer around the edges of the grid.
            let size = min(geometry.size.width, geometry.size.height) * 0.9
            let squareSize = size / CGFloat(gridSize)
            
            ZStack {
                Rectangle()
                    .fill(Color.white)
                VStack(spacing: 0) {
                    ForEach(0..<gridSize, id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<gridSize, id: \.self) { col in
                                Rectangle()
                                    .fill(
                                        row % 2 == col % 2 ? Color.green : Color.green.opacity(0.8)
                                    )
                                    .frame(width: squareSize, height: squareSize)
                                    .border(Color.black, width: 1)
                                    .overlay(
                                        //Show the legal moves
                                        Circle()
                                            .fill(Color.gray)
                                            .frame(width: squareSize * 0.8, height: squareSize * 0.8)
                                            .opacity(viewModel.legalMoves.contains(where: { $0.row == row && $0.col == col }) && viewModel.settingsViewModel.showLegalMoves ? 0.5 : 0))

                                    .overlay(
                                        Circle()
                                            .fill(viewModel.board.grid[row][col] == .dark ? Color.black : Color.white)
                                            .frame(width: squareSize * 0.8, height: squareSize * 0.8)
                                            .opacity(viewModel.board.grid[row][col] != nil ? 1 : 0)
                                        
                                    ).onTapGesture {
                                        viewModel.userTapped(row: row, col: col)
                                    }
                            }
                        }
                    }
                }
                .frame(width: size, height: size)
                .overlay(
                    // The Rectangle with a stroke is used to draw the square.
                    Rectangle()
                        .stroke(Color.black, lineWidth: 1)
                )
            }
        }
    }
}


struct OthelloView_Previews: PreviewProvider {
    static var previews: some View {
        OthelloBoardView(viewModel: OthelloViewModel())
    }
}

