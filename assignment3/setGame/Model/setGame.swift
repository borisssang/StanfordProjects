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
    
    mutating func selectCard(at index: Int){
        let card = playingCards[index]
    
        // replacing matched cards if there are any
        if matchingCards.count > 0 {
            guard matchingCards.count == 3 else { return }
            dealCards(numberOfCards: 3)
            matchingCards = []
        }
        
        //selecting a new card, deselection of the last three
        if selectedCards.count == 3 {
            if !selectedCards.contains(card) {
            score -= 1
            selectedCards = []
            }
        }
        
        //select or deselect
        if let index = selectedCards.index(of: card) {
            selectedCards.remove(at: index)
        } else {
            selectedCards.append(card)
        }
        
        //matching happens
        if selectedCards.count == 3, areMatching(card1: selectedCards[0], card2: selectedCards[1], card3: selectedCards[2]){
            matchingCards = selectedCards
            selectedCards = []
            score += 1
        }
    }
    
    //returns number of cards requested // or all the cards left in the deck
    mutating func dealCards(numberOfCards: Int){
        
        if matchingCards.count > 0 {
            guard matchingCards.count == 3 else { return }
            dealCards(numberOfCards: 3)
            matchingCards = []
        }
        
        if allCards.count >= numberOfCards{
            for _ in 0..<numberOfCards{
                playingCards.append(allCards.removeLast())
            }}
        else {
            for _ in 0..<allCards.count{
                playingCards.append(allCards.removeLast())
            }
        }
    }
    
    private func areMatching(card1: Card, card2: Card, card3: Card) -> Bool{
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
    
   private func isConditioned1(_ card1: Card, _ card2: Card, _ card3: Card) -> Bool{
        if card1.cardNumber.rawValue == card2.cardNumber.rawValue && card3.cardNumber.rawValue == card2.cardNumber.rawValue {
            return true
        }
        else if card3.cardNumber.rawValue != card2.cardNumber.rawValue && card1.cardNumber.rawValue != card2.cardNumber.rawValue && card3.cardNumber.rawValue != card1.cardNumber.rawValue {
            return true
        }
        else { return false }
    }
    
   private func isConditioned2(_ card1: Card, _ card2: Card, _ card3: Card) -> Bool{
        if card1.cardColor.rawValue == card2.cardColor.rawValue && card3.cardColor.rawValue == card2.cardColor.rawValue {
            return true
        }
        else if card3.cardColor.rawValue != card2.cardColor.rawValue && card1.cardColor.rawValue != card2.cardColor.rawValue && card3.cardColor.rawValue != card1.cardColor.rawValue {
            return true
        }
        else { return false }    }
    
   private func isConditioned3(_ card1: Card, _ card2: Card, _ card3: Card) -> Bool{
        if card1.cardSymbol.rawValue == card2.cardSymbol.rawValue && card3.cardSymbol.rawValue == card2.cardSymbol.rawValue {
            return true
        }
        else if card3.cardSymbol.rawValue != card2.cardSymbol.rawValue && card1.cardSymbol.rawValue != card2.cardSymbol.rawValue && card3.cardSymbol.rawValue != card1.cardSymbol.rawValue {
            return true
        }
        else { return false }
    }
    
   private func isConditioned4(_ card1: Card, _ card2: Card, _ card3: Card) -> Bool{
        if card1.cardShading.rawValue == card2.cardShading.rawValue && card3.cardShading.rawValue == card2.cardShading.rawValue {
            return true
        }
        else if card3.cardShading.rawValue != card2.cardShading.rawValue && card1.cardShading.rawValue != card2.cardShading.rawValue && card3.cardShading.rawValue != card1.cardShading.rawValue {
            return true
        }
        else { return false }
    }
}
