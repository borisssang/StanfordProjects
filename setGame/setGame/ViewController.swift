//
//  ViewController.swift
//  setGame
//
//  Created by Boris Angelov on 21.06.18.
//  Copyright © 2018 Boris Angelov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private lazy var game = setGame()
    
    @IBOutlet var buttons: [UIButton]!{
        didSet{
            game.dealCards(numberOfCards: 12)
            assignTagToButton(game.playingCards)
            updateViewFromModel()
        }
    }
    
    //append three cards //or as much as there is space for
    @IBAction func dealCards() {
        var counter = 3
        let numberOfZeroTags = buttons.filter({$0.tag == 0}).count
        
        //if cards are matched, replace them with new cards
        while game.allCards.count > 0 && 0 < numberOfZeroTags && counter > 0{
            game.dealCards(numberOfCards: 1)
            assignTagToButton(game.playingCards)
            updateViewFromModel()
            counter -= 1
        }
    }
    
    @IBAction func button(_ sender: UIButton) {
        
        if sender.tag != 0  {
            if let card = game.getCardById(id: sender.tag){
                game.selectCard(card: card)
                if game.matchingCards.contains(card){
                    if let button = getButtonByTag(buttons, card.identifier){
                        button.tag = 0
                    }
                }
                updateViewFromModel()
            }
        }
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBAction func restartGame() {
        for button in buttons {
            button.tag = 0
        }
        game.restartGame()
        assignTagToButton(game.playingCards)
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        scoreLabel?.text = "Score: \(game.score)"
        
        for button in buttons {
            if button.tag == 0 {
                button.setTitle("", for: UIControlState.normal)
                button.setAttributedTitle(NSMutableAttributedString(string:""), for: UIControlState.normal)
                button.backgroundColor = UIColor.black
            }
            
            if let card = game.playingCards.first(where: {$0.identifier == button.tag}) {
                button.setTitle((card.cardNumber.rawValue) + (card.cardSymbol.rawValue), for: UIControlState.normal)
               // button.backgroundColor = UIColor(cgColor: card.cardColor.rawValue as! CGColor)
                
                if game.selectedCards.contains(card){
                    button.setTitleColor(UIColor.purple, for: UIControlState.normal)
                }
            }
        }
    }
    
    func assignTagToButton(_ cards: [Card]){
        var newCards = cards
        while  newCards.count > 0 {
            if let button = buttons.first(where: {$0.tag == 0}){
                button.tag = newCards.removeLast().identifier
            }
        }
    }
    
    func getButtonByTag(_ buttons: [UIButton],_ id: Int) -> UIButton? {
        var newButton = UIButton()
        for button in buttons{
            if button.tag == id
            {newButton = button}
        }
        return newButton
    }
    
}

