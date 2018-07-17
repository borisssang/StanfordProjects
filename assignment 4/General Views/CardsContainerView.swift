//
//  CardsContainerView.swift
//  Lecture 4 - Concentration
//
//  Created by Boris Angelov on 10.07.18.
//  Copyright © 2018 Michel Deiman. All rights reserved.
//
import UIKit

//delegate listening for cards action and then reporting to the controller or view
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
    
    //the frame to which cards are being removed
    var discardToFrame: CGRect!
    //the frame from which all cards are being dealt
    var dealingFromFrame: CGRect!
    var isPerformingDealAnimation = false
    var scheduledDealAnimations: [Timer]?
    
    var buttonsToPosition: [CardViewButton] {
        return cards
    }
    
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        animator.removeAllBehaviors()
        isPerformingDealAnimation = false
        scheduledDealAnimations = nil
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
    
    func respositionViews() {
        grid.frame = centeredRect
        
        for (i, button) in buttonsToPosition.enumerated() {
            if let frame = grid[i] {
                button.frame = frame
            }
        }
        setNeedsLayout()
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

    //to be overriden by children classes
    func makeButtons(byAmount numberOfButtons: Int) -> [CardViewButton] {return [] }
    
    //adding cards if there is no deal animation
    //calling dealCardsWithAnimation
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
     //   self.delegate?.cardsDealDidFinish()
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
    
    func resetContainer(){
        cards = []
        grid.cellCount = 0
        for subview in subviews {
            subview.removeFromSuperview()
        }
        setNeedsLayout()
    }
    
    //stops all current animations while being rotated
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
    
    //to be overriden by the SetGameView
    func animateCardsOut(_ buttons: [CardViewButton]) {}
    
}

extension UIView {
    
    /// Removes all subviews.
    func removeAllSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
    
    func flipView(animated: Bool = false, completion: Optional<(UIView) -> ()> = nil) {
        if animated {
            UIView.transition(with: self,
                              duration: 0.3,
                              options: .transitionFlipFromLeft,
                              animations: {
                                self.layer.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1).cgColor
            }) { completed in
                if let completion = completion {
                    completion(self)
                }
            }
        } else {
            self.layer.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1).cgColor
        }
    }
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
