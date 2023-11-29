//
//  Player.swift
//  OthelloGame
//
//

import Foundation

enum Player {
    case dark
    case light
    
    func opponent() -> Player {
        switch self {
        case .dark:
            return .light
        case .light:
            return .dark
        }
    }

}
