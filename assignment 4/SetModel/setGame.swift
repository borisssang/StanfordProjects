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
    var matched = false
    
    var isDealingEnabled = true
    
    public var delegate: SetGameDelegate?
    
    private(set) var score = 0 {
        didSet{
            if score < 0 {
                score = 0
            }
        }
    }
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
        if selectedCards.count == 3, areCardsFormingSet(selectedCards[0], selectedCards[1], selectedCards[2]){
            matchingCards = selectedCards
            selectedCards = []
            score += 1
            matched = true
            delegate?.selectedCardsDidMatch(matchingCards)
            replaceMatchedCards()
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
    
    mutating func restartGame(){
        allCards=Card.fillDeck()
        playingCards = []
        selectedCards = []
        matchingCards = []
        score = 0
        matched = false 
        isDealingEnabled = true
    }
    
    mutating func replaceMatchedCards() {
        guard matchingCards.count == 3 else { return }
        dealCards(numberOfCards: 3)
        matchingCards = []
    }
    
    private func areCardsFormingSet(_ card1: Card, _ card2: Card, _ card3: Card) -> Bool{
        var areNumbersSet, areColorsSet, areSymbolsSet, areStripingsSet: Bool
        
        let cardNumbers: Set = [card1.cardNumber.rawValue, card2.cardNumber.rawValue, card3.cardNumber.rawValue]
        let cardColors: Set = [card1.cardColor.rawValue, card2.cardColor.rawValue, card3.cardColor.rawValue]
        let cardSymbols: Set = [card1.cardSymbol.rawValue, card2.cardSymbol.rawValue, card3.cardSymbol.rawValue]
        let cardStripings: Set = [card1.cardStriping.rawValue, card2.cardStriping.rawValue, card3.cardStriping.rawValue]
        
        if cardNumbers.count == 3 || cardNumbers.count == 1 {
           areNumbersSet = true
        } else { areNumbersSet = false}
        if cardColors.count == 3 || cardColors.count == 1 {
            areColorsSet = true
        } else {areColorsSet = false}
        if cardSymbols.count == 3 || cardSymbols.count == 1 {
            areSymbolsSet = true
        } else {areSymbolsSet = false}
        if cardStripings.count == 3 || cardStripings.count == 1 {
            areStripingsSet = true
        } else {areStripingsSet = false}
       
        if areSymbolsSet && areNumbersSet && areColorsSet && areStripingsSet {
            return true
        }else {return false}
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


