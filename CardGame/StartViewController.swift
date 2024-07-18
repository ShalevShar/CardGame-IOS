import Foundation
import UIKit
import CoreLocation


class StartViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var error_LBL: UILabel!
    @IBOutlet weak var name_LBL: UILabel!
    var locationManager: CLLocationManager!
    var hasLocationPermission = false
    var hasNameInSystem = false
    
    
    override func viewDidLoad() {
           super.viewDidLoad()
           
           locationManager = CLLocationManager()
           locationManager.delegate = self
           
           nameField.delegate = self // Set delegate for nameField
        
           error_LBL.isHidden = true
        
                if let savedName = UserDefaults.standard.string(forKey: "playerName") {
                    hasNameInSystem = true
                    nameField.isHidden = true
                    showGreeting(for: savedName)
                } else {
                    name_LBL.isHidden = true
                }
           
           // Retrieve and display the saved name if it exists
           if let savedName = UserDefaults.standard.string(forKey: "playerName") {
               nameField.text = savedName
           }
           
           // Request location permission
           locationManager.requestWhenInUseAuthorization()
       }
       
        @IBAction func startGameAction(_ sender: Any) {
            var name: String
            
            if !hasNameInSystem {
                guard let enteredName = nameField.text, !enteredName.isEmpty else {
                    showError(message: "Please enter your name.")
                    return  // Stop here if name is empty
                }
                name = enteredName
            } else {
                // Retrieve the saved name
                name = UserDefaults.standard.string(forKey: "playerName") ?? "Player"
            }
            
            if !hasLocationPermission {
                showError(message: "Please grant location permission.")
                return  // Stop here if location permission is not granted
            }
            
            // Save the name if it's a new entry
            if !hasNameInSystem {
                UserDefaults.standard.set(name, forKey: "playerName")
            }
            
            let latitude = locationManager.location?.coordinate.latitude ?? 0.0
            let thresholdLatitude: CLLocationDegrees = 34.817549168324334
            
            if latitude > thresholdLatitude {
                UserDefaults.standard.set("PC", forKey: "player1Name")
                UserDefaults.standard.set(name, forKey: "player2Name")
            } else {
                UserDefaults.standard.set(name, forKey: "player1Name")
                UserDefaults.standard.set("PC", forKey: "player2Name")
            }
    
            performSegue(withIdentifier: "ViewController", sender: self)
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            showError(message: "Failed to get location. Please try again.")
        }
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            hasLocationPermission = (status == .authorizedWhenInUse || status == .authorizedAlways)
        }
        
        func showError(message: String) {
            error_LBL.text = message
            error_LBL.isHidden = false
        }
        

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // Handle text changes if needed
            return true
        }
       private func showGreeting(for name: String) {
           name_LBL.text = "Hi \(name)!"
       }
    }
