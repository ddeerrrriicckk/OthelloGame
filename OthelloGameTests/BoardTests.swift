//
//  BoardTests.swift
//  OthelloGameTests
//
//

import XCTest
@testable import OthelloGame

class BoardTests: XCTestCase {

    var board: Board!

    override func setUp() {
        super.setUp()
        board = Board()
    }

    override func tearDown() {
        board = nil
        super.tearDown()
    }

    func testInitialBoardState() {
        XCTAssertEqual(board.getNumberOfPieces(for: .dark), 2)
        XCTAssertEqual(board.getNumberOfPieces(for: .light), 2)
        XCTAssertEqual(board.currentPlayer, Player.dark)
    }

    func testSwitchPlayer() {
        board.switchPlayer()
        XCTAssertEqual(board.currentPlayer, Player.light)
    }

    func testUpdateBoard() {
        let updatedBoard = board.updateBoard(atRow: 2, atCol: 3, player: board.currentPlayer)
        XCTAssertEqual(updatedBoard.getNumberOfPieces(for: .dark), 4)
    }

    func testGetLegalMoves() {
        let legalMoves = board.getLegalMoves(for: board.currentPlayer)
        XCTAssertEqual(legalMoves.count, 4)
        XCTAssertTrue(legalMoves.contains(Move(row: 2, col: 3)))
        XCTAssertTrue(legalMoves.contains(Move(row: 3, col: 2)))
        XCTAssertTrue(legalMoves.contains(Move(row: 4, col: 5)))
        XCTAssertTrue(legalMoves.contains(Move(row: 5, col: 4)))
    }
}

