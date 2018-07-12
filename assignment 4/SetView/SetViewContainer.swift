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

    override func animateCardsOut(_ buttons: [CardViewButton]) {
        guard discardToFrame != nil else { return }
        guard let buttons = buttons as? [SetCardButton] else { return }
        
        var buttonsCopies = [UIView]()
        
        func buttonToView(fromButton button: UIButton) -> UIView{
            let buttonView = UIView()
            buttonView.backgroundColor = button.backgroundColor
            buttonView.center = button.center
            buttonView.bounds.size = button.bounds.size
            buttonView.contentMode = button.contentMode
            buttonView.frame.size.width = button.frame.size.width
            buttonView.frame.size.height = button.frame.size.height
            buttonView.layer.cornerRadius = button.layer.cornerRadius
            buttonView.layer.borderColor = button.layer.borderColor
            buttonView.layer.borderWidth = button.layer.borderWidth
            return buttonView
        }

        for button in buttons {
            let buttonView = buttonToView(fromButton: button)
            buttonsCopies.append(buttonView)
            addSubview(buttonView)
            
            // Hides the original button.
            button.isActive = false
        }
        
        // Starts animating by scaling each view.
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.8,
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
                withDuration: 0.8,
                delay: 0,
                options: .curveEaseIn,
                animations: {
                    
                    buttonsCopies.forEach { $0.center = self.center }
                    
            }, completion: { position in
                // Flips each card down
                buttonsCopies.forEach { $0.flipView() }
                
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

