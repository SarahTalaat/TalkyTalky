//
//  MediaUpload.swift
//  TalkyTalky
//
//  Created by Sara Talat on 24/01/2025.
//

import Foundation

struct MediaUpload {
    let fileName: String
    let data: Data
    let mediaType: MediaType
}

enum MediaType: String {
    case image
    case video
    case audio
    case document
}


