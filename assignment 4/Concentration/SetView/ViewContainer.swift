//
//  ViewContainer.swift
//  Lecture 4 - Concentration
//
//  Created by Boris Angelov on 6.07.18.
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
    var grid = Grid(layout: Grid.Layout.aspectRatio(3/2))
    lazy var animator = UIDynamicAnimator(referenceView: self)
    var positioningAnimator: UIViewPropertyAnimator?
    
    var discardToFrame: CGRect!
    var dealingFromFrame: CGRect!
    var isPerformingDealAnimation = false
    var scheduledDealAnimations: [Timer]?
    
    override func awakeFromNib() {
        animator.delegate = self
    }
    
    func makeButtons(byAmount numberOfButtons: Int) -> [CardViewButton] { return [] }
    
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
           // dealCardsWithAnimation()
        }
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
    
    func resetContainer(){
        cards = []
        grid.cellCount = 0
        for subview in subviews {
            subview.removeFromSuperview()
        }
        setNeedsLayout()
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
    
   
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if grid.frame != centeredRect {
            updateViewsFrames()
        }
    }
//        //the number of cells in the grid will be dependent on the cards
//        for (i, card) in cards.enumerated() {
//            if let frame = grid[i] {
//                card.frame = frame
//                card.layer.cornerRadius = 10
//                card.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
//                card.layer.borderWidth = 0.5
//            }
//        }
    
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
