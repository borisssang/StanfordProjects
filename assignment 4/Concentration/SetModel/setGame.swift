//
//  setGame.swift
//  setGame
//
//  Created by Boris Angelov on 21.06.18.
//  Copyright © 2018 Boris Angelov. All rights reserved.
//

import Foundation

protocol SetGameDelegate {
    
    /// Method called when the current game's selection is a match.
    func selectedCardsDidMatch(_ cards: [Card])
    
}

struct setGame{
    
    var allCards = Card.fillDeck()
    var playingCards = [Card]()
    var selectedCards = [Card]()
    var matchingCards = [Card]()
    var matchedTrioLimit = true
    
    var isDealingEnabled = true
    
    public var delegate: SetGameDelegate?
    
    public var score = 0
    
    mutating func selectCard(at index: Int){
        let card = playingCards[index]
        
        matchedTrioLimit = true
        
        // replacing matched cards if there are any
        if matchingCards.count > 0 {
            guard matchingCards.count == 3 else { return }
            dealCards(numberOfCards: 3)
            matchingCards = []
            if allCards.count == 0 {
                matchedTrioLimit = false
            }
        }
        
        //selecting a new card, deselection of the last three
        if selectedCards.count == 3 {
            if !selectedCards.contains(card) {
                selectedCards = []
            }
        }
        
        //select or deselect
        if let index = selectedCards.index(of: card) {
            if selectedCards.count < 3 {selectedCards.remove(at: index) }
        } else {
            selectedCards.append(card)
        }
        
        //matching happens
        if selectedCards.count == 3, areMatching(card1: selectedCards[0], card2: selectedCards[1], card3: selectedCards[2]){
            matchingCards = selectedCards
            selectedCards = []
            score += 1
            delegate?.selectedCardsDidMatch(matchingCards)
        }
    }
    
    //returns number of cards requested // or all the cards left in the deck
    mutating func dealCards(numberOfCards: Int){
        
        if matchingCards.count > 0 {
            guard allCards.count >= numberOfCards else {
                for card in matchingCards {
                    let index = playingCards.index(of: card)!
                    playingCards.remove(at: index)
                }
                matchingCards = []
                return
            }
            
            for (index, card) in playingCards.enumerated() {
                if matchingCards.contains(card){
                    playingCards[index] = allCards.removeFirst()
                }
            }
            matchingCards = []
        }
        else if matchingCards.count == 0 {
            if allCards.count >= numberOfCards{
                for _ in 0..<numberOfCards{
                    playingCards.append(allCards.removeLast())
                }}
            else {
                for _ in 0..<allCards.count{
                    playingCards.append(allCards.removeLast())
                }
                isDealingEnabled = false
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
        isDealingEnabled = true
    }
    
    mutating func replaceMatchedCards() {
        guard matchingCards.count == 3 else { return }
        dealCards(numberOfCards: 3)
        matchingCards = []
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
        if card1.cardStriping.rawValue == card2.cardStriping.rawValue && card3.cardStriping.rawValue == card2.cardStriping.rawValue {
            return true
        }
        else if card3.cardStriping.rawValue != card2.cardStriping.rawValue && card1.cardStriping.rawValue != card2.cardStriping.rawValue && card3.cardStriping.rawValue != card1.cardStriping.rawValue {
            return true
        }
        else { return false }
    }
    
    mutating func shufflePlayingCards(){
        for i in 0 ..< playingCards.count {
            let j = Int(arc4random_uniform(UInt32(playingCards.count)))
            let temp = playingCards[i]
            playingCards[i] = playingCards[j]
            playingCards[j] = temp
        }
    }
}


