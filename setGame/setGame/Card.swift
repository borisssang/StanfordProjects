//
//  File.swift
//  setGame
//
//  Created by Boris Angelov on 21.06.18.
//  Copyright © 2018 Boris Angelov. All rights reserved.
//

import Foundation

struct Card: Hashable{
    let cardNumber: Number
    let cardSymbol: Symbol
    let cardShading: Shading
    let cardColor: Color
    var identifier = 0
    
    var hashValue: Int {
        return identifier
    }
    
    enum Number: String{
        case one = "one"
        case two = "two"
        case three = "three"
        static let allValues = [one,two,three]
    }
    enum Symbol: String {
        case diamond = "diamond"
        case squiggle = "squiggle"
        case oval = "oval"
        static let allValues = [diamond, squiggle, oval]
    }
    enum Shading: String{
        case solid = "solid"
        case striped = "striped"
        case open = "open"
        static let allValues = [solid, striped, open]
    }
    enum Color : String{
        case red = "red"
        case green = "green"
        case purple = "purple"
        static let allValues = [red, green, purple]
    }
    
    static func fillDeck() -> [Card]{
        var deck = [Card]()
        
        //append all card variations
        for number in Number.allValues{
            for symbol in Symbol.allValues {
                for shading in Shading.allValues {
                    for color in Color.allValues{
                        let newIdentifier = Card.getUniqueIdentifier()
                        let newCard = Card(cardNumber: number, cardSymbol: symbol, cardShading: shading, cardColor: color, identifier: newIdentifier)
                        deck.append(newCard)
                    }
                }
            }
        }
        //shuffle the cards
        for i in 0 ..< deck.count {
            let j = Int(arc4random_uniform(UInt32(deck.count)))
            let temp = deck[i]
            deck[i] = deck[j]
            deck[j] = temp
        }
        return deck
    }
    
    private static var identifierFactory = 0

    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
}
