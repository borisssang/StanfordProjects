//
//  setGame.swift
//  setGame
//
//  Created by Boris Angelov on 21.06.18.
//  Copyright © 2018 Boris Angelov. All rights reserved.
//

import Foundation

struct setGame{
    
    var allCards = Card.fillDeck()
    var playingCards = [Card]()
    var selectedCards = [Card]()
    public var score = 0
    
    mutating func selectCard(card: Card){
        selectedCards.append(card)
    }
    
    mutating func dealCards(numberOfCards: Int) -> [Card]{
        var newCards = [Card]()
        for i in 0..<numberOfCards{
            newCards.append(allCards.remove(at: i))
            playingCards.append(newCards[i])
        }
        return newCards
    }
    
    //needs implementation
    //    func matchingCards(card1: Card, card2: Card, card3: Card) -> Bool{
    //        if (((card1.cardColor.hashValue card2.cardColor == card3.cardColor) || (card1.cardColor != card2.cardColor != card3.cardColor))
    //)
    //    }
    
    mutating func restartGame(){
        allCards=Card.fillDeck()
        playingCards = [Card]()
        playingCards = dealCards(numberOfCards: 12)
        selectedCards = [Card]()
        score = 0
    }
    
    //needs REVIEW
    func getCardById(id: Int) -> Card{
        var newCard = Card(cardNumber: Card.Number(rawValue: "asd")!,cardSymbol: Card.Symbol(rawValue: "ASd")!,cardShading: Card.Shading(rawValue: "SDa")!,cardColor: Card.Color(rawValue: "ASd")!,identifier: 3)
        for card in allCards{
            if card.identifier == id {newCard = card}
        }
        return newCard
    }
}
