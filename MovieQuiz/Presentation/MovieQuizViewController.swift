import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - Lifecycle
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
//    private var correctAnswers: Int = 0
//    private var questionFactory: QuestionFactoryProtocol?
//    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter?
//    private var statisticService: StatisticServiceProtocol = StatisticServiceImplementation()
    private let presenter = MovieQuizPresenter()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenter(viewController: self)
        presenter.questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        
        showLoadingIndicator()
        presenter.questionFactory?.loadData()
        
        presenter.viewController = self

    }
    
    // MARK: - QuestionFactoryDelegate
    
    @IBAction private func  yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
        presenter.didRecieveNextQuestion(question: question)
    }
    
     func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
     func show(quiz result: QuizStepResultViewModel) {
        let alertModel = AlertModel(title: result.title,
                                    message: result.text,
                                    buttonText: result.buttonText) { [weak self] _ in
            guard let self = self  else { return }
            self.presenter.resetQuestionIndex()
            self.presenter.correctAnswers = 0
            self.presenter.questionFactory?.requestNextQuestion()
            
        }
        alertPresenter?.showAlert(quiz: alertModel)
    }
    
    
    
     func showAnswerResult (isCorrect: Bool) {
        noButton.isEnabled = false
        yesButton.isEnabled = false
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        if isCorrect {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            presenter.correctAnswers += 1
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
            self.presenter.showNextQuestionOrResults()
            self.noButton.isEnabled = true
            self.yesButton.isEnabled = true
            imageView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
//     func showNextQuestionOrResults() {
//        if presenter.isLastQuestion() {
//            statisticService.store(correct: correctAnswers, total: presenter.questionAmount)
//            let currentGameResultLine = """
//                            Ваш результат: \(correctAnswers) из \(presenter.questionAmount)
//                            Количество сыгранных квизов: \(statisticService.gamesCount)
//                            Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
//                            Средняя точность: \(String(format:"%.2f",statisticService.totalAccuracy))%
//                        """
//            let viewModel = QuizStepResultViewModel(title: "Этот раунд окончен!", text: currentGameResultLine, buttonText: "Сыграть еще раз")
//            show(quiz: viewModel)
//        } else {
//            presenter.switchToNextQuestion()
//            questionFactory?.requestNextQuestion()
//        }
//    }
    
     func showLoadingIndicator() {
        activityIndicator.hidesWhenStopped = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
     
    }
    
    private func showNetworkError (message: String) {
        hideLoadingIndicator()
        
        let alertNetworkError = AlertModel(title: "Ошибка",
                                           message: message,
                                           buttonText: "Попробовать еще раз") { [weak self] _ in
            guard let self = self else { return }
            self.presenter.questionFactory?.loadData()
            
        }
        alertPresenter?.showAlert(quiz: alertNetworkError)
    }
    
     func didLoadDataFromServer() {
         activityIndicator.isHidden = true
         presenter.questionFactory?.requestNextQuestion()
    }
    
      func didFailToLoadData(with error: Error) {
          showNetworkError(message: error.localizedDescription)
    }
    

}


/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
