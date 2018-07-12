//
//  ConcentrationViewContainer.swift
//  Lecture 4 - Concentration
//
//  Created by Boris Angelov on 12.07.18.
//  Copyright © 2018 Michel Deiman. All rights reserved.
//

import UIKit

class ConcentrationViewContainer: ViewContainer {

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        if numberOfButtonsForDisplay > 0 {
            addCards(byAmount: numberOfButtonsForDisplay)
            
            respositionViews()
            
            for button: ConcentrationButton in cards as! [ConcentrationButton] {
                button.alpha = 1
                button.isFaceUp = true
                
                button.setNeedsDisplay()
            }
        }
    }
    
    override func awakeFromNib() {
        animator.delegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if grid.frame != centeredRect {
            updateViewsFrames()
        }
    }
    
    override func makeButtons(byAmount numberOfButtons: Int) -> [CardViewButton] {
        return (0..<numberOfButtons).map { _ in SetCardButton() }
    }
    
    func removeCards(times numberOfCardsRemoved: Int){
        for i in 0..<numberOfCardsRemoved {
            let card = cards[i]
            card.removeFromSuperview()
        }
        cards.removeSubrange(0..<numberOfCardsRemoved)
        grid.cellCount = cards.count
        setNeedsLayout()
    }


}
