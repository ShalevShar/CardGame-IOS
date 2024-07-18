//
//  ViewController.swift
//  CardGame
//
//  Created by Shalev on 25/06/2024.
//

import UIKit

class ViewController: UIViewController, GameManagerDelegate{

    @IBOutlet weak var cardDeck_IMG_player1: UIImageView!
    @IBOutlet weak var cardDeck_IMG_player2: UIImageView!
    @IBOutlet weak var score_LBL_player1: UILabel!
    @IBOutlet weak var score_LBL_player2: UILabel!
    
    @IBOutlet weak var star1_IMG_player1: UIImageView!
    @IBOutlet weak var star2_IMG_player1: UIImageView!
    @IBOutlet weak var star3_IMG_player1: UIImageView!
    
    @IBOutlet weak var star1_IMG_player2: UIImageView!
    @IBOutlet weak var star2_IMG_player2: UIImageView!
    @IBOutlet weak var star3_IMG_player2: UIImageView!
    
    @IBOutlet weak var pauseResume_BTN: UIButton!
    
    @IBOutlet weak var name_LBL_player1: UILabel!
    
    @IBOutlet weak var name_LBL_player2: UILabel!
    
    private var gameManager: GameManager!
    private var isPaused = false
    
    override func viewDidLoad() {
            super.viewDidLoad()
            gameManager = GameManager(viewController: self)
            gameManager.delegate = self
            gameManager.startGame()
    
           let player1Name = UserDefaults.standard.string(forKey: "player1Name") ?? "Player 1"
           let player2Name = UserDefaults.standard.string(forKey: "player2Name") ?? "Player 2"
           
           name_LBL_player1.text = player1Name
           name_LBL_player2.text = player2Name
        }
    
    
    @IBAction func pauseResumeAction(_ sender: Any) {
          if gameManager.getGameStatus() == false {
              isPaused.toggle()
              if isPaused {
                  gameManager.pauseGame()
                  pauseResume_BTN.setImage(UIImage(systemName: "play"), for: .normal)
              } else {
                  gameManager.startGame()
                  pauseResume_BTN.setImage(UIImage(systemName: "pause"), for: .normal)
              }
          } else {
              print("gameOver...")
              gameManager.endGame()
          }
      }

    func updatePlayerNames(player1Name: String?, player2Name: String?) {
            name_LBL_player1.text = player1Name
            name_LBL_player2.text = player2Name
        }
        
        func updateScores() {
            score_LBL_player1.text = "\(gameManager.scorePlayer1)"
            score_LBL_player2.text = "\(gameManager.scorePlayer2)"
        }
        
        func gameDidEnd() {
            print("ViewController: gameDidEnd called.")
            performSegue(withIdentifier: "WinnerViewController", sender: self)
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "WinnerViewController" {
                print("ViewController: Preparing for segue to WinnerViewController...")
                let winnerVC = segue.destination as! WinnerViewController
                
                let player1Score = gameManager.scorePlayer1
                let player2Score = gameManager.scorePlayer2
                
                print("ViewController: Player 1 Score: \(player1Score)")
                print("ViewController: Player 2 Score: \(player2Score)")
                
                if player1Score > player2Score {
                    winnerVC.winnerName = name_LBL_player1.text
                    winnerVC.winnerScore = player1Score
                } else if player1Score != player2Score {
                    winnerVC.winnerName = name_LBL_player2.text
                    winnerVC.winnerScore = player2Score
                } else {
                    winnerVC.winnerName = "Both of you! It's a tie"
                    winnerVC.winnerScore = player2Score
                }
                
                print("ViewController: Winner Name: \(winnerVC.winnerName ?? "nil")")
                print("ViewController: Winner Score: \(winnerVC.winnerScore ?? -1)")
            }
        }
        
        func endGame() {
            print("ViewController: endGame called.")
            performSegue(withIdentifier: "WinnerViewController", sender: self)
        }
    }
