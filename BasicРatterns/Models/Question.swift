//
//  Question.swift
//  BasicРatterns
//
//  Created by Сергей Зайцев on 10.08.2021.
//

import Foundation

struct Question {
    let question: String
    var answers = [String]()
    let rightAnswer: Int
    init(question: String, answers: [String], rightAnswer: Int) {
        self.question = question
        self.answers.append(contentsOf: answers)
        self.rightAnswer = rightAnswer
    }
}
