//
//  ViewController.swift
//  setGame
//
//  Created by Boris Angelov on 2.07.18.
//  Copyright © 2018 Boris Angelov. All rights reserved.
//
import UIKit

class ViewController: UIViewController {
    
    private lazy var game = setGame()
    @IBOutlet weak var containerView: ViewContainer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        game.dealCards(numberOfCards: 12)
        containerView.addCards(numberOfCards: 12)
        enableButtonAction()
        updateViewFromModel()
    }
    
    private func enableButtonAction() {
        for card in containerView.cards {
            card.addTarget(self, action: #selector(didTapCard(_:)), for: .touchUpInside)
        }
    }
    
    @objc func didTapCard(_ sender: UIButton) {
        let indexOfCard = containerView.cards.index(of: sender as! CardViewButton)!
            game.selectCard(at: indexOfCard)
            updateViewFromModel()
    }
    
    //     append three cards //or as much as there is space for
    @IBAction func dealCards() {
        game.dealCards(numberOfCards: 3)
        containerView.addCards(numberOfCards: 3)
        enableButtonAction()
        updateViewFromModel()
    }
    
    @IBAction func restartGame() {
        game.restartGame()
        containerView.resetContainer()
        containerView.addCards(numberOfCards: 12)
        updateViewFromModel()
    }
    
        @IBOutlet weak var scoreLabel: UILabel!
    
        private let colorFeatureToColor: [Card.Color : UIColor] = [
            .red : #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1),
            .green : #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1),
            .purple : #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        ]
    
        private let symbolToText: [Card.Symbol : String] = [
            .squere : "■",
            .diamond : "▲",
            .oval : "●"
        ]
    
        private let numberToInt: [Card.Number : Int] = [
            .one: 1,
            .two: 2,
            .three: 3
        ]
    
    //needs implementation
        private func updateViewFromModel() {
            scoreLabel?.text = "Score: \(game.score)"
        }
}
