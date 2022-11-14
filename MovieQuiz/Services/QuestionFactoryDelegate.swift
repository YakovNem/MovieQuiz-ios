//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Yakov Nemychenkov on 01.11.2022.
//

import Foundation
protocol QuestionFactoryDelegate: AnyObject {
    func didRecieveNextQuestion(question: QuizQuestion?)
}
