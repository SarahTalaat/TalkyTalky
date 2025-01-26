//
//  Reaction.swift
//  TalkyTalky
//
//  Created by Sara Talat on 24/01/2025.
//

import Foundation

struct Reaction: Codable {
    let id: String
    let userId: String
    let messageId: String? // Reaction to a message
    let storyId: String? // Reaction to a story
    let reactionType: ReactionType
    let timestamp: Date
}

enum ReactionType: String, Codable {
    case like
    case love
    case laugh
    case angry
    case sad
}

