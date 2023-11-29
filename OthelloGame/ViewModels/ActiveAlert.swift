//
//  ActiveAlert.swift
//  OthelloGame
//
//

enum ActiveAlert: String, CaseIterable, Identifiable{
    case gameOver = "GameOver"
    case gameReset = "GameReset"
    case illegalMove = "IllegalMove"
    var id: String { rawValue }
}
