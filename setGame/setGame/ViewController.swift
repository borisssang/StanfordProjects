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
        if !game.matchingCards.isEmpty && game.selectedCards.count == 3 {
            while game.allCards.count > 0 && !game.matchingCards.isEmpty{
                let lastCard = game.matchingCards.removeLast()
                if let button = buttons.first(where: {$0.tag == lastCard.identifier}){
                    button.tag = 0
                    game.dealCards(numberOfCards: 1)
                    assignTagToButton([game.playingCards.last!])
                }
            }
            updateViewFromModel()
        } else if game.matchingCards.isEmpty {
            while game.allCards.count > 0 && 0 < numberOfZeroTags && counter > 0{
                game.dealCards(numberOfCards: 1)
                assignTagToButton([game.playingCards.last!])
                updateViewFromModel()
                counter -= 1
            }
        }
    }
    
    @IBAction func button(_ sender: UIButton) {
        if sender.tag != 0  {
            if let card = game.getCardById(id: sender.tag){
                game.selectCard(  card: card)
                if !game.matchingCards.isEmpty && game.selectedCards.count > 3 {
                    while  game.matchingCards.count > 0 {
                        if let button = buttons.first(where: {$0.tag == game.matchingCards.first?.identifier}){
                            button.tag = 0
                            game.matchingCards.remove(at: 0)
                            if game.matchingCards.count == 1 {
                                game.selectedCards = [game.selectedCards.removeLast()]
                            }
                        }
                    }
                }
            }
        }
        updateViewFromModel()
        if game.selectedCards.count == 1 {dealCards()}
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
                button.setTitleColor(UIColor.blue, for: UIControlState.normal)
                button.layer.borderColor = UIColor.black.cgColor
            }
            
            if let card = game.playingCards.first(where: {$0.identifier == button.tag}) {
                button.backgroundColor = UIColor.black
                button.layer.borderColor = UIColor.black.cgColor
                button.setAttributedTitle(getAttributedText(forCard: card), for: UIControlState.normal)
                
                if game.selectedCards.contains(card){
                    button.backgroundColor = UIColor.purple
                    button.layer.borderWidth = 3.0
                    button.layer.borderColor = UIColor.purple.cgColor
                    button.layer.cornerRadius = 8.0
                }
            }
        }
    }
    
    private func getAttributedText(forCard card: Card) -> NSAttributedString? {
        
        guard card.cardNumber != .none else { return nil }
        guard card.cardSymbol != .none else { return nil }
        guard card.cardColor != .none else { return nil }
        guard card.cardShading != .none else { return nil }
        
        let number = card.cardNumber
        let symbol = card.cardSymbol
        let color = card.cardColor
        let shading = card.cardShading
        
        if let displayedSymbol = symbolToText[symbol]{
            if let numberOfSymbols = numberToInt[number]{
        let cardText = String(repeating: displayedSymbol, count: numberOfSymbols)
        var attributes = [NSAttributedStringKey : Any]()
        let cardColor = colorFeatureToColor[color]!
        
        switch shading {
        case .open:
            attributes[NSAttributedStringKey.strokeWidth] = 10
            fallthrough
        case .solid:
            attributes[NSAttributedStringKey.foregroundColor] = cardColor
        case .striped:
            attributes[NSAttributedStringKey.foregroundColor] = cardColor.withAlphaComponent(0.3)
        }
        
        let attributedText = NSAttributedString(string: cardText,
                                                attributes: attributes)
        return attributedText
    }
        else {return nil}
        } else {return nil}
    }
   private func assignTagToButton(_ cards: [Card]){
        var newCards = cards
        while  newCards.count > 0 {
            if let button = buttons.first(where: {$0.tag == 0}){
                button.tag = newCards.removeLast().identifier
            }
        }
    }
    
    private func getButtonByTag(_ buttons: [UIButton],_ id: Int) -> UIButton? {
        var newButton = UIButton()
        for button in buttons{
            if button.tag == id
            {newButton = button}
        }
        return newButton
    }
}
