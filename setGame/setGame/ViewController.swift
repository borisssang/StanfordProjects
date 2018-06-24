//
//  ViewController.swift
//  setGame
//
//  Created by Boris Angelov on 21.06.18.
//  Copyright © 2018 Boris Angelov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var selected = false
    private lazy var game = setGame()
    
    @IBOutlet var buttons: [UIButton]!{
        didSet{
            game.playingCards=game.dealCards(numberOfCards: 12)
            updateViewFromModel()
        }
    }
    
    @IBAction func dealCards() {
        //needed validation ......
        if (game.allCards.count > 0) && (game.playingCards.count < buttons.count) {
            //needed validation for selected cards being matched
            _ = game.dealCards(numberOfCards: 3)
            updateViewFromModel()
        }
    }
    
    //tag of matching has to be 0
    @IBAction func button(_ sender: UIButton) {
        if sender.tag != 0  {
            let card = game.getCardById(id: sender.tag)
            if game.selectedCards.count <= 2 {
                game.selectCard(card: card)
            }
            else if game.selectedCards.count == 3 {
                
            }
            updateViewFromModel()
        }
        
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBAction func restartGame() {
        game.restartGame()
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        scoreLabel?.text = "Score: \(game.score)"
        for index in 0..<game.playingCards.count
        {
            let card = game.playingCards[index]
            if buttons[index].tag == 0{
                buttons[index].setTitle("", for: UIControlState.normal)
                buttons[index].setAttributedTitle(NSMutableAttributedString(string:""), for: UIControlState.normal)
                buttons[index].backgroundColor = UIColor.black
            } else if buttons[index].tag == card.hashValue{
                buttons[index].setTitle(card.cardNumber.rawValue + card.cardSymbol.rawValue, for: UIControlState.normal)
                buttons[index].backgroundColor = UIColor(cgColor: card.cardColor as! CGColor)
            }
            
            //needs selected UI STUFF
            if card == game.selectedCards[index]{
                buttons[index].setAttributedTitle(NSMutableAttributedString(string:"selected"), for: UIControlState.normal)
            }
            
            if card == game.matchingCards[index]{
                buttons[index].tag = 0
                buttons[index].setTitle("", for: UIControlState.normal)
                buttons[index].setAttributedTitle(NSMutableAttributedString(string:""), for: UIControlState.normal)
                buttons[index].backgroundColor = UIColor.black
            }
        }
        
    }
    
}
