//
//  Concentration.swift
//  Lecture 2 - Concentration
//
//  Created by Michel Deiman on 13/11/2017.
//  Copyright © 2017 Michel Deiman. All rights reserved.
//

import Foundation

class Concentration {
	
	var cards = [Card]()
	var indexOfOneAndOnlyFaceUpCard: Int?
	
	func chooseCard(at index: Int) {
		if !cards[index].isMatched {
			if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
				// check if cards match
				if cards[matchIndex].identifier == cards[index].identifier {
					cards[matchIndex].isMatched = true
					cards[index].isMatched = true
				}
				cards[index].isFaceUp = true
				indexOfOneAndOnlyFaceUpCard = nil	// not one and only ...
			} else {
				// either no card or two cards face up
				for flipdownIndex in cards.indices {
					cards[flipdownIndex].isFaceUp = false
				}
				cards[index].isFaceUp = true
				indexOfOneAndOnlyFaceUpCard = index
			}
			
		}
	}
	
	init(numberOfPairsOfCards: Int) {
		for _ in 1...numberOfPairsOfCards {
			let card = Card()
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
}
