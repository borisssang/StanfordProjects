//
//  CardView.swift
//  setGame
//
//  Created by Boris Angelov on 29.06.18.
//  Copyright © 2018 Boris Angelov. All rights reserved.
//

import UIKit

@IBDesignable
class CardViewButton: UIButton {
    
    var symbol: Card.Symbol? {didSet{setNeedsDisplay()}}
    var color: Card.Color? {didSet{setNeedsDisplay()}}
    var shading: Card.Shading? {didSet{setNeedsDisplay()}}
    var numberOfSymbols = 0 {didSet{setNeedsDisplay()}}
    
    
    
}