//
//  Chat.swift
//  TalkyTalky
//
//  Created by Sara Talat on 24/01/2025.
//

import Foundation

struct Chat: Codable {
    let id: String
    let participants: [String] // List of user IDs
    let lastMessage: String
    let lastMessageTimestamp: Date
    let isGroupChat: Bool
    let groupName: String? // For group chats
    let groupImageUrl: String? // For group chats
}

