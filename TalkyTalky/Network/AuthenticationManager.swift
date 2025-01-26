//
//  Aut.swift
//  TalkyTalky
//
//  Created by Sara Talat on 26/01/2025.
//

import FirebaseAuth

class AuthenticationManager {
    
    // MARK: - Singleton Instance
    static let shared = AuthenticationManager()
    
    private init() {}
    
    // MARK: - Send OTP
    func sendOTP(phoneNumber: String, completion: @escaping (Result<String, Error>) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let verificationID = verificationID else {
                completion(.failure(NSError(domain: "Verification ID not found", code: 500, userInfo: nil)))
                return
            }
            // Save the verification ID to UserDefaults for later use
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            completion(.success(verificationID))
        }
    }
    
    // MARK: - Verify OTP
    func verifyOTP(otp: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {
            completion(.failure(NSError(domain: "Verification ID missing", code: 500, userInfo: nil)))
            return
        }

        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: otp)
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            // Extract the userID from authResult
            if let userID = authResult?.user.uid {
                completion(.success(userID)) // Return the userID
            } else {
                completion(.failure(NSError(domain: "User ID not found", code: 500, userInfo: nil)))
            }
        }
    }

    
    // MARK: - Log Out
    func logout(completion: @escaping (Result<Bool, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(true))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    // MARK: - Get Current User
    func getCurrentUserID() -> String? {
           return Auth.auth().currentUser?.uid
    }
}
