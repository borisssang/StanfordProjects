//
//  ConcentrationViewContainer.swift
//  Lecture 4 - Concentration
//
//  Created by Boris Angelov on 12.07.18.
//  Copyright © 2018 Michel Deiman. All rights reserved.
//

import UIKit

class ConcentrationViewContainer: ViewContainer{

    override var buttonsToPosition: [CardViewButton] {
        return cards.filter({ $0.isActive })
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        if numberOfButtonsForDisplay > 0 {
            addCards(byAmount: numberOfButtonsForDisplay)
            
            respositionViews()
            
            for button: ConcentrationButton in cards as! [ConcentrationButton] {
                button.isActive = true
                button.isFaceUp = false
                
                button.setNeedsDisplay()
            }
        }
    }
    
    override func awakeFromNib() {
        let discardToOrigin = convert(CGPoint(x: UIScreen.main.bounds.width,
                                              y: UIScreen.main.bounds.height / 2),
                                      to: self)
        discardToFrame = CGRect(origin: discardToOrigin,
                                size: CGSize(width: 80,
                                             height: 120))
        
        let dealFromOrigin = convert(CGPoint(x: 0,
                                             y: UIScreen.main.bounds.height),
                                     to: self)
        dealingFromFrame = CGRect(origin: dealFromOrigin,
                                  size: CGSize(width: 80,
                                               height: 120))
    }
    
    override func makeButtons(byAmount numberOfButtons: Int) -> [CardViewButton] {
        return (0..<numberOfButtons).map { _ in ConcentrationButton() }
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
        guard let buttons = buttons as? [ConcentrationButton] else { return }

        var buttonsCopies = [UIView]()
        
        for button in buttons {
            let buttonView = buttonToView(fromButton: button)
            buttonsCopies.append(buttonView)
            addSubview(buttonView)
            
            // Hides the original button.
            button.isActive = false
        }

        // Animates each card to the center of the container.
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.2,
            delay: 0.2,
            options: .curveEaseInOut,
            animations: {

                buttonsCopies.forEach {
                    $0.center = self.center
                }

        }, completion: { position in

            // Starts animating by scaling each button.
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.3,
                delay: 0,
                options: .curveEaseInOut,
                animations: {

                    buttonsCopies.forEach {
                        $0.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                    }

            }, completion: { position in

                // Animates each card to the matched deck.
                Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in
                    buttonsCopies.forEach { button in
                        let snapOutBehavior = UISnapBehavior(item: button, snapTo: self.discardToFrame.center)
                        snapOutBehavior.damping = 1
                        self.animator.addBehavior(snapOutBehavior)

                        UIViewPropertyAnimator.runningPropertyAnimator(
                            withDuration: 0.2,
                            delay: 0,
                            options: .curveEaseInOut,
                            animations: {
                                button.bounds.size = self.discardToFrame.size
                        }
                        )
                    }
 
                    Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false) { _ in
                        buttonsCopies.forEach { $0.alpha = 0 }
                        buttonsCopies.forEach { $0.removeFromSuperview() }

                        self.delegate?.cardsRemovalDidFinish()
                    }
                }
            })
        })
    }
    override func removeInactiveCardButtons(withCompletion completion: Optional<() -> ()>) {
        let inactiveButtons = cards.filter { !$0.isActive }
        guard inactiveButtons.count > 0 else { return }

        grid.cellCount = cards.filter({ $0.isActive }).count
        updateViewsFrames(withAnimation: true, andCompletion: completion)
    }


}
