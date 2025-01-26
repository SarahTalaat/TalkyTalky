//
//  TypingIndicator.swift
//  TalkyTalky
//
//  Created by Sara Talat on 24/01/2025.
//

import Foundation

struct TypingIndicator: Codable {
    let chatId: String
    let userId: String
    let isTyping: Bool
    let timestamp: Date
}
