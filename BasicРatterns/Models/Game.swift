//
//  Game.swift
//  BasicРatterns
//
//  Created by Сергей Зайцев on 10.08.2021.
//

import Foundation

class Game {
    static let shared = Game()
    private init() {
        self.results = self.resCaretaker.restore()
    }
    
    var gameSession: GameSession?
    var results: [GameResult]

    private let resCaretaker = ResultsCaretaker()

    func startNewGameSession(session: GameSession) {
        self.gameSession = session
    }
    
    func endSession() {
        guard let session = gameSession else { return }
        let result = GameResult(date: Date(), percent: session.resultInPercent)
        results.append(result)
        self.resCaretaker.save(results: results)
        gameSession = nil
    }
}

class GameSession {
    private let questions: [Question]
    private(set) var currentStep: Int
    var questionCount: Int { return questions.count }
    var rightAnswersCount: Int
    var resultInPercent: Int { return rightAnswersCount * 100 / questionCount }

    init(questions: [Question]) {
        self.questions = questions
        self.rightAnswersCount = 0
        self.currentStep = 0
    }
    
    func nextStep() -> Question? {
        currentStep += 1
        if (currentStep > questions.count) { return nil }
        return questions[currentStep - 1]
    }
    
    func checkCurrentAnswer(answerNumber: Int) -> Bool {
        guard let curQuestion = currentStep > questions.count ? nil : questions[currentStep - 1] else { return false }
        let res = curQuestion.rightAnswer == answerNumber
        if (res) { rightAnswersCount += 1 }
        return res
    }
}

struct GameResult: Codable {
    let date: Date
    let percent: Int
}


final class ResultsCaretaker {
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let key = "results"
    func save(results: [GameResult]) {
        do {
            let data = try self.encoder.encode(results)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print(error)
        }
    }
    func restore() -> [GameResult] {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return []
        }
        do {
            return try self.decoder.decode([GameResult].self, from: data)
        } catch {
            print(error)
            return []
        }
    }
}
