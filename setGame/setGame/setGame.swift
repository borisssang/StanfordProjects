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
    var matchingCards = [Card]()
    
    public var score = 0
    
    //validate if the selected card is already matched and if it's currently in playingCards (twice?)
    mutating func selectCard(card: Card){
        if !selectedCards.contains(card) && selectedCards.count < 3{
            if playingCards.contains(card) && !matchingCards.contains(card){
                selectedCards.append(card)
            }
        } else if !selectedCards.contains(card) {
            
        }
    }
    
    //returns number of cards requested // or all the cards left in the deck
    mutating func dealCards(numberOfCards: Int) -> [Card]{
        var newCards = [Card]()
        if allCards.count >= numberOfCards{
        for i in 0..<numberOfCards{
            newCards.append(allCards.remove(at: i))
                playingCards.append(newCards[i])
            }}
        else {
            for i in 0..<allCards.count{
                newCards.append(allCards.remove(at: i))
                playingCards.append(newCards[i])
            }
        }
        return newCards
    }
    
        func areMatching(card1: Card, card2: Card, card3: Card) -> Bool{
            return isConditioned1(card1, card2, card3) && isConditioned2(card1, card2, card3) && isConditioned3(card1, card2, card3)
        }
    
    mutating func restartGame(){
        allCards=Card.fillDeck()
        playingCards = [Card]()
        playingCards = dealCards(numberOfCards: 12)
        selectedCards = [Card]()
        matchingCards = [Card]()
        score = 0
    }
    
    //needs REVIEW, can be done in a better way?
    func getCardById(id: Int) -> Card{
        var newCard = Card(cardNumber: Card.Number(rawValue: "asd")!,cardSymbol: Card.Symbol(rawValue: "ASd")!,cardShading: Card.Shading(rawValue: "SDa")!,cardColor: Card.Color(rawValue: "ASd")!,identifier: 3)
        for card in allCards{
            if card.identifier == id {newCard = card}
        }
        return newCard
    }
    
    func isConditioned1(_ card1: Card, _ card2: Card, _ card3: Card) -> Bool{
        return false
    }
    
    func isConditioned2(_ card1: Card, _ card2: Card, _ card3: Card) -> Bool{
        return false
    }
    
    func isConditioned3(_ card1: Card, _ card2: Card, _ card3: Card) -> Bool{
        return false
    }
    
    //var number, symbol, shading, color: String
    
}
