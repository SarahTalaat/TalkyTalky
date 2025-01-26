//
//  Notification.swift
//  TalkyTalky
//
//  Created by Sara Talat on 24/01/2025.
//

import Foundation

struct Notification: Codable {
    let id: String
    let userId: String // The user who receives the notification
    let type: NotificationType
    let title: String
    let message: String
    let relatedId: String? // Can reference a chat, message, or group ID
    let isRead: Bool
    let timestamp: Date
}

enum NotificationType: String, Codable {
    case newMessage
    case groupInvite
    case storyView
    case mention
    case other
}
