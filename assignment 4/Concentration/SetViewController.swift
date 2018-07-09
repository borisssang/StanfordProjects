//
//  SetViewController.swift
//  Lecture 4 - Concentration
//
//  Created by Boris Angelov on 6.07.18.
//  Copyright © 2018 Michel Deiman. All rights reserved.
//
import UIKit

class SetGameController: UIViewController {
    
    private lazy var game = setGame()
    private var isDealingEnabled = true
    @IBOutlet weak var containerView: ViewContainer!{
        didSet{
            let didSwipe = UISwipeGestureRecognizer(target: self, action: #selector(dealCards))
            didSwipe.direction = UISwipeGestureRecognizerDirection.down
            containerView.addGestureRecognizer(didSwipe)
        }
    }
    
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
        //if there are no more cards to deal, removes matched pairs
        if !game.matchedTrioLimit{
            updateViewFromModel()
            containerView.removeCards(times: 3)
        }
        updateViewFromModel()
    }
    
    //     append three cards //or as much as there is space for
    @IBAction func dealCards() {
        if game.isDealingEnabled {
            game.dealCards(numberOfCards: 3)
            if game.playingCards.count <= 81 {containerView.addCards(numberOfCards: 3)
                enableButtonAction()
            }
            updateViewFromModel()
        }
    }
    
    @IBAction func restartGame() {
        game.restartGame()
        containerView.resetContainer()
        containerView.addCards(numberOfCards: 12)
        enableButtonAction()
        updateViewFromModel()
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBAction func userDidRotate(_ sender: UIRotationGestureRecognizer) {
        game.shufflePlayingCards()
        updateViewFromModel()
    }
    
    //iterate through the cards
    //get the current card and switch on its states
    //put the states of the buttons accordingly
    private func updateViewFromModel() {
        if containerView.cards.count > game.playingCards.count {
            containerView.removeCards(times: containerView.cards.count - game.playingCards.count)
        }
        scoreLabel?.text = "Score: \(game.score)"
        for (index, currentCardButton) in containerView.cards.enumerated()  {
            let card = game.playingCards[index]
            
            currentCardButton.numberOfSymbols = card.cardNumber.rawValue + 1
            
            switch card.cardColor {
            case .red:
                currentCardButton.color = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            case .green:
                currentCardButton.color = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            case .purple:
                currentCardButton.color = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
            }
            
            switch card.cardSymbol{
            case .diamond:
                currentCardButton.symbol = "diamond"
            case .squiggle:
                currentCardButton.symbol = "squiggle"
            case .oval:
                currentCardButton.symbol = "oval"
            }
            
            switch card.cardStriping{
            case .solid:
                currentCardButton.striping = "solid"
            case .striped:
                currentCardButton.striping = "striped"
            case .unfilled:
                currentCardButton.striping = "unfilled"
            }
            
            if game.selectedCards.contains(card) || game.matchingCards.contains(card){
                currentCardButton.layer.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            } else {
                currentCardButton.layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
        }
    }
}

