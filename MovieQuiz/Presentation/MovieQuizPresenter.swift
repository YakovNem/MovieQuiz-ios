//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Yakov Nemychenkov on 23.11.2022.
//

import Foundation
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    private var statisticService = StatisticServiceImplementation()
    private var questionFactory: QuestionFactoryProtocol?
    private weak var viewController: (MovieQuizViewControllerProtocol)?
    
    private var currentQuestion: QuizQuestion?
    private let questionAmount: Int = 10
    private var correctAnswers: Int = 0
    private var currentQuestionIndex: Int = 0
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    // MARK: QuestionFactoryDelegate
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
   }
   
     func didFailToLoadData(with error: Error) {
        let meassage = error.localizedDescription
         viewController?.showNetworkError(message: meassage)
   }
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionAmount - 1
    }
    
    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
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
        proceedWithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    

    
    private func proceedWithAnswer (isCorrect: Bool) {
        didAnswer(isCorrectAnswer: isCorrect)
        
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        
     DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
         self.showNextQuestionOrResults()
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



