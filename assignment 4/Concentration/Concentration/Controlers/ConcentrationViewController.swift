//  ViewController.swift
//  Concentration
//
//  Coding as done by Instructor CS193P Michel Deiman on 11/11/2017.
//  Copyright © 2017 Michel Deiman. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {
	
//    override func viewDidLoad() {
//        updateViewFromModel()
//    }
    
	private lazy var ConcentrationGame = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
	
	var numberOfPairsOfCards: Int {
		return (cardButtons.count + 1) / 2
	}
    
    @IBAction func newGame() {
        emojiChoices = ConcentrationGame.restartGame()
        updateViewFromModel()
        emoji = [:]
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
    @IBOutlet private var cardButtons: [UIButton]!{
        didSet{
            if theme == ""{
                emojiChoices = ConcentrationGame.randomTheme()}
        }
    }
	
	
	@IBAction private func touchCard(_ sender: UIButton) {
		if let cardNumber = cardButtons.index(of: sender) {
			ConcentrationGame.chooseCard(at: cardNumber)
			updateViewFromModel()
		} else {
			print("choosen card was not in cardButtons")
		}
	}
	
	private func updateViewFromModel() {
        if cardButtons != nil {
        flipCountLabel.text = "Flips: \(ConcentrationGame.flipCount)"
        scoreLabel.text = "Score: \(ConcentrationGame.score)"
		for index in cardButtons.indices {
			let button = cardButtons[index]
			let card = ConcentrationGame.cards[index]
			if card.isFaceUp {
				button.setTitle(emoji(for: card), for: UIControlState.normal)
				button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
			} else {
				button.setTitle("", for: UIControlState.normal)
				button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
			}
		}
        }
	}
    
    var theme: String? {
        didSet {
            emojiChoices = theme ?? ""
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














