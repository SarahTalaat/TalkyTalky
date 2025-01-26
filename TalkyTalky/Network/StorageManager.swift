//
//  FirebaseStorage.swift
//  TalkyTalky
//
//  Created by Sara Talat on 24/01/2025.
//

import Foundation
import FirebaseStorage

class StorageManager {
    private let storage = Storage.storage()

    // Upload any media to Firebase Storage based on its type (image, video, audio, document)
    func uploadMedia(mediaUpload: MediaUpload, completion: @escaping (Result<String, Error>) -> Void) {
        let fileExtension: String
        var folder: String

        // Determine file extension and folder based on media type
        switch mediaUpload.mediaType {
        case .image:
            fileExtension = "jpg"
            folder = "photos"
        case .video:
            fileExtension = "mp4"
            folder = "videos"
        case .audio:
            fileExtension = "mp3"
            folder = "audios"
        case .document:
            fileExtension = "pdf"
            folder = "documents"
        }

        let storageRef = storage.reference().child("\(folder)/\(UUID().uuidString).\(fileExtension)")

        // Upload media data to Firebase Storage
        storageRef.putData(mediaUpload.data, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            // Get the download URL after upload
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let url = url else {
                    completion(.failure(NSError(domain: "URL", code: 0, userInfo: nil)))
                    return
                }
                completion(.success(url.absoluteString))
            }
        }
    }

    // Fetch a file (image, video, document) from Firebase Storage using URL
    func fetchFile(from url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let storageRef = storage.reference(forURL: url)
        storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "FileError", code: 0, userInfo: nil)))
                return
            }
            completion(.success(data))
        }
    }
}
