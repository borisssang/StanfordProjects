//
//  ConcentrationButton.swift
//  Lecture 4 - Concentration
//
//  Created by Boris Angelov on 12.07.18.
//  Copyright © 2018 Michel Deiman. All rights reserved.
//

import UIKit

class ConcentrationButton: CardViewButton {

    typealias Emoji = String
    var buttonText: Emoji?{
        didSet{
            setNeedsDisplay()
        }
    }
    
    override func drawFront() {
        layer.backgroundColor = UIColor.white.cgColor
        titleLabel?.font = UIFont.systemFont(ofSize: 50)
            setTitle(buttonText, for: .normal)
    }
    
    override func drawBack() {
        layer.backgroundColor = UIColor.gray.cgColor
        setTitle(nil, for: .normal)
    }
}
