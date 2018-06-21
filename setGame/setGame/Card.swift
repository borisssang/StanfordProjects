//
//  File.swift
//  setGame
//
//  Created by Boris Angelov on 21.06.18.
//  Copyright © 2018 Boris Angelov. All rights reserved.
//

import Foundation

struct Card: Hashable{
    var cardNumber: number
    var cardSymbol: symbol
    var cardShading: shading
    var cardColor: color

    
    //how to identify and create the 81different combinations
    private var identifier: Int
    
    enum number{
        case one
        case two
        case three
    }
    enum symbol {
        case diamond
        case squiggle
        case oval
    }
    enum shading{
        case solid
        case striped
        case open
    }
    enum color{
        case red
        case gree
        case purple
    }
    
//    private static var identifierFactory = 0
//
//    private static func getUniqueIdentifier() -> Int {
//        identifierFactory += 1
//        return identifierFactory
//    }
//
//    init() {
//        self.identifier = Card.getUniqueIdentifier()
//    }
    
}
