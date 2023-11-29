//
//  OthelloViewModel.swift
//  OthelloGame
//
//

import SwiftUI

struct Move: Hashable, Identifiable {
    let row: Int
    let col: Int

    var id: Self { self }
}


class OthelloViewModel: ObservableObject {
    @Published private(set) var board = Board()
    @Published private(set) var legalMoves: [Move] = []
    @Published private(set) var darkScore: Int
    @Published private(set) var lightScore: Int
    @Published var settingsViewModel = SettingsViewModel()
    @Published var activeAlert: ActiveAlert?
    @Published var isGameOver: Bool = false
    @Published var isGameReset: Bool = false
    @Published private(set) var isAIThinking = false
    @Published private(set) var consecutivePasses = 0
    @Published var showPassTurnButton: Bool = false
    
    init() {
        board = Board()
        darkScore = 2
        lightScore = 2
        legalMoves = []
        calculateLegalMoves()
        settingsViewModel = SettingsViewModel()
    }
    
    // For unit test
    var boardConfiguration: [[Player?]]? {
        didSet {
            if let configuration = boardConfiguration {
                board = Board(configuration: configuration)
            } else {
                board = Board()
            }
        }
    }
    
    // calculate legal moves
    func calculateLegalMoves() {
        legalMoves = board.getLegalMoves(for: board.currentPlayer)
    }
    
    func switchToNextPlayer() {
        
        board.switchPlayer()
        consecutivePasses = 0 // Reset consecutive pass counter
        calculateLegalMoves()

        // Increment the continuous pass counter if the current player cannot move
        if legalMoves.isEmpty && !board.isBoardFull(){
            consecutivePasses += 1
            if (settingsViewModel.enablePassingTurns) {
                showPassTurnButton = true
                print("showPassTurnButton: \(showPassTurnButton)")
            }
        } else if board.isBoardFull() {
            isGameOver = true
            activeAlert = .gameOver
        }
    }
    
    // Start new game
    func startNewGame() {
        board = Board()
        darkScore = 2
        lightScore = 2
        legalMoves = []
        calculateLegalMoves()
    }
    
    // Update the number of dark and light pieces on the board
    private func updateScores() {
        darkScore = board.getNumberOfPieces(for: .dark)
        lightScore = board.getNumberOfPieces(for: .light)
    }
    
