//
//  Message.swift
//  TalkyTalky
//
//  Created by Sara Talat on 24/01/2025.
//

import Foundation

struct Message: Codable {
    let id: String
    let senderId: String
    let chatId: String
    let text: String?
    let mediaUrl: String?
    let messageType: MessageType
    let timestamp: Date
    let isRead: Bool
}

enum MessageType: String, Codable {
    case text
    case image
    case video
    case audio
    case document
    case sticker
    case location
    case contact
    case poll
}
