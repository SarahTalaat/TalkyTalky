//
//  AuthenticationViewModel.swift
//  TalkyTalky
//
//  Created by Sara Talat on 26/01/2025.
//
import Foundation
import Foundation
import FirebaseAuth

class AuthenticationViewModel {

    // MARK: - Properties
    var phoneNumber: String?
    var verificationCode: String?
    
    private let authenticationManager = AuthenticationManager.shared
    
    // MARK: - Outputs (bindable variables to update the view)
    var onPhoneNumberVerificationSuccess: ((String) -> Void)?
    var onPhoneNumberVerificationFailure: ((String) -> Void)?
    
    var onOTPVerificationSuccess: ((String) -> Void)?
    var onOTPVerificationFailure: ((String) -> Void)?

    // MARK: - Send OTP
    func sendOTP() {
        guard let phoneNumber = phoneNumber else { return }
        
        authenticationManager.sendOTP(phoneNumber: phoneNumber) { result in
            switch result {
            case .success(let verificationID):
                self.onPhoneNumberVerificationSuccess?(verificationID)
            case .failure(let error):
                self.onPhoneNumberVerificationFailure?(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Verify OTP
    func verifyOTP() {
        guard let otp = verificationCode else { return }
        
        authenticationManager.verifyOTP(otp: otp) { result in
            switch result {
            case .success(let userID):
                self.onOTPVerificationSuccess?(userID)
            case .failure(let error):
                self.onOTPVerificationFailure?(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Get Current User ID
    func getCurrentUserID() -> String? {
        return authenticationManager.getCurrentUserID()
    }
}
