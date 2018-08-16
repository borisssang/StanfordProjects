//
//  ConcentrationCard.swift
//  Lecture 4 - Concentration
//
//  Created by Boris Angelov on 10.07.18.
//  Copyright © 2018 Michel Deiman. All rights reserved.
//

import Foundation

struct ConcentrationCard{
    
    var hasBeenFlipped = false
    var carPenalty = 0
    var isFaceUp = false
    var isMatched = false
    var ConcentrationCardPenalty = -1
    
    private var identifier: Int
    
    init() {
        self.identifier = ConcentrationCard.makeIdentifier()
    }
    
    private static var identifiersCount = -1
    
    /// Resets the current identifier count.
    static func resetIdentifiersCount() {
        identifiersCount = -1
    }
    
    /// Returns a new identifier for model usage.
    static func makeIdentifier() -> Int {
        identifiersCount += 1
        return identifiersCount
    }
}

extension ConcentrationCard: Hashable {
    
    var hashValue: Int {
        return identifier
    }
    
    static func ==(lhs: ConcentrationCard, rhs: ConcentrationCard) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
