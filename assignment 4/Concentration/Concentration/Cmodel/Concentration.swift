//
//  Concentration.swift
//  Lecture 4 - Concentration
//
//  Created by Michel Deiman on 13/11/2017.
//  Copyright © 2017 Michel Deiman. All rights reserved.
//

import Foundation

@objc protocol ConcentrationDelegate{
    func didMatchCards(withIndices: [Int])
    @objc optional func didResetGame(withTheme: String) -> String
}

class Concentration {
    
    var delegate: ConcentrationDelegate?
    var cards = [ConcentrationCard]()
    var flipCount = 0
    var score = 0
    var currentPairOfIndices: [Int]?
    
    var emojiTheme: String = ""
    var themes = ["Happy", "Sad", "Scary"]
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
		set {
                setCurrentPairToFaceDown()
			}
		}
    
	init(numberOfPairsOfCards: Int) {
		assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)) : You must have at least one pair of cards")
		for _ in 1...numberOfPairsOfCards {
			let card = ConcentrationCard()
			cards += [card, card]
		}
	shuffleCards()
	}
    
    func shuffleCards() {
        for i in 0 ..< cards.count {
            let j = Int(arc4random_uniform(UInt32(cards.count)))
            let temp = cards[i]
            cards[i] = cards[j]
            cards[j] = temp
        }
    }
    
    func restartGame() -> String{
        self.flipCount=0
        self.score = 0
        self.indexOfOneAndOnlyFaceUpCard = nil
       ConcentrationCard.resetIdentifiersCount()
        let pairsCount = cards.count/2
        cards = []
        currentPairOfIndices = nil
        for _ in 0..<pairsCount {
            let currentCard = ConcentrationCard()
            
            cards.append(currentCard)
            cards.append(currentCard)
        }
        return randomTheme()
    }
    
    //generates a random theme
    func randomTheme() -> String{
        let random = themes.count.arc4Random
            return themes[random]
    }

//    private func removeMatchedPair() {
//        let matchedCards = cards.filter { $0.isMatched }
//
//        guard !matchedCards.isEmpty else { return }
//
//        for card in matchedCards {
//            if let index = cards.index(of: card) {
//                cards.remove(at: index)
//            }
//        }
//    }
    
    func flipCard(at index: Int) {
        var selectedCard = cards[index]
        // If the card was matched, ignore the flip request.
        guard !selectedCard.isMatched else { return }
        
        // If we have matched cards, the delegate is called
        // and the matched cards are removed.
        if let currentPairIndices = currentPairOfIndices {
            delegate?.didMatchCards(withIndices: currentPairIndices)
            self.currentPairOfIndices = nil
        }
        
        // If we already have one previously flipped card,
        // it means that we now have two faced up cards.
        // Thus we need to check for a match.
        if let firstCardIndex = indexOfOneAndOnlyFaceUpCard, firstCardIndex != index {
            
            var firstCard = cards[firstCardIndex]
            
            // Do we have a match?
            if firstCard == selectedCard {
                firstCard.isMatched = true
                selectedCard.isMatched = true
                score+=1
                currentPairOfIndices = [firstCardIndex, index]
            }
            
            cards[firstCardIndex] = firstCard
            
        } else {
            indexOfOneAndOnlyFaceUpCard = index
        }
        
       selectedCard.isFaceUp = !selectedCard.isFaceUp
        cards[index] = selectedCard
        flipCount+=1
    }
    
    private func setCurrentPairToFaceDown() {
        /// Indicates if the penalty was already applied.
        var didPenalize = false
        
        // Loops through all cards to face them down,
        // and it also checks for missmatches penalty.
        for cardIndex in cards.indices {
            var currentCard = cards[cardIndex]
            
            if currentCard.isFaceUp {
                
                // We check if we should penalize the player,
                // in the case of an already seen card.
                if currentCard.hasBeenFlipped && !currentCard.isMatched && !didPenalize {
                    score -= 1
                    // The penalization should be applied only once.
                    didPenalize = true
                }
                
                // The flipped state is applied after the check for penalty is made.
                currentCard.hasBeenFlipped = true
                currentCard.isFaceUp = false
            }
            cards[cardIndex] = currentCard
        }
    }
}

extension Collection {
	var oneAndOnly: Element? {
		return count == 1 ? first : nil
	}
}




