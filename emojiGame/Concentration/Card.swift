//
//  Card.swift
//  Lecture 4 - Concentration
//
//  Created by Michel Deiman on 13/11/2017.
//  Copyright © 2017 Michel Deiman. All rights reserved.
//

import Foundation

struct Card: Hashable {
	
	var hashValue: Int {
		return identifier
	}
	
	static func ==(lhs: Card, rhs: Card) -> Bool {
		return lhs.identifier == rhs.identifier
	}
	
	var isFaceUp = false
	var isMatched = false
    var cardPenalty = -1
	private var identifier: Int
	
	private static var identifierFactory = 0
	
	private static func getUniqueIdentifier() -> Int {
		identifierFactory += 1
		return identifierFactory
	}
	
	init() {
		self.identifier = Card.getUniqueIdentifier()
	}
    
}
