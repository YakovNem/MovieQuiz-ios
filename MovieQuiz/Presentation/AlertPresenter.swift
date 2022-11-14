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
    
    func showAlert(quiz alertModel: AlertModel) {
        let alert = UIAlertController(title: alertModel.title,
                                      message: alertModel.message,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default, handler: alertModel.completion)
        
        alert.addAction(action)
        
        viewController?.present(alert, animated: true, completion: nil)
        
    }
}

