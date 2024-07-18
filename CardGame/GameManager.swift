import Foundation
import UIKit

protocol GameManagerDelegate: AnyObject {
    func gameDidEnd()
}
class GameManager {
    private let viewController: ViewController
    private var deck: [UIImage]
    private var maxCards: Int
    private var stars: [UIImageView]
    private(set) var scorePlayer1: Int
    private(set) var scorePlayer2: Int
    private(set) var winsPlayer1: Int
    private(set) var winsPlayer2: Int
    private var currentRound: Int
    private let totalRounds: Int = 3
    private var isGameOver = false
    private var ticker: Ticker?
    private static var interval: Double = 2.0
    private var isBackVisible: Bool = true
    weak var delegate: GameManagerDelegate?
    init(viewController: ViewController) {
        self.viewController = viewController
        self.deck = [#imageLiteral(resourceName: "2C.png"),#imageLiteral(resourceName: "2H.png"),#imageLiteral(resourceName: "2S.png"),#imageLiteral(resourceName: "3C.png"),#imageLiteral(resourceName: "3D.png"),#imageLiteral(resourceName: "3H.png"),#imageLiteral(resourceName: "3S.png"),#imageLiteral(resourceName: "4C.png"),#imageLiteral(resourceName: "4D.png"),#imageLiteral(resourceName: "4H.png"),#imageLiteral(resourceName: "4S.png"),#imageLiteral(resourceName: "5C.png"),#imageLiteral(resourceName: "5D.png"),#imageLiteral(resourceName: "5H.png"),#imageLiteral(resourceName: "5S.png"),#imageLiteral(resourceName: "6C.png"),#imageLiteral(resourceName: "6D.png"),#imageLiteral(resourceName: "6H.png"),#imageLiteral(resourceName: "6S.png"),#imageLiteral(resourceName: "7C.png"),#imageLiteral(resourceName: "7D.png"),#imageLiteral(resourceName: "7H.png"),#imageLiteral(resourceName: "7S.png"),#imageLiteral(resourceName: "8C.png"),#imageLiteral(resourceName: "8D.png"),#imageLiteral(resourceName: "8H.png"),#imageLiteral(resourceName: "8S.png"),#imageLiteral(resourceName: "9C.png"),#imageLiteral(resourceName: "9D.png"),#imageLiteral(resourceName: "9H.png"),#imageLiteral(resourceName: "9S.png"),#imageLiteral(resourceName: "10C.png"),#imageLiteral(resourceName: "10D.png"),#imageLiteral(resourceName: "10H.png"),#imageLiteral(resourceName: "10S.png"),#imageLiteral(resourceName: "AC.png"),#imageLiteral(resourceName: "AD.png"),#imageLiteral(resourceName: "AH.png"),#imageLiteral(resourceName: "AS.png"),#imageLiteral(resourceName: "JC.png"),#imageLiteral(resourceName: "JD.png"),#imageLiteral(resourceName: "JH.png"),#imageLiteral(resourceName: "JS.png"),#imageLiteral(resourceName: "KC.png"),#imageLiteral(resourceName: "KD.png"),#imageLiteral(resourceName: "KH.png"),#imageLiteral(resourceName: "KS.png"),#imageLiteral(resourceName: "QC.png"),#imageLiteral(resourceName: "QD.png"),#imageLiteral(resourceName: "QH.png"),#imageLiteral(resourceName: "QS.png")]
        self.stars = [viewController.star1_IMG_player1,
                      viewController.star2_IMG_player1,
                      viewController.star3_IMG_player1,
                      viewController.star1_IMG_player2,
                      viewController.star2_IMG_player2,
                      viewController.star3_IMG_player2]
        self.maxCards = deck.count
        self.scorePlayer1 = 0
        self.scorePlayer2 = 0
        self.winsPlayer1 = 0
        self.winsPlayer2 = 0
        self.currentRound = 1
        self.hideStars()
        for (_, card) in deck.enumerated() {
            card.accessibilityIdentifier = GameManager.getCardIdentifier(for: card)
        }
        // Initialize the ticker with a callback to getCards
        self.ticker = Ticker(interval: GameManager.interval) { [weak self] in
            if self?.isBackVisible == true {
                self?.getCards()
                GameManager.interval = 2.0
                self?.isBackVisible = false
            } else {
                self?.showBackOfCards()
                GameManager.interval = 3.0
                self?.isBackVisible = true
            }
        }
    }
    func hideStars(){
        for star in self.stars{
            star.isHidden = true
        }
    }
    func initNewDeck(){
        self.deck = [#imageLiteral(resourceName: "2C.png"),#imageLiteral(resourceName: "2H.png"),#imageLiteral(resourceName: "2S.png"),#imageLiteral(resourceName: "3C.png"),#imageLiteral(resourceName: "3D.png"),#imageLiteral(resourceName: "3H.png"),#imageLiteral(resourceName: "3S.png"),#imageLiteral(resourceName: "4C.png"),#imageLiteral(resourceName: "4D.png"),#imageLiteral(resourceName: "4H.png"),#imageLiteral(resourceName: "4S.png"),#imageLiteral(resourceName: "5C.png"),#imageLiteral(resourceName: "5D.png"),#imageLiteral(resourceName: "5H.png"),#imageLiteral(resourceName: "5S.png"),#imageLiteral(resourceName: "6C.png"),#imageLiteral(resourceName: "6D.png"),#imageLiteral(resourceName: "6H.png"),#imageLiteral(resourceName: "6S.png"),#imageLiteral(resourceName: "7C.png"),#imageLiteral(resourceName: "7D.png"),#imageLiteral(resourceName: "7H.png"),#imageLiteral(resourceName: "7S.png"),#imageLiteral(resourceName: "8C.png"),#imageLiteral(resourceName: "8D.png"),#imageLiteral(resourceName: "8H.png"),#imageLiteral(resourceName: "8S.png"),#imageLiteral(resourceName: "9C.png"),#imageLiteral(resourceName: "9D.png"),#imageLiteral(resourceName: "9H.png"),#imageLiteral(resourceName: "9S.png"),#imageLiteral(resourceName: "10C.png"),#imageLiteral(resourceName: "10D.png"),#imageLiteral(resourceName: "10H.png"),#imageLiteral(resourceName: "10S.png"),#imageLiteral(resourceName: "AC.png"),#imageLiteral(resourceName: "AD.png"),#imageLiteral(resourceName: "AH.png"),#imageLiteral(resourceName: "AS.png"),#imageLiteral(resourceName: "JC.png"),#imageLiteral(resourceName: "JD.png"),#imageLiteral(resourceName: "JH.png"),#imageLiteral(resourceName: "JS.png"),#imageLiteral(resourceName: "KC.png"),#imageLiteral(resourceName: "KD.png"),#imageLiteral(resourceName: "KH.png"),#imageLiteral(resourceName: "KS.png"),#imageLiteral(resourceName: "QC.png"),#imageLiteral(resourceName: "QD.png"),#imageLiteral(resourceName: "QH.png"),#imageLiteral(resourceName: "QS.png")]
    }
    static func getCardIdentifier(for card: UIImage) -> String {
            switch card {
            case #imageLiteral(resourceName: "2C.png"): return "2C"
            case #imageLiteral(resourceName: "2H.png"): return "2H"
            case #imageLiteral(resourceName: "2S.png"): return "2S"
            case #imageLiteral(resourceName: "3C.png"): return "3C"
            case #imageLiteral(resourceName: "3D.png"): return "3D"
            case #imageLiteral(resourceName: "3H.png"): return "3H"
            case #imageLiteral(resourceName: "3S.png"): return "3S"
            case #imageLiteral(resourceName: "4C.png"): return "4C"
            case #imageLiteral(resourceName: "4D.png"): return "4D"
            case #imageLiteral(resourceName: "4H.png"): return "4H"
            case #imageLiteral(resourceName: "4S.png"): return "4S"
            case #imageLiteral(resourceName: "5C.png"): return "5C"
            case #imageLiteral(resourceName: "5D.png"): return "5D"
            case #imageLiteral(resourceName: "5H.png"): return "5H"
            case #imageLiteral(resourceName: "5S.png"): return "5S"
            case #imageLiteral(resourceName: "6C.png"): return "6C"
            case #imageLiteral(resourceName: "6D.png"): return "6D"
            case #imageLiteral(resourceName: "6H.png"): return "6H"
            case #imageLiteral(resourceName: "6S.png"): return "6S"
            case #imageLiteral(resourceName: "7C.png"): return "7C"
            case #imageLiteral(resourceName: "7D.png"): return "7D"
            case #imageLiteral(resourceName: "7H.png"): return "7H"
            case #imageLiteral(resourceName: "7S.png"): return "7S"
            case #imageLiteral(resourceName: "8C.png"): return "8C"
            case #imageLiteral(resourceName: "8D.png"): return "8D"
            case #imageLiteral(resourceName: "8H.png"): return "8H"
            case #imageLiteral(resourceName: "8S.png"): return "8S"
            case #imageLiteral(resourceName: "9C.png"): return "9C"
            case #imageLiteral(resourceName: "9D.png"): return "9D"
            case #imageLiteral(resourceName: "9H.png"): return "9H"
            case #imageLiteral(resourceName: "9S.png"): return "9S"
            case #imageLiteral(resourceName: "10C.png"): return "10C"
            case #imageLiteral(resourceName: "10D.png"): return "10D"
            case #imageLiteral(resourceName: "10H.png"): return "10H"
            case #imageLiteral(resourceName: "10S.png"): return "10S"
            case #imageLiteral(resourceName: "AC.png"): return "AC"
            case #imageLiteral(resourceName: "AD.png"): return "AD"
            case #imageLiteral(resourceName: "AH.png"): return "AH"
            case #imageLiteral(resourceName: "AS.png"): return "AS"
            case #imageLiteral(resourceName: "JC.png"): return "JC"
            case #imageLiteral(resourceName: "JD.png"): return "JD"
            case #imageLiteral(resourceName: "JH.png"): return "JH"
            case #imageLiteral(resourceName: "JS.png"): return "JS"
            case #imageLiteral(resourceName: "KC.png"): return "KC"
            case #imageLiteral(resourceName: "KD.png"): return "KD"
            case #imageLiteral(resourceName: "KH.png"): return "KH"
            case #imageLiteral(resourceName: "KS.png"): return "KS"
            case #imageLiteral(resourceName: "QC.png"): return "QC"
            case #imageLiteral(resourceName: "QD.png"): return "QD"
            case #imageLiteral(resourceName: "QH.png"): return "QH"
            case #imageLiteral(resourceName: "QS.png"): return "QS"
            default: return ""
            }
        }
    
    func startGame() {
            ticker?.start()
        }

    func pauseGame() {
            ticker?.stop()
        }
    
        func getCards() {
            guard maxCards >= 2 else {
                print("Not enough cards left in the deck.")
                endRound()
                return
            }
            
            let randPlayer1 = Int.random(in: 0..<maxCards)
            var randPlayer2 = Int.random(in: 0..<maxCards)
            
            // Ensure the second random index is different from the first
            while randPlayer2 == randPlayer1 {
                randPlayer2 = Int.random(in: 0..<maxCards)
            }
            
            let card1 = deck[randPlayer1]
            let card2 = deck[randPlayer2]
            
            viewController.cardDeck_IMG_player1.image = card1
            viewController.cardDeck_IMG_player2.image = card2
            
            // Remove the cards from the deck
            deck.remove(at: max(randPlayer1, randPlayer2)) // Remove the card with the higher index first to avoid index issues
            deck.remove(at: min(randPlayer1, randPlayer2))
            
            // Update the maxCards count
            maxCards -= 2
            // Update the scores based on the card values
            let cardValue1 = getCardValue(card: card1)
            let cardValue2 = getCardValue(card: card2)
            
            if cardValue1 > cardValue2 {
                scorePlayer1 += 1
            } else if cardValue2 > cardValue1 {
                scorePlayer2 += 1
            }
            
            viewController.updateScores()
            
            if maxCards < 2 {
                endRound()
            }
        }
    
        private func showBackOfCards () {
            viewController.cardDeck_IMG_player1.image = #imageLiteral(resourceName: "card_back.png")
            viewController.cardDeck_IMG_player2.image = #imageLiteral(resourceName: "card_back.png")
        }
    
        private func getCardValue(card: UIImage) -> Int {
            guard let cardName = card.accessibilityIdentifier, !cardName.isEmpty else {
                print("Card has no accessibility identifier")
                return 0
            }
            
            let cardRank = String(cardName.dropLast())
            
            switch cardRank {
            case "A":
                return 14
            case "K":
                return 13
            case "Q":
                return 12
            case "J":
                return 11
            default:
                return Int(cardRank) ?? 0
            }
        }

        private func endRound() {
            pauseGame()
           if scorePlayer1 > scorePlayer2 {
               winsPlayer1 += 1
               showStar(player: 1)
           } else if scorePlayer2 > scorePlayer1 {
               winsPlayer2 += 1
               showStar(player: 2)
           }
           
           print("End of Round \(currentRound): Player 1 Wins: \(winsPlayer1), Player 2 Wins: \(winsPlayer2)")
           
           if currentRound == totalRounds {
               ticker?.stop()
               isGameOver = true
               viewController.pauseResume_BTN.setImage(UIImage(systemName: "memories"), for: .normal)
               determineWinner()
           } else {
               currentRound += 1
               initNewDeck()
               resetForNextRound()
           }
       }
    
        private func showStar(player: Int){
            if player == 1 && winsPlayer1 < 3 {
                self.stars[winsPlayer1-1].isHidden = false
            } else if player == 2 && winsPlayer2 < 3 {
                self.stars[(winsPlayer2-1)+3].isHidden = false
            }
        }
       private func resetForNextRound() {
           scorePlayer1 = 0
           scorePlayer2 = 0
           maxCards = deck.count
           
           // Shuffle the deck and reset the card identifiers
           deck.shuffle()
           for card in deck {
               card.accessibilityIdentifier = GameManager.getCardIdentifier(for: card)
           }
           
           viewController.updateScores()
           ticker?.start() // Start the ticker for the next round
       }
       
       private func determineWinner() {
           if winsPlayer1 > winsPlayer2 {
               print("Player 1 wins the game!")
           } else if winsPlayer2 > winsPlayer1 {
               print("Player 2 wins the game!")
           } else {
               print("The game is a tie!")
           }
           endGame()
       }
    
    func getGameStatus() -> Bool {
            return isGameOver
        }
    
    func endGame() {
            // Notify the delegate when the game ends
            delegate?.gameDidEnd()
        }
    func checkGameEnd() {
            // Determine if the game has ended
            let isGameOver = true // replace with actual logic
            if isGameOver {
                endGame()
            }
        }
}
