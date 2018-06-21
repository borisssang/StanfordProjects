//
//  setGame.swift
//  setGame
//
//  Created by Boris Angelov on 21.06.18.
//  Copyright © 2018 Boris Angelov. All rights reserved.
//

import Foundation

class setGame{
    
    private(set) var allCards = [Card]()
    var playingCards = [Card]()
    var selectedCards = [Card]()
    
    func selectCard(card: Card){
        selectedCards.append(card)
    }
    
    func dealCards(numberOfCards: Int) -> [Card]{
        var newCards = [Card]()
        for i in 0..<numberOfCards{
            newCards[i]=allCards.remove(at: i)
            playingCards.append(newCards[i])
        }
        return newCards
    }
    
    //needs implementation
    func matchingCards(card1: Card, card2: Card, card3: Card) -> Bool{
        return false
    }
    
    
        //shiffle method or ...
      //   let randomNumber = Int(arc4random_uniform(UInt32(allCards.count)))
    
}
