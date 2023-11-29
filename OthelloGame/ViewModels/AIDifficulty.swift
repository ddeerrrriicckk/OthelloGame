//
//  AIDifficulty.swift
//  OthelloGame
//
//

import Foundation

import Foundation

enum AIDifficulty: String, CaseIterable, Identifiable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"

    var id: String { rawValue }
}
