//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Yakov Nemychenkov on 01.11.2022.
//

import Foundation
import UIKit

class AlertPresenter: AlertProtocol {
   
    weak var viewController: UIViewController?
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    func showAlert(quiz aler: AlertModel) {
        let alert = UIAlertController(title: aler.title,
                                      message: aler.message,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: aler.buttonText, style: .default, handler: aler.completion)
        
        alert.addAction(action)
        
        viewController?.present(alert, animated: true, completion: nil)
        
    }
}

