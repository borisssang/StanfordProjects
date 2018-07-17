//  ViewController.swift
//  Concentration
//
//  Coding as done by Instructor CS193P Michel Deiman on 11/11/2017.
//  Copyright © 2017 Michel Deiman. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController, ConcentrationDelegate, CardsContainerViewDelegate {
    
    public var themes = [
        "Happy":"😊😂🤣😘😍😜😆😇🙂😁😎🤪😹😻",
        "Sad":"🙃😞😔😟😕😖😭😤😠🙁😨😪🤧😒",
        "Scary":"😈👹👻💩👽👾🤖🧟‍♂️🎅👳‍♂️🧠👁👣👺"
    ]
    
    func didMatchCards(withIndices indices: [Int]) {
        let matchedCardButtons: [CardViewButton] = indices.map {
            return self.containerView.cards[$0]
        }
        
        for button in matchedCardButtons {
            button.isActive = false
        }
        cardsRemovalDidFinish()
        self.containerView.isUserInteractionEnabled = false
    }
    
    func cardsRemovalDidFinish() {
        if containerView.cards.filter({ $0.isActive }).isEmpty {
            containerView.clearCardContainer()
            containerView.addCards(byAmount: 16, animated: true)
            assignTargets()
            updateViewFromModel()
        } else {
            containerView.removeInactiveCardButtons {
                self.containerView.isUserInteractionEnabled = true
            }
        }
    }
    
    func cardsDealDidFinish(){
        containerView.isPerformingDealAnimation = false
    }
    func didFinishDealingCard(_ button: CardViewButton) {    }
    
    
    @IBOutlet weak var containerView: ConcentrationViewContainer!{
        didSet{
            containerView.delegate = self
        }
    }
    
    private lazy var ConcentrationGame = Concentration(numberOfPairsOfCards: 8)
    
    override func viewDidLoad() {
        ConcentrationGame.delegate = self
        containerView.addCards(byAmount: 16, animated: true)
        assignTargets()
        updateViewFromModel()
    }
    
    private func assignTargets() {
        for button in containerView.cards {
            button.addTarget(self,
                             action: #selector(didTapCard(_:)),
                             for: .touchUpInside)
        }
    }
    
    @IBAction func newGame() {
        if containerView.isPerformingDealAnimation == false {
        for button in containerView.cards {
            button.isActive = false
        }
        theme = ConcentrationGame.restartGame()
        cardsRemovalDidFinish()
        ConcentrationGame.score = 0
        updateViewFromModel()
        }
    }
    
	@IBOutlet private weak var flipCountLabel: UILabel! {
		didSet {
			ConcentrationGame.flipCount = 0
		}
	}
	
    @IBOutlet private weak var scoreLabel: UILabel!
    {
        didSet{
            ConcentrationGame.score = 0
        }
    }
    
    private func updateViewFromModel() {
        if containerView != nil {
            flipCountLabel.text = "Flips: \(ConcentrationGame.flipCount)"
            scoreLabel.text = "Score: \(ConcentrationGame.score)"
            
            for (index, cardButton) in containerView.cards.enumerated()  {
                guard cardButton.isActive else { continue }
                guard ConcentrationGame.cards.indices.contains(index) else { continue }
                
                let card = ConcentrationGame.cards[index]
                
                if let button = cardButton as? ConcentrationButton {
                    button.buttonText = emoji(for: card)
                if !card.isFaceUp && button.isFaceUp && !card.isMatched {
                    button.flipCard(animated: true)
                    }
            }
        }
    }
    }
    var theme: String? {
        didSet {
            emojiChoices = themes[theme!] ?? ""
            emoji = [:]
            updateViewFromModel()
        }
    }
    
    private var emojiChoices = "🦇😱🙀😈🎃👻🍭🍬🍎"
    
    private var emoji = [ConcentrationCard: String]()
    
    private func emoji(for card: ConcentrationCard) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            let stringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4Random)
            emoji[card] = String(emojiChoices.remove(at: stringIndex))
        }
        return emoji[card] ?? "?"
    }
    
    @objc func didTapCard(_ sender: ConcentrationButton) {
        guard let index = containerView.cards.index(of: sender) else { return }
        
        ConcentrationGame.flipCard(at: index)
        guard  containerView.isPerformingDealAnimation == false else { return }
        sender.flipCard(animated: true)
        
        updateViewFromModel()
    }

    private var cardsAndEmojisMap = [Card : String]()
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // In case the controller is still being presented and the
        // views haven't been instantiated.
        guard containerView != nil else { return }
        
        coordinator.animate(alongsideTransition: { _ in
            self.containerView.prepareForRotation()
        }) { _ in
            self.containerView.updateViewsFrames(withAnimation: true)
        }
    }
    
}

extension Int {
	var arc4Random: Int {
		switch self {
		case 1...Int.max:
			return Int(arc4random_uniform(UInt32(self)))
		case -Int.max..<0:
			return Int(arc4random_uniform(UInt32(self)))
		default:
			return 0
		}
	}
}














