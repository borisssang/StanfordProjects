import Foundation

struct Card {
    let cardNumber: Number
    let cardSymbol: Symbol
    let cardStriping: Striping
    let cardColor: Color
    var identifier = 0
    
    enum Number: Int{
        case one
        case two
        case three
        static let allValues = [one,two,three]
    }
    enum Symbol: String  {
        case diamond
        case squiggle
        case oval
        static let allValues = [diamond, squiggle, oval]
    }
    enum Striping: String{
        case solid
        case striped
        case unfilled
        static let allValues = [solid, striped, unfilled]
    }
    enum Color : String{
        
        case red
        case green
        case purple
        static let allValues = [red, green, purple]
    }
    
    //append all card variations
    static func fillDeck() -> [Card]{
        var deck = [Card]()
        for number in Number.allValues{
            for symbol in Symbol.allValues {
                for shading in Striping.allValues {
                    for color in Color.allValues{
                        let newIdentifier = Card.getUniqueIdentifier()
                        let newCard = Card(cardNumber: number, cardSymbol: symbol, cardStriping: shading, cardColor: color, identifier: newIdentifier)
                        deck.append(newCard)
                    }
                }
            }
        }
        //shuffle the cards
        for i in 0 ..< deck.count {
            let j = Int(arc4random_uniform(UInt32(deck.count)))
            let temp = deck[i]
            deck[i] = deck[j]
            deck[j] = temp
        }
        return deck
    }
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
}

extension Card: Hashable {
    
    var hashValue: Int {
        return identifier
    }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

