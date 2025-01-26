//
//  User.swift
//  TalkyTalky
//
//  Created by Sara Talat on 24/01/2025.
//

import Foundation

struct User: Codable {
    let id: String
    let name: String
    let phoneNumber: String
    let profileImageUrl: String?
    let status: String
    let isOnline: Bool
    let lastSeen: Date?
}

