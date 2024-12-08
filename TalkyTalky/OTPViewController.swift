//
//  SignIn.swift
//  TalkyTalky
//
//  Created by Sara Talat on 08/12/2024.
//
import UIKit

class OTPViewController: UIViewController {
    @IBOutlet weak var otpTextField: UITextField!

    @IBAction func verifyOTPButtonTapped(_ sender: UIButton) {
        guard let otpCode = otpTextField.text, !otpCode.isEmpty else {
            print("OTP is required.")
            return
        }

        PhoneAuthManager.shared.verifyOTP(verificationCode: otpCode) { success, userID in
            if success {
                print("User signed in with UID: \(userID ?? "None")")
                // Navigate to Home Screen
//                let homeVC = HomeViewController() // Instantiate properly
//                self.navigationController?.pushViewController(homeVC, animated: true)
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with the actual storyboard name
                if let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
                    self.navigationController?.pushViewController(homeVC, animated: true)
                    
                }
            } else {
                print("Failed to verify OTP.")
            }
        }
    }
}
