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
    
    var symbol: String?  {didSet{setNeedsDisplay()}}
    var color = UIColor() {didSet{setNeedsDisplay()}}
    var striping: String? {didSet{setNeedsDisplay()}}
    var numberOfSymbols: Int? {didSet{setNeedsDisplay()}}
    
    private func drawSquiggles(times numberOfTimes: Int)
    {
        
    }
    
    private func drawDiamonds(times numberOfTimes: Int){}
    
    private func drawOvals(times numberOfTimes: Int){}
    
    var cardRect: CGRect {
        get {
            return CGRect(x: frame.size.width * 0.025,
                          y:frame.size.height * 0.025,
                          width: frame.size.width * 0.95,
                          height: frame.size.height * 0.95)
        }
    }
    
    override func draw(_ rect: CGRect) {
//        switch striping {
//        case "solid":
//        case "unfilled":
//        case "striped":
//        default: break
//        }
        
        switch symbol {
        case "diamond":
        drawDiamonds(times: numberOfSymbols!)
        case "oval":
            drawOvals(times: numberOfSymbols!)
        case "squiggle":
            drawSquiggles(times: numberOfSymbols!)
        default: break
        }
        
        //more than one symbol -> depend on the aspect ratio of the card
    }
    
    
}
