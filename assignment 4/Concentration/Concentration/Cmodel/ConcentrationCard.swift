//
//  ConcentrationCard.swift
//  Lecture 4 - Concentration
//
//  Created by Boris Angelov on 10.07.18.
//  Copyright © 2018 Michel Deiman. All rights reserved.
//

import Foundation

struct ConcentrationCard: Hashable {
    
    var hashValue: Int {
        return identifier
    }
    
    static func ==(lhs: ConcentrationCard, rhs: ConcentrationCard) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var carPenalty = 0
    var isFaceUp = false
    var isMatched = false
    var ConcentrationCardPenalty = -1
    private var identifier: Int
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = ConcentrationCard.getUniqueIdentifier()
    }
    
}