    // Handle user clicks
    func userTapped(row: Int, col: Int) {
        if isAIThinking {return}
        
        if legalMoves.contains(where: { $0.row == row && $0.col == col }) {
            board = board.updateBoard(atRow: row, atCol: col, player: board.currentPlayer)
            updateScores()
            switchToNextPlayer()
            checkGameOver()
            if settingsViewModel.gameMode == .playerVsAI && board.currentPlayer == .light {
                isAIThinking = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.makeAIMove()
                }
            }
        } else {
            activeAlert = .illegalMove
        }
    }
    
    private func aiMoveIfNeeded() {
        print("settingsViewModel.gameMode: \(settingsViewModel.gameMode)")
        print("board.currentPlayer: \(board.currentPlayer)")
        if settingsViewModel.gameMode == .playerVsAI && board.currentPlayer == .light {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.makeAIMove()
                self.updateScores()
                self.board.switchPlayer()
                self.checkGameOver()
            }
        }
    }

    func makeAIMove() {
           calculateLegalMoves()
           guard let aiMove = getAIMove(aiDifficulty: settingsViewModel.aiDifficulty) else { return }
           board = board.updateBoard(atRow: aiMove.row, atCol: aiMove.col, player: board.currentPlayer)
           updateScores()
           switchToNextPlayer()
           checkGameOver()
           isAIThinking = false
       }
    
    private func getAIMove(aiDifficulty: AIDifficulty) -> Move? {
        switch aiDifficulty {
            case .easy:
                return getEasyMove()
            case .medium:
                return getMediumMove()
            case .hard:
                return getHardMove()
        }
    }
    
    // getEasyMove
    private func getEasyMove() -> Move? {
        return legalMoves.randomElement()
    }

    
    // getMediumMove
    private func getMediumMove() -> Move? {
        return legalMoves.max(by: { heuristicScore(move: $0) < heuristicScore(move: $1) })
    }

    private func heuristicScore(move: Move) -> Int {
        let flippedCount = board.piecesToFlip(atRow: move.row, atCol: move.col, player: board.currentPlayer).count
        let positionScore = isCorner(row: move.row, col: move.col) ? 4 : isEdge(row: move.row, col: move.col) ? 2 : 1

        return flippedCount * positionScore
    }

    private func isCorner(row: Int, col: Int) -> Bool {
        return (row == 0 || row == 7) && (col == 0 || col == 7)
    }

    private func isEdge(row: Int, col: Int) -> Bool {
        return row == 0 || row == 7 || col == 0 || col == 7
    }

    
    // getHardMove
    private func getHardMove() -> Move? {
        let player = board.currentPlayer
        var bestMove: Move? = nil
        var bestScore = Int.min
        let maxSearchTime = 5.0 // Limit search time to 5 seconds

        for depth in 1...4 { // Gradually deepen the search depth
            let startTime = CACurrentMediaTime()
            let result = alphaBeta(board: board, depth: depth, alpha: Int.min, beta: Int.max, maximizingPlayer: true, player: player)
            let endTime = CACurrentMediaTime()

            if let move = result.move, result.score > bestScore {
                bestMove = move
                bestScore = result.score
            }

            if endTime - startTime > maxSearchTime { // The search time has exceeded the limit
                break
            }
        }
        return bestMove
    }

    
    var alphaBetaNodes = 0

    private func alphaBeta(board: Board, depth: Int, alpha: Int, beta: Int, maximizingPlayer: Bool, player: Player) -> (score: Int, move: Move?) {
        alphaBetaNodes += 1
        if depth == 0 || isGameOver {
            let score = board.getNumberOfPieces(for: player) - board.getNumberOfPieces(for: player.opponent())
            return (score: score, move: nil)
        }

        var bestMove: Move?
        var bestScore = maximizingPlayer ? Int.min : Int.max
        var currentAlpha = alpha
        var currentBeta = beta

        let legalMoves = board.getLegalMoves(for: player)

        for move in legalMoves {
            let newBoard = board.updateBoard(atRow: move.row, atCol: move.col, player: player)
            let result = alphaBeta(board: newBoard, depth: depth - 1, alpha: currentAlpha, beta: currentBeta, maximizingPlayer: !maximizingPlayer, player: player.opponent())

            if maximizingPlayer {
                if result.score > bestScore {
                    bestScore = result.score
                    bestMove = move
                }
                currentAlpha = max(currentAlpha, bestScore)
            } else {
                if result.score < bestScore {
                    bestScore = result.score
                    bestMove = move
                }
                currentBeta = min(currentBeta, bestScore)
            }

            if currentAlpha >= currentBeta {
                break
            }
        }
        return (score: bestScore, move: bestMove)
    }
    
    func checkGameOver() {
        let legalMovesDark = board.getLegalMoves(for: .dark)
        let legalMovesLight = board.getLegalMoves(for: .light)
        
        if settingsViewModel.enablePassingTurns {
            isGameOver = consecutivePasses >= 2 || board.isBoardFull()
            if isGameOver {
                showPassTurnButton = false
                activeAlert = .gameOver
            }
        } else {
            isGameOver = (board.currentPlayer == .dark && legalMovesDark.isEmpty) || (board.currentPlayer == .light && legalMovesLight.isEmpty)
        }
        if !settingsViewModel.enablePassingTurns {
            if isGameOver {
                activeAlert = .gameOver
            }
        }
    }

    func passTurn() {
        showPassTurnButton = false
        // Disable pass in AI mode
        if settingsViewModel.gameMode == .playerVsAI && board.currentPlayer == .light {
            return
        }

        // Check if turn to next player is required
        if consecutivePasses >= 2 || board.isBoardFull() {
            isGameOver = true
            activeAlert = .gameOver
            return
        }

        // switch to next player
        switchToNextPlayer()

        // If the current game mode is playerVsAI and the current player is AI, call the makeAIMove method
        if settingsViewModel.gameMode == .playerVsAI && board.currentPlayer == .light {
            isAIThinking = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.makeAIMove()
            }
        }
    }

    func getComputerMove() -> Move? {
        return self.getHardMove()
    }
    
    func calculateDifficulty(algorithm: String, maxDepth: Int) -> Int {
        var board = self.board
        var move: Move?
        var numNodes = 0
        let depth = 4
        let startTime = DispatchTime.now()

        // 计算算法的时间和节点数
        switch algorithm {
            case "alphabeta":
                move = alphaBeta(board: board, depth: depth, alpha: Int.min, beta: Int.max, maximizingPlayer: true, player: board.currentPlayer).move
                numNodes = alphaBetaNodes
            default:
                break
        }

        let endTime = DispatchTime.now()
        let timeElapsed = Double(endTime.uptimeNanoseconds - startTime.uptimeNanoseconds) / 1_000_000_000.0
        let difficulty = Int(Double(numNodes) / timeElapsed)

        return difficulty
    }

    
}
