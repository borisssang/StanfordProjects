//  ViewController.swift
//  Concentration
//
//  Coding as done by Instructor CS193P Michel Deiman on 11/11/2017.
//  Copyright © 2017 Michel Deiman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
	
	var numberOfPairsOfCards: Int {
		return (cardButtons.count + 1) / 2
	}
    
    @IBAction func newGame() {
        emojiChoices = game.restartGame()
        updateViewFromModel()
        emoji = [:]
    }
    
	@IBOutlet private weak var flipCountLabel: UILabel! {
		didSet {
			game.flipCount = 0
		}
	}
	
    @IBOutlet private weak var scoreLabel: UILabel!
    {
        didSet{
            game.score = 0
        }
    }
    @IBOutlet private var cardButtons: [UIButton]!{
        didSet{
            emojiChoices = game.randomTheme()
        }
    }
	
	
	@IBAction private func touchCard(_ sender: UIButton) {
		if let cardNumber = cardButtons.index(of: sender) {
			game.chooseCard(at: cardNumber)
			updateViewFromModel()
		} else {
			print("choosen card was not in cardButtons")
		}
	}
	
	private func updateViewFromModel() {
        flipCountLabel.text = "Flips: \(game.flipCount)"
        scoreLabel.text = "Score: \(game.score)"
		for index in cardButtons.indices {
			let button = cardButtons[index]
			let card = game.cards[index]
			if card.isFaceUp {
				button.setTitle(emoji(for: card), for: UIControlState.normal)
				button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
			} else {
				button.setTitle("", for: UIControlState.normal)
				button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
			}
		}
    
	}
	
	private var emojiChoices = "🦇😱🙀😈🎃👻🍭🍬🍎"
    
	private var emoji = [Card: String]()
	
	private func emoji(for card: Card) -> String {
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














