//
//  AuthenticationViewController.swift
//  TalkyTalky
//
//  Created by Sara Talat on 26/01/2025.
//
import UIKit

class AuthenticationViewController: UIViewController {

    // MARK: - Properties
    private let viewModel = AuthenticationViewModel()

    // MARK: - UI Elements

    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var otpTextField: UITextField!

//    @IBOutlet weak var sendOTPButton: UIButton!
//    @IBOutlet weak var verifyOTPButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Bind ViewModel outputs to UI
        bindViewModel()
    }
    
    // MARK: - Binding ViewModel
    private func bindViewModel() {
        // Phone number verification success
        viewModel.onPhoneNumberVerificationSuccess = { verificationID in
            // Update UI: Show verification code screen
            print("Verification ID: \(verificationID)")
        }
        
        // Phone number verification failure
        viewModel.onPhoneNumberVerificationFailure = { error in
            self.showErrorAlert(message: error)
        }
        
        // OTP verification success
        viewModel.onOTPVerificationSuccess = { userID in
            // Navigate to the next screen
            print("Logged in user with ID: \(userID)")
        }
        
        // OTP verification failure
        viewModel.onOTPVerificationFailure = { error in
            self.showErrorAlert(message: error)
        }
        
    }
    
    // MARK: - Actions
    @IBAction func sendOTPButtonTapped(_ sender: UIButton) {
        viewModel.phoneNumber = phoneNumberTextField.text
        viewModel.sendOTP()
    }


    @IBAction func verifyOTPButtonTapped(_ sender: UIButton) {
        viewModel.verificationCode = otpTextField.text
        viewModel.verifyOTP()
    }
    


    // MARK: - Helper Methods
    private func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}
