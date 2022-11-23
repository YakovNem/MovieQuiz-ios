//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Yakov Nemychenkov on 22.11.2022.
//
import Foundation
import XCTest
@testable import MovieQuiz

final class MovieQuizUITests: XCTestCase {
    // swiftlint:disable:next implicitly_unwrapped_optional
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false // настройка для текстов: если один тест не прошел, то следующие тесты запускаться не будут.
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
    
    func testYesButton() throws {
        let firstPoster = app.images["Poster"] //находим первый постер

        app.buttons["Yes"].tap() //находим кнопку 'да' и нажимаем ее

        let secondPoster = app.images["Poster"] //еще раз находим постер
        let indexLabel = app.staticTexts["Index"]

        sleep(3)

        XCTAssertTrue(indexLabel.label == "2/ 10")
        XCTAssertFalse(firstPoster == secondPoster) //проверяем, что постеры разные
    }
    
    func testNoButton() throws {
        let firstPoster = app.images["Poster"]
        
        app.buttons["No"].tap()
        
        let secondPoster = app.images["Poster"]
        let indexLabel = app.staticTexts["Index"]
        
        sleep(5)
        
        XCTAssertTrue(indexLabel.label == "2/ 10")
        XCTAssertFalse(firstPoster == secondPoster)
    }
    
    func testGameFinish() {
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(5)
        }
        
        sleep(5)
        
        let alert = app.alerts["Game results"]
        
        XCTAssertTrue(app.alerts["Game results"].exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть еще раз")
    }

    func testAlertDismiss() {
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(5)
        }
        
        sleep(5)
        
        let alert = app.alerts["Game results"]
        alert.buttons.firstMatch.tap()
        
        sleep(5)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(app.alerts["Game results"].exists)
        XCTAssertTrue(indexLabel.label == "1/ 10")
    }
}
