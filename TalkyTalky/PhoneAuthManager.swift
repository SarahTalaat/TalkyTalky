//
//  PhoneAuthManager.swift
//  TalkyTalky
//
//  Created by Sara Talat on 08/12/2024.
//

import Foundation
import FirebaseAuth

class PhoneAuthManager {
    static let shared = PhoneAuthManager()

    private init() {}

    // Function to start phone number verification
    func signInWithPhoneNumber(phoneNumber: String, completion: @escaping (Bool, String?, Error?) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(false, nil, error)
            } else {
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                completion(true, verificationID, nil)
            }
        }
    }

    // Function to verify OTP
    func verifyOTP(verificationCode: String, completion: @escaping (Bool, String?) -> Void) {
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {
            completion(false, "Verification ID not found.")
            return
        }

        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
        Auth.auth().signIn(with: credential) { result, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(false, error.localizedDescription)
            } else {
                completion(true, result?.user.uid)
            }
        }
    }
}
