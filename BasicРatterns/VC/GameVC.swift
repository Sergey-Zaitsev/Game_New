//
//  GameViewController.swift
//  BasicРatterns
//
//  Created by Сергей Зайцев on 10.08.2021.
//

import UIKit

class GameVC: UIViewController {

    var currentSession: GameSession?
    weak var delegateEndGame: GameViewControllerDelegate?

    @IBOutlet weak var labelHeader: UILabel!
    @IBOutlet weak var labelQuestion: UILabel!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    
    @IBAction func buttonTap(_ sender: Any) {
        let button = sender as! UIButton
        guard let title = button.title(for: UIControl.State.normal) else { return }
        
        let alert = UIAlertController(title: labelQuestion.text, message: "\(title)", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Да", style: UIAlertAction.Style.default, handler: {action in
            self.DoCheckAnswer(answerNumber: button.tag)
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var questions = [Question]()
        var a: [String] = ["коллекцию", "коррупцию", "конструкцию", "информацию"]
        var q = Question(question: "Что не собирают?", answers: a, rightAnswer: 2)
        questions.append(q)
        a = ["совковая", "граблевая", "тяпковая", "мотыжная"]
        q = Question(question: "Какая бывает лопата?", answers: a, rightAnswer: 1)
        questions.append(q)
        a = ["\"Варяг\"", "\"Кореец\"", "\"Викинг\"", "\"Чухонец\""]
        q = Question(question: "Как называется фильм, снятый по мотивам \"Повести временных лет\"?", answers: a, rightAnswer: 3)
        questions.append(q)
        a = ["на пальцы", "на уши", "на волосы", "на зубы"]
        q = Question(question: "На что надевают брекеты?", answers: a, rightAnswer: 4)
        questions.append(q)
        a = ["дельфин", "медведь", "попугай", "крокодил"]
        q = Question(question: "Кто такой ара?", answers: a, rightAnswer: 3)
        questions.append(q)
        
        print("Questions:\n\(questions)")
        
        button1.tag = 1
        button2.tag = 2
        button3.tag = 3
        button4.tag = 4
        
        currentSession = GameSession(questions: questions)
        Game.shared.startNewGameSession(session: currentSession!)
        
        DoNextStep()
    }
    
    func DoNextStep() {
        guard let question = currentSession?.nextStep(),
              let session = currentSession
        else {
            self.gameOver(withResult: 1)
            return
        }
        labelHeader.text = "Вопрос \(session.currentStep) из \(session.questionCount)"
        labelQuestion.text = question.question
        button1.setTitle(question.answers[0], for: UIControl.State.normal)
        button2.setTitle(question.answers[1], for: UIControl.State.normal)
        button3.setTitle(question.answers[2], for: UIControl.State.normal)
        button4.setTitle(question.answers[3], for: UIControl.State.normal)
    }
    
    func DoCheckAnswer(answerNumber: Int) {
        guard let session = currentSession else { return }
        let IsRight = session.checkCurrentAnswer(answerNumber: answerNumber)
        if (IsRight) {
            DoNextStep()
        } else {

            gameOver(withResult: 0)
        }
    }
    
    func gameOver(withResult result: Int) {
        delegateEndGame?.didEndGame(withResult: result)
        dismiss(animated: true, completion: nil)
    }
}

protocol GameViewControllerDelegate: AnyObject {
    func didEndGame(withResult result: Int)
}
