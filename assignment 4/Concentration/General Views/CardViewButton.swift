import UIKit

@IBDesignable
class CardViewButton: UIButton {
    
    var isActive: Bool = true {
        didSet {
            if isActive {
                alpha = 1
            } else {
                alpha = 0
            }
        }
    }
    
    @IBInspectable override var isSelected: Bool  {
        didSet {
            if isSelected {
                layer.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1).cgColor
            } else {
                layer.backgroundColor = UIColor.white.cgColor
            }
        }
    }
    
    @IBInspectable var isFaceUp: Bool = true {
        didSet{
            if !isFaceUp {
                layer.backgroundColor = UIColor.white.cgColor
            }
            setNeedsDisplay()
        }
    }
    
    func turnFaceUp(animated: Bool = true) {
        if animated {
            UIView.transition(with: self,
                              duration: 0.3,
                              options: .transitionFlipFromLeft,
                              animations: {
                                self.isFaceUp = true
            })
        } else {
            self.isFaceUp = true
        }
    }
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = 10
        layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        layer.borderWidth = 0.5
        
        if isFaceUp {
            drawFront()
        } else {
            drawBack()
        }
    }
    
    func drawFront() {}
    
    func drawBack() {}
    
    func flipCard(animated: Bool = false, completion: Optional<(CardViewButton) -> ()> = nil) {
        if animated {
            UIView.transition(with: self,
                              duration: 0.3,
                              options: .transitionFlipFromLeft,
                              animations: {
                                self.isFaceUp = !self.isFaceUp
            }) { completed in
                if let completion = completion {
                    completion(self)
                }
            }
        } else {
            self.isFaceUp = !self.isFaceUp
        }
    }
}

