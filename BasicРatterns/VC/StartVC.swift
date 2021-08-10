//
//  StartVC.swift
//  BasicРatterns
//
//  Created by Сергей Зайцев on 10.08.2021.
//

import UIKit

class StartVC: UIViewController {
    
    @IBOutlet weak var buttonStart: UIButton!
    @IBOutlet weak var buttonResult: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            case "segueStartGameSession":
                guard let destination = segue.destination as? GameVC else { return }
                destination.delegateEndGame = self
            default:
                break
        }
    }
}

extension StartVC: GameViewControllerDelegate {
    func didEndGame(withResult result: Int) {
        guard let session = Game.shared.gameSession else { return }
        self.buttonResult.setTitle("Правильно \(session.resultInPercent)%", for: UIControl.State.normal)
        Game.shared.endSession()
    }
}
