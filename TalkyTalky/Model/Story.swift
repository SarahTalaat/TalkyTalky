//
//  Story.swift
//  TalkyTalky
//
//  Created by Sara Talat on 24/01/2025.
//
import Foundation

struct Story: Codable {
    let id: String
    let userId: String
    let mediaUrl: String
    let caption: String?
    let type: StoryType
    let timestamp: Date
    let expiresAt: Date
}

enum StoryType: String, Codable {
    case image
    case text
    case video
}
