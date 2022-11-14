//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Yakov Nemychenkov on 07.11.2022.
//

import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
}

extension GameRecord: Comparable {
    static func < (hs1: GameRecord, hs2: GameRecord) -> Bool {
        return hs1.correct < hs2.correct
    }
}
