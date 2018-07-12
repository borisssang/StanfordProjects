//
//  Concentration.swift
//  Lecture 4 - Concentration
//
//  Created by Michel Deiman on 13/11/2017.
//  Copyright © 2017 Michel Deiman. All rights reserved.
//

import Foundation

protocol ConcentrationDelegate{
    func didMatchCards(withIndices: [Int])
}

class Concentration {
    
    var delegate: ConcentrationDelegate?
    private(set) var cards = [ConcentrationCard]()
    var flipCount = 0
    var score = 0
    
    var emojiTheme: String = ""
    var themes = ["Happy", "Sad", "Scary"]
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
		set {
			for index in cards.indices {
				cards[index].isFaceUp = (index == newValue)
			}
		}
				
	}
	
	func chooseCard(at index: Int) {
		assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)) : Choosen index out of range")
		if !cards[index].isMatched {
            flipCount+=1
            cards[index].carPenalty+=1
			if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
				// check if cards match
				if cards[matchIndex] == cards[index] {
					cards[matchIndex].isMatched = true
					cards[index].isMatched = true
                    score+=2
              //     delegate?.didMatchCards(withIndices:)
				}
                else {
                    score-=cards[index].carPenalty
                }
				cards[index].isFaceUp = true
			} else {
				indexOfOneAndOnlyFaceUpCard = index
			}
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
    
    func restartGame() -> String {
        self.flipCount=0
        self.score = 0
        self.indexOfOneAndOnlyFaceUpCard = nil
        for i in 0..<cards.count{
            cards[i].isFaceUp=false
            cards[i].isMatched=false
        }
        self.shuffleCards()
        
        return randomTheme()
    }
    
    //generates a random theme
    func randomTheme() -> String{
        let random = themes.count.arc4Random
            return themes[random]
    }
    
}

extension Collection {
	var oneAndOnly: Element? {
		return count == 1 ? first : nil
	}
}




