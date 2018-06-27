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
    
    //validate if the selected card is already matched and if it's currently in playingCards
    mutating func selectCard(card: Card){
        if playingCards.contains(card){
            if !selectedCards.contains(card) {
                if !matchingCards.contains(card){
                    selectedCards.append(card)
                    switch selectedCards.count{
                    case 3: if areMatching(card1: selectedCards[1], card2: selectedCards[2], card3: selectedCards[3]){
                        for i in 0..<3
                        {
                            matchingCards.append(selectedCards.remove(at: i))
                        }
                        score = score + 1
                        }
                    case 4: selectedCards.removeAll()
                    selectedCards.append(card)
                    score-=1
                    default: break
                    }
                }
            }
                //disselection if there are less than 3 cards selected
            else if selectedCards.contains(card) && selectedCards.count < 3 {
              for i in 0..<selectedCards.count{
                    if selectedCards[i] == card {
                        selectedCards.remove(at: i)}
                    }
            }
        }
    }
    
    //returns number of cards requested // or all the cards left in the deck
    mutating func dealCards(numberOfCards: Int){
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
    }
    
    func areMatching(card1: Card, card2: Card, card3: Card) -> Bool{
        return isConditioned1(card1, card2, card3) && isConditioned2(card1, card2, card3) && isConditioned3(card1, card2, card3) && isConditioned4(card1, card2, card3)
    }
    
    mutating func restartGame(){
        allCards=Card.fillDeck()
        playingCards = [Card]()
       dealCards(numberOfCards: 12)
        selectedCards = [Card]()
        matchingCards = [Card]()
        score = 0
    }
    
    //Done right with closer
    func getCardById(id: Int) -> Card?{
        return playingCards.first(where: {$0.identifier == id})
    }
    
    func isConditioned1(_ card1: Card, _ card2: Card, _ card3: Card) -> Bool{
        if card1.cardNumber.rawValue == card2.cardNumber.rawValue && card3.cardNumber.rawValue == card2.cardNumber.rawValue {
            return true
        }
        else if card3.cardNumber.rawValue != card2.cardNumber.rawValue && card1.cardNumber.rawValue != card2.cardNumber.rawValue && card3.cardNumber.rawValue != card1.cardNumber.rawValue {
            return true
        }
        else { return false }
    }
    
    func isConditioned2(_ card1: Card, _ card2: Card, _ card3: Card) -> Bool{
        if card1.cardColor.rawValue == card2.cardColor.rawValue && card3.cardColor.rawValue == card2.cardColor.rawValue {
            return true
        }
        else if card3.cardColor.rawValue != card2.cardColor.rawValue && card1.cardColor.rawValue != card2.cardColor.rawValue && card3.cardColor.rawValue != card1.cardColor.rawValue {
            return true
        }
        else { return false }    }
    
    func isConditioned3(_ card1: Card, _ card2: Card, _ card3: Card) -> Bool{
        if card1.cardSymbol.rawValue == card2.cardSymbol.rawValue && card3.cardSymbol.rawValue == card2.cardSymbol.rawValue {
            return true
        }
        else if card3.cardSymbol.rawValue != card2.cardSymbol.rawValue && card1.cardSymbol.rawValue != card2.cardSymbol.rawValue && card3.cardSymbol.rawValue != card1.cardSymbol.rawValue {
            return true
        }
        else { return false }
    }
    
    func isConditioned4(_ card1: Card, _ card2: Card, _ card3: Card) -> Bool{
        if card1.cardShading.rawValue == card2.cardShading.rawValue && card3.cardShading.rawValue == card2.cardShading.rawValue {
            return true
        }
        else if card3.cardShading.rawValue != card2.cardShading.rawValue && card1.cardShading.rawValue != card2.cardShading.rawValue && card3.cardShading.rawValue != card1.cardShading.rawValue {
            return true
        }
        else { return false }
    }
}
