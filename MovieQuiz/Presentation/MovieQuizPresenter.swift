//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Yakov Nemychenkov on 23.11.2022.
//

import Foundation
import UIKit

final class MovieQuizPresenter {
    
    var currentQuestion: QuizQuestion?
    let questionAmount: Int = 10
    weak var viewController: MovieQuizViewController?
    var statisticService = StatisticServiceImplementation()
    var correctAnswers: Int = 0
    var questionFactory: QuestionFactoryProtocol?
    

    private var currentQuestionIndex: Int = 0
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel (
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/ \(questionAmount)")
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = isYes
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.showLoadingIndicator()
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
     func showNextQuestionOrResults() {
         if self.isLastQuestion() {
            statisticService.store(correct: correctAnswers, total: questionAmount)
            let currentGameResultLine = """
                            Ваш результат: \(correctAnswers) из \(questionAmount)
                            Количество сыгранных квизов: \(statisticService.gamesCount)
                            Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
                            Средняя точность: \(String(format:"%.2f",statisticService.totalAccuracy))%
                        """
            let viewModel = QuizStepResultViewModel(title: "Этот раунд окончен!", text: currentGameResultLine, buttonText: "Сыграть еще раз")
            viewController?.show(quiz: viewModel)
        } else {
            switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
}



