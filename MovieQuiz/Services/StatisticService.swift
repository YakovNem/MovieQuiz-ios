//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Yakov Nemychenkov on 07.11.2022.
//

import Foundation

final class StatisticServiceImplementation: StatisticServiceProtocol {
    
    private let userDefaults = UserDefaults.standard
    
    private enum Keys: String {
        case correct, total, bestGame, gameCount
    }
    
    var correct: Int {
        get {
            userDefaults.integer(forKey: Keys.correct.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gameCount.rawValue)
        }
    }
    var total: Int {
        get {
            userDefaults.integer(forKey: Keys.total.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    
    var totalAccuracy: Double {
        get {
            Double(userDefaults.double(forKey: Keys.correct.rawValue) / userDefaults.double(forKey: Keys.total.rawValue)) * 100
        }
    }
    
    var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gameCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gameCount.rawValue)
        }
    }
    
    private(set) var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        
        let result = GameRecord(correct: count, total: amount, date: Date())
        if bestGame < result {
            bestGame = result
        }
        
        userDefaults.set(gamesCount + 1, forKey: Keys.gameCount.rawValue)
        userDefaults.set(correct + count, forKey: Keys.correct.rawValue)
        userDefaults.set(total + amount, forKey: Keys.total.rawValue)
    }
}
