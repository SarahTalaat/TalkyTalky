//
//  Network.swift
//  TalkyTalky
//
//  Created by Sara Talat on 24/01/2025.
//


import Foundation
import FirebaseFirestore

class FirestoreManager {
    private let db = Firestore.firestore()

    // Fetch all chats for a specific user
    func fetchChats(for userId: String, completion: @escaping (Result<[Chat], Error>) -> Void) {
        db.collection("chats")
            .whereField("participants", arrayContains: userId)
            .order(by: "lastMessageTimestamp")
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                var chats: [Chat] = []
                snapshot?.documents.forEach { document in
                    guard let chat = self.chat(from: document) else {
                        return
                    }
                    chats.append(chat)
                }
                completion(.success(chats))
            }
    }

    // Fetch specific chat details
    func fetchChatDetails(chatId: String, completion: @escaping (Result<Chat, Error>) -> Void) {
        db.collection("chats")
            .document(chatId)
            .getDocument { document, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let document = document, document.exists,
                      let chat = self.chat(from: document) else {
                    completion(.failure(NSError(domain: "Chat not found", code: 404, userInfo: nil)))
                    return
                }
                completion(.success(chat))
            }
    }

    // Save a new chat message
    func saveChatMessage(chat: Chat, message: Message, completion: @escaping (Result<Void, Error>) -> Void) {
        let chatData = self.chatToDictionary(chat: chat)
        
        db.collection("chats").addDocument(data: chatData) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Save the message
            let messageData = self.messageToDictionary(message: message)
            self.db.collection("messages").addDocument(data: messageData) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(()))
            }
        }
    }

    // Update a chat (e.g., add a new message)
    func updateChat(chatId: String, newMessage: Message, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("chats")
            .document(chatId)
            .updateData([
                "lastMessage": newMessage.text ?? "",
                "lastMessageTimestamp": newMessage.timestamp
            ]) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                // Save the new message
                let messageData = self.messageToDictionary(message: newMessage)
                self.db.collection("messages").addDocument(data: messageData) { error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    completion(.success(()))
                }
            }
    }

    // Fetch all contacts
    func fetchAllContacts(completion: @escaping (Result<[Contact], Error>) -> Void) {
        db.collection("contacts")
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                var contacts: [Contact] = []
                snapshot?.documents.forEach { document in
                    guard let contact = self.contact(from: document) else {
                        return
                    }
                    contacts.append(contact)
                }
                completion(.success(contacts))
            }
    }

    // Fetch user profile
    func fetchUserProfile(userId: String, completion: @escaping (Result<User, Error>) -> Void) {
        db.collection("users")
            .document(userId)
            .getDocument { document, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let document = document, document.exists,
                      let userProfile = self.user(from: document) else {
                    completion(.failure(NSError(domain: "User not found", code: 404, userInfo: nil)))
                    return
                }
                completion(.success(userProfile))
            }
    }

    // Update user profile
    func updateUserProfile(userId: String, profile: User, completion: @escaping (Result<Void, Error>) -> Void) {
        let userProfileData = self.userToDictionary(user: profile)
        db.collection("users")
            .document(userId)
            .updateData(userProfileData) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(()))
            }
    }

    // Save group chat info
    func saveGroupChat(groupChat: Group, completion: @escaping (Result<Void, Error>) -> Void) {
        let groupData = self.groupToDictionary(groupChat: groupChat)
        db.collection("groupChats").addDocument(data: groupData) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }
    }

    // Fetch group members
    func fetchGroupMembers(groupId: String, completion: @escaping (Result<[Contact], Error>) -> Void) {
        db.collection("groupChats")
            .document(groupId)
            .collection("members")
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                var members: [Contact] = []
                snapshot?.documents.forEach { document in
                    guard let member = self.contact(from: document) else {
                        return
                    }
                    members.append(member)
                }
                completion(.success(members))
            }
    }

    // MARK: - Model Conversion Helpers

    private func chat(from document: DocumentSnapshot) -> Chat? {
        guard let data = document.data() else { return nil }
        let id = document.documentID
        let participants = data["participants"] as? [String] ?? []
        let lastMessage = data["lastMessage"] as? String ?? ""
        let lastMessageTimestamp = (data["lastMessageTimestamp"] as? Timestamp)?.dateValue() ?? Date()
        let isGroupChat = data["isGroupChat"] as? Bool ?? false
        let groupName = data["groupName"] as? String
        let groupImageUrl = data["groupImageUrl"] as? String
        return Chat(id: id, participants: participants, lastMessage: lastMessage, lastMessageTimestamp: lastMessageTimestamp, isGroupChat: isGroupChat, groupName: groupName, groupImageUrl: groupImageUrl)
    }

    private func contact(from document: DocumentSnapshot) -> Contact? {
        guard let data = document.data() else { return nil }
        let id = document.documentID
        let name = data["name"] as? String ?? ""
        let phoneNumber = data["phoneNumber"] as? String ?? ""
        let profileImageUrl = data["profileImageUrl"] as? String
        let status = data["status"] as? String ?? ""
        return Contact(id: id, name: name, phoneNumber: phoneNumber, profileImageUrl: profileImageUrl, status: status)
    }

    private func user(from document: DocumentSnapshot) -> User? {
        guard let data = document.data() else { return nil }
        let id = document.documentID
        let name = data["name"] as? String ?? ""
        let phoneNumber = data["phoneNumber"] as? String ?? ""
        let profileImageUrl = data["profileImageUrl"] as? String
        let status = data["status"] as? String ?? ""
        let isOnline = data["isOnline"] as? Bool ?? false
        let lastSeen = (data["lastSeen"] as? Timestamp)?.dateValue()
        return User(id: id, name: name, phoneNumber: phoneNumber, profileImageUrl: profileImageUrl, status: status, isOnline: isOnline, lastSeen: lastSeen)
    }

    private func groupToDictionary(groupChat: Group) -> [String: Any] {
        var data: [String: Any] = [
            "name": groupChat.name,
            "adminId": groupChat.adminId,
            "members": groupChat.members,
            "createdAt": groupChat.createdAt
        ]
        if let groupImageUrl = groupChat.groupImageUrl {
            data["groupImageUrl"] = groupImageUrl
        }
        return data
    }

    private func messageToDictionary(message: Message) -> [String: Any] {
        var data: [String: Any] = [
            "senderId": message.senderId,
            "chatId": message.chatId,
            "text": message.text ?? "",
            "mediaUrl": message.mediaUrl ?? "",
            "messageType": message.messageType.rawValue,
            "timestamp": message.timestamp,
            "isRead": message.isRead
        ]
        return data
    }

    private func userToDictionary(user: User) -> [String: Any] {
        var data: [String: Any] = [
            "name": user.name,
            "phoneNumber": user.phoneNumber,
            "status": user.status,
            "isOnline": user.isOnline,
            "lastSeen": user.lastSeen ?? Date()
        ]
        if let profileImageUrl = user.profileImageUrl {
            data["profileImageUrl"] = profileImageUrl
        }
        return data
    }

    private func chatToDictionary(chat: Chat) -> [String: Any] {
        var data: [String: Any] = [
            "participants": chat.participants,
            "lastMessage": chat.lastMessage,
            "lastMessageTimestamp": chat.lastMessageTimestamp,
            "isGroupChat": chat.isGroupChat
        ]
        if let groupName = chat.groupName {
            data["groupName"] = groupName
        }
        if let groupImageUrl = chat.groupImageUrl {
            data["groupImageUrl"] = groupImageUrl
        }
        return data
    }


}
