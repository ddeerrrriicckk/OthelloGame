//
//  OthelloViewModelTests.swift
//  OthelloGameTests
//
//

import XCTest
@testable import OthelloGame

final class OthelloViewModelTests: XCTestCase {

    var viewModel: OthelloViewModel!

    override func setUp() {
        super.setUp()
        viewModel = OthelloViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testUserTapped() {
        let initialMove = Move(row: 2, col: 3)
        viewModel.userTapped(row: initialMove.row, col: initialMove.col)
        let updatedBoard = viewModel.board
        XCTAssertEqual(updatedBoard.getCellState(row: initialMove.row, col: initialMove.col), .dark)
    }

    func testSwitchToNextPlayer() {
        let currentPlayer = viewModel.board.currentPlayer
        viewModel.switchToNextPlayer()
        XCTAssertNotEqual(viewModel.board.currentPlayer, currentPlayer)
    }

    func testStartNewGame() {
        viewModel.startNewGame()
        let newBoard = viewModel.board
        XCTAssertEqual(viewModel.darkScore, 2)
        XCTAssertEqual(viewModel.lightScore, 2)
        XCTAssertEqual(newBoard.currentPlayer, .dark)
    }

    func testCalculateLegalMoves() {
        viewModel.calculateLegalMoves()
        let legalMoves = viewModel.legalMoves
        XCTAssertEqual(legalMoves.count, 4) // At the beginning of the game, there are 4 legal moves
    }

    func testUpdateScores() {
        let initialMove = Move(row: 2, col: 3)
        viewModel.userTapped(row: initialMove.row, col: initialMove.col)
        XCTAssertEqual(viewModel.darkScore, 4)
        XCTAssertEqual(viewModel.lightScore, 1)
    }
    
    func testCheckGameOver() {
        let viewModel = OthelloViewModel()
        
        viewModel.boardConfiguration = [
            [.dark, .light, .dark, .light, .dark, .light, .dark, .light],
            [.light, .dark, .light, .dark, .light, .dark, .light, .dark],
            [.dark, .light, .dark, .light, .dark, .light, .dark, .light],
            [.light, .dark, .light, .dark, .light, .dark, .light, .dark],
            [.dark, .light, .dark, .light, .dark, .light, .dark, .light],
            [.light, .dark, .light, .dark, .light, .dark, .light, .dark],
            [.dark, .light, .dark, .light, .dark, .light, .dark, .light],
            [.light, .dark, .light, .dark, .light, .dark, .light, .dark]
        ]
        viewModel.checkGameOver()
        XCTAssertTrue(viewModel.isGameOver)

        viewModel.boardConfiguration = nil
        viewModel.checkGameOver()
        XCTAssertFalse(viewModel.isGameOver)
    }
    
    func testGameOverWithEmptySpaces() {
        let viewModel = OthelloViewModel()
        viewModel.boardConfiguration = [
            [.light, nil,    .dark,  .dark, .dark, .dark, .dark, .dark],
            [.light, .light, .dark,  .dark, .dark, .dark, .dark, .dark],
            [.light, .light, .light, .dark, .dark, .dark, .dark, .dark],
            [.light, .light, .dark,  .light, .dark, .dark, .dark, .dark],
            [.light, .light, .light, .dark, .light, .dark, .dark, .dark],
            [.light, .light, .dark,  .light, .dark, .light, .dark, .dark],
            [.light, .light, .dark,  .dark, .light, .dark, .light, .dark],
            [.light, .light, .light, .light, .light, .light, .light, .light]
        ]

        viewModel.checkGameOver()
        XCTAssertTrue(viewModel.isGameOver)
    }
    // Test the AI on easy difficulty
    func testEasyAIMove() {
        viewModel.settingsViewModel.aiDifficulty = .easy

        let initialLegalMoves = viewModel.legalMoves
        XCTAssertFalse(initialLegalMoves.isEmpty)

        viewModel.makeAIMove()
        let newLegalMoves = viewModel.legalMoves
        XCTAssertFalse(newLegalMoves.isEmpty)

        XCTAssertNotEqual(initialLegalMoves, newLegalMoves)
    }

    // Test the AI on medium difficulty
    func testMediumAIMove() {
        viewModel.settingsViewModel.aiDifficulty = .medium

        let initialLegalMoves = viewModel.legalMoves
        XCTAssertFalse(initialLegalMoves.isEmpty)

        viewModel.makeAIMove()
        let newLegalMoves = viewModel.legalMoves
        XCTAssertFalse(newLegalMoves.isEmpty)

        XCTAssertNotEqual(initialLegalMoves, newLegalMoves)
    }

    // Test the AI on hard difficulty
    func testHardAIMove() {
        viewModel.settingsViewModel.aiDifficulty = .hard

        let initialLegalMoves = viewModel.legalMoves
        XCTAssertFalse(initialLegalMoves.isEmpty)

        viewModel.makeAIMove()
        let newLegalMoves = viewModel.legalMoves
        XCTAssertFalse(newLegalMoves.isEmpty)

       
        print("Initial legal moves: \(initialLegalMoves)")
        print("New legal moves: \(newLegalMoves)")
        
        let initialLegalMovesSet = Set(initialLegalMoves)
        let newLegalMovesSet = Set(newLegalMoves)
        
        print("initialLegalMovesSet == newLegalMovesSet: \(initialLegalMovesSet == newLegalMovesSet)")
        XCTAssertFalse(initialLegalMovesSet == newLegalMovesSet)


    }
    
    func testMediumAlgorithm() {
        viewModel.settingsViewModel.aiDifficulty = .medium
        let move = viewModel.getComputerMove()
        XCTAssertNotNil(move)
    }
    
    
    func testMiniMaxDifficulty() {
        let viewModel = OthelloViewModel()
        let maxDepths = [2, 4, 6, 8]
        let expectedDifficulties = [1000, 500, 250, 125]
        
        for i in 0..<maxDepths.count {
            let maxDepth = maxDepths[i]
            let expectedDifficulty = expectedDifficulties[i]
            let difficulty = viewModel.calculateDifficulty(algorithm: "alphabeta", maxDepth: maxDepth)
            if(difficulty >= expectedDifficulty) {
                print("Expected difficulty for minimax at depth \(maxDepth) to be at least \(expectedDifficulty), but got \(difficulty)")
            }
            XCTAssert(difficulty >= expectedDifficulty, "Expected difficulty for minimax at depth \(maxDepth) to be at least \(expectedDifficulty), but got \(difficulty)")
        }
    }

}
