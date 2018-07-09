//
//  ViewContainer.swift
//  Lecture 4 - Concentration
//
//  Created by Boris Angelov on 6.07.18.
//  Copyright © 2018 Michel Deiman. All rights reserved.
//

import UIKit

class ViewContainer: UIView {
    
    var cards = [CardViewButton]()
    var grid = Grid(layout: Grid.Layout.aspectRatio(3/2))
    
    func addCards(numberOfCards: Int){
        guard cards.count < 81 else {return}
        
        for _ in 0..<numberOfCards{
            cards.append(CardViewButton())
        }
        
        for card in cards {
            addSubview(card)
        }
        
        grid.cellCount = cards.count
        setNeedsLayout()
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
        grid.frame = centeredRect
        
        //the number of cells in the grid will be dependent on the cards
        for (i, card) in cards.enumerated() {
            if let frame = grid[i] {
                card.frame = frame
                card.layer.cornerRadius = 10
                card.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                card.layer.borderWidth = 0.5
            }
        }
    }
    
}
