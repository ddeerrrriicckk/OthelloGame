//
//  Board.swift
//  OthelloGame
//
//

import Foundation

struct Board {
    private(set) var grid: [[Player?]]
    private(set) var currentPlayer: Player
    private let directions: [(Int, Int)] = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]
    
    init(configuration: [[Player?]]? = nil) {
        if let config = configuration {
            grid = config
            currentPlayer = .dark
        } else {
            grid = Array(repeating: Array(repeating: nil, count: 8), count: 8)
            grid[3][3] = .light
            grid[3][4] = .dark
            grid[4][3] = .dark
            grid[4][4] = .light
            currentPlayer = .dark
        }
    }
    
    
    // For unit test
    func getCellState(row: Int, col: Int) -> Player? {
        return grid[row][col]
    }
    
    mutating func switchPlayer() {
        currentPlayer = currentPlayer.opponent()
    }
    
    func getLegalMoves(for player: Player) -> [Move] {
        var legalMoves: [Move] = []

        for row in 0..<8 {
            for col in 0..<8 {
                if grid[row][col] == nil {
                    if isValidMove(player: player, row: row, col: col) {
                        legalMoves.append(Move(row: row, col: col))
                    }
                }
            }
        }

        return legalMoves
    }
    
    func isBoardFull() -> Bool {
        for row in 0..<8 {
            for col in 0..<8 {
                if grid[row][col] == nil {
                    return false
                }
            }
        }
        return true
    }
    
    func isValidMove(player: Player, row: Int, col: Int) -> Bool {
        for direction in directions {
            let dr = direction.0
            let dc = direction.1
            var currentRow = row + dr
            var currentCol = col + dc
            var foundOpponent = false
            
            while currentRow >= 0 && currentRow < 8 && currentCol >= 0 && currentCol < 8 {
                if grid[currentRow][currentCol] == player.opponent() {
                    foundOpponent = true
                } else if grid[currentRow][currentCol] == player {
                    if foundOpponent {
                        return true
                    } else {
                        break
                    }
                } else {
                    break
                }
                
                currentRow += dr
                currentCol += dc
            }
        }
        
        return false
    }
    
    func piecesToFlip(atRow row: Int, atCol col: Int, player: Player) -> [(Int, Int)] {
        var allPiecesToFlip: [(Int, Int)] = []

        for direction in directions {
            let dr = direction.0
            let dc = direction.1
            var currentRow = row + dr
            var currentCol = col + dc
            var piecesToFlip: [(Int, Int)] = []

            while currentRow >= 0 && currentRow < 8 && currentCol >= 0 && currentCol < 8 {
                if grid[currentRow][currentCol] == player.opponent() {
                    piecesToFlip.append((currentRow, currentCol))
                } else if grid[currentRow][currentCol] == player {
                    allPiecesToFlip.append(contentsOf: piecesToFlip)
                    break
                } else {
                    break
                }

                currentRow += dr
                currentCol += dc
            }
        }

        return allPiecesToFlip
    }

    func updateBoard(atRow row: Int, atCol col: Int, player: Player) -> Board {
        var newBoard = self
        newBoard.grid[row][col] = player
        
        let allPiecesToFlip = newBoard.piecesToFlip(atRow: row, atCol: col, player: player)

        for piece in allPiecesToFlip {
            newBoard.grid[piece.0][piece.1] = player
        }

        return newBoard
    }

    
    func getNumberOfPieces(for player: Player) -> Int {
        var count = 0
        
        for row in 0..<8 {
            for col in 0..<8 {
                if grid[row][col] == player {
                    count += 1
                }
            }
        }
        return count
    }
}
