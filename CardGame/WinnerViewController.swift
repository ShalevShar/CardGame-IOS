//
//  ViewController.swift
//  CardGame
//
//  Created by Shalev on 25/06/2024.
//
import Foundation
import UIKit

class WinnerViewController: UIViewController{
    
    @IBOutlet weak var winner_is_LBL: UILabel!
    @IBOutlet weak var score_LBL: UILabel!
    @IBOutlet weak var winner_name_LBL: UILabel!
    
    var winnerName: String?
    var winnerScore: Int?
    
    override func viewDidLoad() {
            super.viewDidLoad()
               if let winnerName = winnerName, let winnerScore = winnerScore {
                   winner_name_LBL.text = winnerName
                   score_LBL.text = "SCORE: \(winnerScore)"
               }
        }

    @IBAction func toMainAction(_ sender: Any) {
        //Goes to StartViewController
        self.navigationController?.popToRootViewController(animated: true)
    }
}
