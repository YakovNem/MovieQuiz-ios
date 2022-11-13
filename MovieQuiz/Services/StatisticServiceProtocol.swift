//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Yakov Nemychenkov on 10.11.2022.
//

import Foundation

protocol StatisticServiceProtocol {
    
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    
    func store(correct count: Int, total amount: Int)
}
