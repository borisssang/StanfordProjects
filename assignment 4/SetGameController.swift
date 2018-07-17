//
//  ViewController.swift
//  setGame
//
//  Created by Boris Angelov on 2.07.18.
//  Copyright © 2018 Boris Angelov. All rights reserved.
//
import UIKit

class SetGameController: UIViewController, SetGameDelegate, CardsContainerViewDelegate {
    
    @IBInspectable @IBOutlet weak var matchedDeckPlaceholderCard: SetCardButton!
    @IBInspectable @IBOutlet weak var deckPlaceholderCard: SetCardButton!
    
    private lazy var game = setGame()
    private var isDealingEnabled = true
    @IBOutlet weak var containerView: SetViewContainer!{
        didSet{
            let didSwipe = UISwipeGestureRecognizer(target: self, action: #selector(dealCards))
            didSwipe.direction = UISwipeGestureRecognizerDirection.down
            containerView.addGestureRecognizer(didSwipe)
            containerView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        game.delegate = self
        game.dealCards(numberOfCards: 12)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !game.playingCards.isEmpty, containerView.cards.isEmpty {
            containerView.addCards(byAmount: 12, animated: true)
            enableButtonAction()
        }
        deckPlaceholderCard.layer.cornerRadius = 10
        deckPlaceholderCard.layer.borderColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        deckPlaceholderCard.layer.borderWidth = 0.5
      //  matchedDeckPlaceholderCard.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        matchedDeckPlaceholderCard.layer.cornerRadius = 10
        matchedDeckPlaceholderCard.layer.borderColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        matchedDeckPlaceholderCard.layer.borderWidth = 0.5
        updateViewFromModel()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let translatedDealOrigin = view.convert(deckPlaceholderCard.frame.origin,
                                                to: containerView)
        let translatedDealFrame = CGRect(origin: translatedDealOrigin,
                                         size: deckPlaceholderCard.frame.size)
        containerView.dealingFromFrame = translatedDealFrame
        
        let translatedDiscardOrigin = view.convert(matchedDeckPlaceholderCard.frame.origin,
                                                   to: containerView)
        let translatedDiscardFrame = CGRect(origin: translatedDiscardOrigin,
                                            size: matchedDeckPlaceholderCard.frame.size)
        containerView.discardToFrame = translatedDiscardFrame
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
 
        guard containerView != nil else { return }
        
        coordinator.animate(alongsideTransition: { _ in
            self.containerView.prepareForRotation()
        }) { _ in
            self.containerView.updateViewsFrames(withAnimation: true) {
                for button in self.containerView.cards {
                    if !button.isFaceUp {
                        button.turnFaceUp(animated: true)
                    }
                }
            }
        }
    }
    
    private func enableButtonAction() {
        for card in containerView.cards {
            card.addTarget(self, action: #selector(didTapCard(_:)), for: .touchUpInside)
        }
    }
    
    @objc func didTapCard(_ sender: UIButton) {
        let indexOfCard = containerView.cards.index(of: sender as! SetCardButton)!
        game.selectCard(at: indexOfCard)

        updateViewFromModel()
    }
    
    //     append three cards //or as much as there is space for
    @IBAction func dealCards() {
        guard !game.allCards.isEmpty else { return }
        guard !containerView.isPerformingDealAnimation else { return }
        
        if game.matchingCards.count > 0 {
            game.replaceMatchedCards()
        }
        
        game.dealCards(numberOfCards: 3)
        containerView.addCards(animated: true)
        enableButtonAction()
        
        updateViewFromModel()
        updateDeckAppearance()
    }
    
    @IBAction func restartGame() {
        guard !containerView.isPerformingDealAnimation else { return }
        containerView.clearCardContainer(withAnimation: true)
        game.restartGame()
        game.dealCards(numberOfCards: 12)
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBAction func userDidRotate(_ sender: UIRotationGestureRecognizer) {
        game.shufflePlayingCards()
        updateViewFromModel()
    }
    
    private func updateDeckAppearance() {
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.1,
            delay: 0.3,
            options: .curveEaseIn,
            animations: {
                self.matchedDeckPlaceholderCard.alpha = self.game.matched ? 1 : 0
                self.deckPlaceholderCard.alpha = self.game.allCards.isEmpty ? 0 : 1
        }
        )
    }
    
    //iterate through the cards
    //get the current card and switch on its states
    //put the states of the buttons accordingly
    private func updateViewFromModel() {
        
        var buttons: [SetCardButton]!
        
        if containerView.cards.count > game.playingCards.count,
            game.allCards.isEmpty {
            buttons = containerView.cards.filter { $0.alpha == 1 } as! [SetCardButton]
        } else {
            buttons = containerView.cards as! [SetCardButton]
        }
        
        scoreLabel?.text = "Sets: \(game.score)"
        for (index, currentCardButton) in buttons.enumerated()  {
            let card = game.playingCards[index]
            
            currentCardButton.numberOfSymbols = card.cardNumber.rawValue + 1
            
            switch card.cardColor {
            case .red:
                currentCardButton.color = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            case .green:
                currentCardButton.color = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            case .purple:
                currentCardButton.color = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
            }
            
            switch card.cardSymbol{
            case .diamond:
                currentCardButton.symbol = "diamond"
            case .squiggle:
                currentCardButton.symbol = "squiggle"
            case .oval:
                currentCardButton.symbol = "oval"
            }
            
            switch card.cardStriping{
            case .solid:
                currentCardButton.striping = "solid"
            case .striped:
                currentCardButton.striping = "striped"
            case .unfilled:
                currentCardButton.striping = "unfilled"
            }
            
            if game.selectedCards.contains(card) || game.matchingCards.contains(card){
                currentCardButton.layer.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            } else {
                currentCardButton.layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
        }
    }

    
    func selectedCardsDidMatch(_ cards: [Card]) {
        scoreLabel.text = "Sets: \(game.score)"
        
        let matchedCardButtons = cards.map({card -> SetCardButton in
            let cardIndex = game.playingCards.index(of: card)!
            return self.containerView.cards[cardIndex] as! SetCardButton
        })
        
        // The replace will happen, if the deck is empty, cards will be
        // removed and the buttons will be out of sync.
        if game.allCards.isEmpty {
            self.containerView.isUserInteractionEnabled = false
        }
        containerView.animateCardsOut(matchedCardButtons)
    }
    
    func cardsRemovalDidFinish() {
        updateDeckAppearance()
        
        guard !containerView.cards.isEmpty else {
            containerView.addCards(byAmount: 12, animated: true)
            enableButtonAction()
            updateViewFromModel()
            scoreLabel.text = "Matches: 0"
            return
        }
        
        guard containerView.buttonsToPosition.count == game.playingCards.count else {
            containerView.removeInactiveCardButtons() {
                self.updateViewFromModel()
                self.containerView.isUserInteractionEnabled = true
            }
            return
        }
        
        containerView.dealCardsWithAnimation()
    }
    func cardsDealDidFinish() {}
    
    func didFinishDealingCard(_ button: CardViewButton) {
button.turnFaceUp(animated: true)    }
    
}
