//
//  CardsContainerView.swift
//  Lecture 4 - Concentration
//
//  Created by Boris Angelov on 10.07.18.
//  Copyright © 2018 Michel Deiman. All rights reserved.
//
import UIKit

protocol CardsContainerViewDelegate {
    
    func cardsRemovalDidFinish()
    
    func cardsDealDidFinish()
    
    func didFinishDealingCard(_ button: CardViewButton)
}

@IBDesignable
class ViewContainer: UIView, UIDynamicAnimatorDelegate {
    
    var delegate: CardsContainerViewDelegate?
    var cards = [CardViewButton]()
    @IBInspectable var numberOfButtonsForDisplay: Int = 0
    var grid = Grid(layout: Grid.Layout.aspectRatio(3/2))
    lazy var animator = UIDynamicAnimator(referenceView: self)
    var positioningAnimator: UIViewPropertyAnimator?
    
    var discardToFrame: CGRect!
    var dealingFromFrame: CGRect!
    var isPerformingDealAnimation = false
    var scheduledDealAnimations: [Timer]?
    
    var buttonsToPosition: [CardViewButton] {
        return cards
    }
    
    //sets the position of the grid
    var centeredRect: CGRect {
        get {
            return CGRect(x: bounds.size.width * 0.025,
                          y: bounds.size.height * 0.025,
                          width: bounds.size.width * 0.95,
                          height: bounds.size.height * 0.95)
        }
    }
    
    override func awakeFromNib() {
        animator.delegate = self
    }
    
    func makeButtons(byAmount numberOfButtons: Int) -> [CardViewButton] {return [] }
    
    func addCards(byAmount numberOfButtons: Int = 3, animated: Bool = false) {
        guard isPerformingDealAnimation == false else { return }
        
        let cardButtons = makeButtons(byAmount: numberOfButtons)
        
        for button in cardButtons {
            // Each button is hidden and face down by default.
            button.isActive = false
            button.isFaceUp = false
            
            addSubview(button)
            cards.append(button)
        }
        
        grid.cellCount += cardButtons.count
        grid.frame = centeredRect
        
        if animated {
            dealCardsWithAnimation()
        }
    }
    
    func resetContainer(){
        cards = []
        grid.cellCount = 0
        for subview in subviews {
            subview.removeFromSuperview()
        }
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if grid.frame != centeredRect {
            updateViewsFrames()
        }
    }
    
    func prepareForRotation() {
        animator.removeAllBehaviors()
        
        // Invalidates all scheduled deal animations.
        scheduledDealAnimations?.forEach { timer in
            if timer.isValid {
                timer.invalidate()
            }
        }
        
        positioningAnimator?.stopAnimation(true)
        
        for button in cards {
            button.transform = .identity
            button.setNeedsDisplay()
        }
        
        isPerformingDealAnimation = false
    }
    
    func dealCardsWithAnimation() {
        
        guard isPerformingDealAnimation == false else { return }
        
        guard !cards.filter({ !$0.isActive }).isEmpty else { return }
        
        isPerformingDealAnimation = true
        
        updateViewsFrames(withAnimation: true) {
            var dealAnimationDelay = 0.0
            
            for (i, button) in self.cards.enumerated() {
                if button.isActive { continue }
                
                guard let currentFrame = self.grid[i] else { continue }
                
                button.isFaceUp = false
                
                // Changes the position and size to match the provided deck's frame.
                button.frame = self.dealingFromFrame
                self.bringSubview(toFront: button)
                
                // The card will appear on top of the deck.
                button.isActive = true
                
                let snapBehavior = UISnapBehavior(item: button,
                                                  snapTo: currentFrame.center)
                snapBehavior.damping = 0.8
                
                if self.scheduledDealAnimations == nil {
                    self.scheduledDealAnimations = []
                }
                
                let animationTimer = Timer.scheduledTimer(withTimeInterval: dealAnimationDelay, repeats: false) { _ in
                    // Apply the snap behavior.
                    self.animator.addBehavior(snapBehavior)
                    
                    // Animates the button's size.
                    UIViewPropertyAnimator.runningPropertyAnimator(
                        withDuration: 0.2,
                        delay: 0,
                        options: .curveEaseIn,
                        animations: {
                            button.bounds.size = currentFrame.size
                    }
                    )
                    
                    Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false) { _ in
                        self.delegate?.didFinishDealingCard(button)
                    }
                }
                
                self.scheduledDealAnimations!.append(animationTimer)
                
                dealAnimationDelay += 0.2
            }
        }
    }
    
    func updateViewsFrames(withAnimation animated: Bool = false,
                           andCompletion completion: Optional<() -> ()> = nil) {
        grid.frame = centeredRect
        
        if animated {
            if let propertyAnimator = positioningAnimator {
                propertyAnimator.stopAnimation(true)
                positioningAnimator = nil
            }
            
            positioningAnimator = UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.2,
                delay: 0,
                options: .curveEaseInOut,
                animations: {
                    self.respositionViews()
            }
            ) { _ in
                if let completion = completion {
                    completion()
                }
            }
            
            print("Positioning animator: \(positioningAnimator!)")
        } else {
            respositionViews()
        }
    }
    
    func animateCardsOut(_ buttons: [CardViewButton]) {}
    
    func respositionViews() {
        grid.frame = centeredRect
        
        for (i, button) in cards.enumerated() {
            if let frame = grid[i] {
                button.frame = frame
            }
        }
        setNeedsLayout()
    }
    
    func removeInactiveCardButtons(withCompletion completion: Optional<() -> ()> = nil) {
        let inactiveButtons = cards.filter { !$0.isActive }
        
        guard inactiveButtons.count > 0 else { return }
        
        for button in inactiveButtons {
            cards.remove(at: cards.index(of: button)!)
            button.removeFromSuperview()
        }
        
        grid.cellCount = cards.count
        updateViewsFrames(withAnimation: true, andCompletion: completion)
    }
    
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        animator.removeAllBehaviors()
        isPerformingDealAnimation = false
        scheduledDealAnimations = nil
    }
    
    func clearCardContainer(withAnimation animated: Bool = false, completion: Optional<() -> ()> = nil) {
        if animated {
            animateCardsOut(cards)
        }
        
        cards.forEach {
            $0.removeFromSuperview()
        }
        cards = []
        grid.cellCount = 0
        
        setNeedsLayout()
    }
    
}

extension UIView {
    
    /// Removes all subviews.
    func removeAllSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
}
extension CGRect {
    
    /// Returns the center of this rect.
    var center: CGPoint {
        return CGPoint(
            x: midX,
            y: midY
        )
    }
    
}
