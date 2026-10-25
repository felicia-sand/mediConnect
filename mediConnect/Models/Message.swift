// Message.swift
// MediConnect — Models
//
// Created by Felicia on 25/10/2026.

import Foundation

// MARK: - Message Type
enum MessageType: String, Codable {
    case text       = "text"
    case image      = "image"
    case document   = "document"
    case system     = "system"
}

// MARK: - Message Model
struct Message: Identifiable, Codable, Hashable {
    let id: String
    var conversationId: String
    var senderId: String
    var receiverId: String
    var content: String
    var type: MessageType
    var mediaURL: String?
    var isRead: Bool
    var sentAt: Date
    
    var isFromCurrentUser: Bool = false
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: sentAt)
    }
}

// MARK: - Conversation Model
struct Conversation: Identifiable, Codable, Hashable {
    let id: String
    var participantIds: [String]
    var lastMessage: Message?
    var unreadCount: Int
    var updatedAt: Date
    
    // Populated from participant lookup
    var otherUser: User?
    
    var lastMessagePreview: String {
        guard let msg = lastMessage else { return "No messages yet" }
        switch msg.type {
        case .text:     return msg.content
        case .image:    return "📷 Photo"
        case .document: return "📄 Document"
        case .system:   return msg.content
        }
    }
}
