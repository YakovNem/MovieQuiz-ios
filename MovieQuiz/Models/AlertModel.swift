//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Yakov Nemychenkov on 01.11.2022.
//

import Foundation
import UIKit
struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    var completion: ((UIAlertAction) -> Void)? = nil
}
