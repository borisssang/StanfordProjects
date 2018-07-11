//
//  ViewContainer.swift
//  Lecture 4 - Concentration
//
//  Created by Boris Angelov on 6.07.18.
//  Copyright © 2018 Michel Deiman. All rights reserved.
//

import UIKit

@IBDesignable
class SetViewContainer: ViewContainer {
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        if numberOfButtonsForDisplay > 0 {
            addCards(byAmount: numberOfButtonsForDisplay)
            
            respositionViews()
            
            for button: SetCardButton in cards as! [SetCardButton] {
                button.alpha = 1
                button.isFaceUp = true
                
                //IN NEEEEED OF FUNC IMPLEMENTATIONS
                
//                button.symbol = SetCardButton.CardSymbolShape.randomized()
//                button.color = SetCardButton.CardColor.randomized()
//                button.striping = SetCardButton.CardSymbolShading.randomized()
//                button.numberOfSymbols = 4.arc4random
//
                if (button.numberOfSymbols == 0 || button.numberOfSymbols > 3) {
                    button.numberOfSymbols = 1
                }
                
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

    override func animateCardsOut(_ buttons: [CardViewButton]) {
        guard discardToFrame != nil else { return }
        guard let buttons = buttons as? [SetCardButton] else { return }
        
        var buttonsCopies = [SetCardButton]()
        
        //COPYING IMPLEMENTATION 
        
//        for button in buttons {
//            // Creates the button copy used to be animated.
//            let buttonCopy = button.copy(nil) as! SetCardButton
//            buttonsCopies.append(buttonCopy)
//            addSubview(buttonCopy)
//
//            // Hides the original button.
//            button.isActive = false
//        }
        
        // Starts animating by scaling each button.
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.1,
            delay: 0,
            options: .curveEaseIn,
            animations: {
                
                buttonsCopies.forEach {
                    $0.bounds.size = CGSize(
                        width: $0.frame.size.width * 1.1,
                        height: $0.frame.size.height * 1.1
                    )
                }
                
        }, completion: { position in
            
            // Animates each card to the center of the container view.
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.2,
                delay: 0,
                options: .curveEaseIn,
                animations: {
                    
                    buttonsCopies.forEach { $0.center = self.center }
                    
            }, completion: { position in
                // Flips each card down
                buttonsCopies.forEach { $0.flipCard() }
                
                // Animates each card to the matched deck.
                
                Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
                    buttonsCopies.forEach { button in
                        let snapOutBehavior = UISnapBehavior(item: button, snapTo: self.discardToFrame.center)
                        snapOutBehavior.damping = 0.8
                        self.animator.addBehavior(snapOutBehavior)
                        
                        UIViewPropertyAnimator.runningPropertyAnimator(
                            withDuration: 0.2,
                            delay: 0,
                            options: .curveEaseIn,
                            animations: {
                                button.bounds.size = self.discardToFrame.size
                        }
                        )
                    }
                }
                
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 0.2,
                    delay: 1,
                    options: .curveEaseInOut,
                    animations: {
                        buttonsCopies.forEach { $0.alpha = 0 }
                }) { _ in
                    buttonsCopies.forEach {
                        $0.removeFromSuperview()
                    }
                    
                    // Calls the delegate, if set.
                    if let delegate = self.delegate {
                        delegate.cardsRemovalDidFinish()
                    }
                }
                
            })
        })
    }
    
}

