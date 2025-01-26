//
//  Group.swift
//  TalkyTalky
//
//  Created by Sara Talat on 24/01/2025.
//

import Foundation

struct Group: Codable {
    let id: String
    let name: String
    let adminId: String
    let members: [String] // List of user IDs
    let groupImageUrl: String?
    let createdAt: Date
}


