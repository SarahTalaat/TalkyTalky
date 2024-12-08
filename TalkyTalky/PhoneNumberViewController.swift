//
//  SignUp.swift
//  TalkyTalky
//
//  Created by Sara Talat on 08/12/2024.
//

import UIKit

class PhoneNumberViewController: UIViewController {
    @IBOutlet weak var phoneNumberTextField: UITextField!

    @IBAction func sendOTPButtonTapped(_ sender: UIButton) {
        guard let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty else {
            print("Phone number is required.")
            return
        }

        PhoneAuthManager.shared.signInWithPhoneNumber(phoneNumber: phoneNumber) { success, verificationID , error in
            if success {
                print("Verification ID: \(verificationID ?? "None")")
                // Navigate to OTP Screen
                let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with the actual storyboard name
                if let otpVC = storyboard.instantiateViewController(withIdentifier: "OTPViewController") as? OTPViewController {
                    self.navigationController?.pushViewController(otpVC, animated: true)
                    print("OTP VC should be PUSHED")
                } else {
                    print("Failed to instantiate OTPViewController.")
                }

            } else {
                print("Failed to send OTP.")
                if let error = error {
                    print("Error Description: \(error.localizedDescription)")
                    print("Error Code: \((error as NSError).code)")
                    print("Error Domain: \((error as NSError).domain)")
                }
            }
        }
    }
}
